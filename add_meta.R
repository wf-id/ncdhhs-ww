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

data.table::fwrite(o, here::here("output", "ncww.csv"))

48863073/119582.61

dat_raw[,smooth_normalised := data.table::frollmean(sars_cov2_normalized, 3), by = "county_names"]
       dat_raw[,flow := sars_cov2_normalized*population_served/sars_cov2_raw_copiesL]

library(EpiSewer)
library(data.table)

dat_one <- dat_raw[county_names=="Forsyth"][flow!=Inf]

measurements <- dat_one[,list(date = date_new, concentration = sars_cov2_raw_copiesL)]

flows <- padr::pad(dat_one[,list(date = as.Date(date_new), flow)])

flows[, flow := zoo::na.locf(flow)]

flows$flow <- rnorm(nrow(flows),flows$flow, 100)

ww_data <- sewer_data(measurements = measurements, flows = flows)

cases <- dat_one[,list(date = date_new, cases = cases_new_cens_per10k * 340)]

generation_dist <- get_discrete_gamma_shifted(gamma_mean = 3, gamma_sd = 2.4, maxX = 12)
incubation_dist <- get_discrete_gamma(gamma_shape = 8.5, gamma_scale = 0.4, maxX = 10)
shedding_dist <- get_discrete_gamma(gamma_shape = 0.929639, gamma_scale = 7.241397, maxX = 30)

library(cmdstanr)
suggest_load_per_case(
  measurements,
  cases,
  flows,
  ascertainment_prop = 1
)

load_per_case <- 8e+8

ww_assumptions <- sewer_assumptions(
  generation_dist = generation_dist,
  incubation_dist = incubation_dist,
  shedding_dist = shedding_dist,
  load_per_case = load_per_case
)

options(mc.cores = 4) # allow stan to use 4 cores, i.e. one for each chain
ww_result <- EpiSewer(
  data = ww_data,
  assumptions = ww_assumptions,
  infections = model_infections(R = R_estimate_rw()),
  fit_opts = set_fit_opts(sampler = sampler_stan_mcmc(iter_warmup = 1000, iter_sampling = 1000, chains = 4))
)

data_zurich <- SARS_CoV_2_Zurich
measurements_sparse <- data_zurich$measurements[,weekday := weekdays(data_zurich$measurements$date)][weekday %in% c("Monday","Thursday"),]
head(measurements_sparse, 20)
ww_data <- sewer_data(measurements = measurements_sparse, flows = data_zurich$flows)
load_per_case <- 6e+11
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
