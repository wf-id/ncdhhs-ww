library(EpiSewer)
library(data.table)
library(cmdstanr)
options(mc.cores = 4) # allow stan to use 4 cores, i.e. one for each chain

# get the data ------------------------------------------
get_nc_ww <- function(counties = NULL){
    dat_raw <- data.table::fread(here::here("output", "latest.csv"))



    dat_counts <- readRDS(here::here("data-raw", "counties.rds"))
    dat_raw <- dat_raw |>
       dplyr::mutate(county_names = strsplit(as.character(county_names), ","))  |>
       tidyr::unnest(county_names) |>
        dplyr::select(county_names, dplyr::everything()) |>
       dplyr::mutate(county_names = stringr::str_to_title(county_names)) |>
        dplyr::left_join(dat_counts, by = c("county_names" = "NAME")) |>
        dplyr::filter(!is.na(sars_cov2_raw_copiesL)) |>
       data.table::as.data.table()


       return(dat_raw)

}

o <- get_nc_ww()

dat_raw[date_new==max(date_new)]

dat_raw <- data.table::fread(here::here("output", "latest.csv"))
dat_raw[,smooth_normalised := data.table::frollmean(sars_cov2_normalized, 3), by = "county_names"]
dat_raw[,flow := sars_cov2_normalized*population_served/sars_cov2_raw_copiesL]

# Prep for pipeline ------------------------------------------
dat_all <- split(dat_raw, dat_raw$county_names)

# Pipeline function ------------------------------------------

run_pipeline <- function(dat, duration = 20, load_per_case = 1.5e+10){
  dat_one <- tail(dat[flow!=Inf], duration)
  measurements <- dat_one[,list(date = date_new, concentration = sars_cov2_raw_copiesL)]
  flows <- padr::pad(dat_one[,list(date = as.Date(date_new), flow)])
  flows$flow <- forecast::na.interp(ts(flows$flow, frequency = 7))
  flows[, flow := zoo::na.locf(flow)]
  flows$flow <- rnorm(nrow(flows),flows$flow, 100)
  ww_data <- sewer_data(measurements = measurements, flows = flows)
  cases <- dat_one[,list(date = date_new, cases = cases_new_cens_per10k * population_served/10000)]
  generation_dist <- get_discrete_gamma_shifted(gamma_mean = 3, gamma_sd = 2.4, maxX = 12)
  incubation_dist <- get_discrete_gamma(gamma_shape = 8.5, gamma_scale = 0.4, maxX = 10)
  shedding_dist <- get_discrete_gamma(gamma_shape = 0.929639, gamma_scale = 7.241397, maxX = 30)
  ww_assumptions <- sewer_assumptions(
  generation_dist = generation_dist,
  incubation_dist = incubation_dist,
  shedding_dist = shedding_dist,
  load_per_case = load_per_case
)

ww_result <- EpiSewer(
  data = ww_data,
  assumptions = ww_assumptions,
  infections = model_infections(R = R_estimate_rw()),
  fit_opts = set_fit_opts(sampler = sampler_stan_mcmc(iter_warmup = 1000, iter_sampling = 1000, chains = 4))
)

return(ww_result)
}

# Single Test------------------------------------------

safe_run_pipeline <- purrr::safely(run_pipeline)

output <- purrr::map(dat_all, safe_run_pipeline)

saveRDS(output, here::here("all-ww-R.rds"))

z <- readRDS(here::here("all-ww-R.rds"))

library(EpiSewer())

plot_R(z$Mecklenburg)

plot_R(z$Cabarrus)

plot_R(z$Union)
