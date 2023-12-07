all: prep retrieve unzip write

# Remove the unncessary files from prior runs
prep:
    rm -rf *.twb
    rm -rf Data
    rm -rf Image
    rm -f covid.zip
    rm -f hyperd.log

# Find target notebook and download
retrieve:
    Rscript find_workbook.R

# Unzip the twbx file exposing hyper files
unzip:
    Rscript break.R

# Read the hyper files and write out the wastewater data
write:
    python read.py