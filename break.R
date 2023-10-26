if(dir.exists(here::here("data"))){
    cat("Previous files existing. Removing\n")
    fs::dir_delete(here::here("data"))
    fs::dir_delete(here::here("image"))
    fs::file_delete("covid.zip")
}


target <- fs::dir_ls("input")

fs::file_copy(target, "covid.zip", overwrite = TRUE)

unzip("covid.zip")

