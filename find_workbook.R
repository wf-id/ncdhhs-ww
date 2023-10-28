# Purpose: The name of the workbook changes when the data are update
# This means you need to go to the webpage and find it.

library(tidyverse) 
current_time <- format(Sys.time(), "%Y%m%d%H%M")


# dowload latest file -----------------------------------------------------
library(rvest)
library(httr)

ses <-session("https://covid19.ncdhhs.gov/dashboard/data-behind-dashboards")

ses %>%
  read_html() %>%
  as.character()->a

# Looks for the pattern matching the tableau
wb_candidates <- unique(str_extract_all(a,pattern = "NCDHHS_COVID-19_DataDownload_Story_\\d+")[[1]])

cat(wb_candidates, sep = "\n")

cli::cat_rule()

target_wb <- tail(wb_candidates,1)

cat("Target workbook for this scrape: ", target_wb)

cli::cat_rule()

# USe this template code
generate_curl_cal <- glue::glue('
curl --silent \\\
  -H "Referer: https://public.tableau.com/app/profile/ncdhhs.covid19data/viz/{target_wb}/DataBehindtheDashboards?:display_static_image=n&:bootstrapWhenNotified=true&:embed=false&:language=en-US&:embed=y&:showVizHome=n&:apiID=host0#navType=2&navSrc=Parse" \\\
  "https://public.tableau.com/workbooks/{target_wb}.twb" > \\\
  input/NCDHHS_COVID.twbx
')

# Run the curl call
system(generate_curl_cal)
