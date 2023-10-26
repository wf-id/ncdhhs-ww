all: prep retrieve unzip write

prep:
    rm *.twb
    rm -rf Data
    rm -rf Image
    rm covid.zip
    rm hyperd.log

retrieve:
    Rscript find_workbook.R

unzip:
    Rscript break.R

write:
    python read.py