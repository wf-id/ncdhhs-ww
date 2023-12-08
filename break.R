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

unzip("covid.zip", files = to_extract, exdir = "test")

move_to_local <- fs::dir_ls("test", glob = "*hyper", recurse = TRUE)

if(!fs::dir_exists("data")){
    fs::dir_create("data")
}

fs::dir_copy(move_to_local, "data")

unlink("test")
