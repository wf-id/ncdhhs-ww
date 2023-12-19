all: prep retrieve unzip write

# Remove the unncessary files from prior runs
prep:
    echo "removing old files"
    rm -rf *.twb
    rm -rf Data
    rm -rf Image
    rm -f covid.zip
    rm -f hyperd.log
    rm -rf data
    rm -rf test

# Find target notebook and download
retrieve:
    echo "Finding workbook on website---"
    Rscript find_workbook.R

# Unzip the twbx file exposing hyper files
unzip:
    echo "Unzipping workbook---"
    Rscript break.R

# Read the hyper files and write out the wastewater data
write:
    echo "Reading hyper files and extracting latest"
    python read.py