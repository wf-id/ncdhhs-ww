if(dir.exists(here::here("data"))){
    cat("Previous files existing. Removing\n")
    fs::dir_delete(here::here("data"))
    fs::dir_delete(here::here("image"))
    fs::file_delete("covid.zip")
}


target <- fs::dir_ls("input")

fs::file_copy(target, "covid.zip", overwrite = TRUE)

available_files <- unzip("covid.zip", list = TRUE)

str(available_files)

to_extract <- available_files[["Name"]][grepl(available_files[["Name"]], pattern = "hyper")]

cli::cli_alert("Now unzipping files")

unzip("covid.zip", files = to_extract, exdir = "test")
cli::cli_alert_success("Files unzipped")


move_to_local <- as.vector(fs::dir_ls("test", glob = "*hyper", recurse = TRUE))

if(!fs::dir_exists("data")){
    fs::dir_create("data")
}

str(move_to_local)

cli::cli_inform("Moving files")
fs::file_copy(move_to_local, "data")
cli::cli_alert_success("Moved!")

fs::dir_delete("test")
