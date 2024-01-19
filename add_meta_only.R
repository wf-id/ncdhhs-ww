library(data.table)


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

o[,max(date_new)]

data.table::fwrite(o, here::here("output", "ncww.csv"))
