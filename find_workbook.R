library(tidyverse) 
#setwd("scrape")
current_time <- format(Sys.time(), "%Y%m%d%H%M")
fs::dir_create("out-data")
cat(getwd())
print(getwd())
# dowload latest file -----------------------------------------------------
library(rvest)
library(httr)

ses <-html_session("https://covid19.ncdhhs.gov/dashboard/data-behind-dashboards")

ses %>%
  read_html() %>%
  as.character()->a


wb_candidates <- unique(str_extract_all(a,pattern = "NCDHHS_COVID-19_DataDownload_Story_\\d+")[[1]])

cat(wb_candidates, sep = "\n")

cli::cat_rule()

target_wb <- tail(wb_candidates,1)

cat("Target workbook for this scrape: ", target_wb)

cli::cat_rule()

url_target <- sprintf("https://public.tableau.com/views/%s/DataBehindtheDashboards.twbx",
                      target_wb)

x = httr::GET(url = url_target)

if(status_code(x)!= 200){
  stop("Could not find workbook")
}

bin <- httr::content(x, "raw")

writeBin(bin, here::here("input","NCDHHS_COVID.twbx"))
cat("Success.\n")

