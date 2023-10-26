#!/bin/bash


# urls=( https://stratus.rda.ucar.edu/ds633.0/e5.oper.an.sfc/198010/e5.oper.an.sfc.128_167_2t.ll025sc.1980100100_1980103123.nc )\
# elon=85
# wlon=75
# nlat=70
# slat=40
# bucket=gs://ncar-subset-target/test-user-target/
wget $1
file=$(echo "$1" | sed 's:.*/::')
./netcdf_subset.py $file /share/subset_$file elon=$2 wlon=$3 nlat=$4 slat=$5

if [ "$6" = "" ]; then
echo "No storage bucket selected, subset data will not be sent"
else
gsutil rsync -r /share "$6"
fi
# elon=85 wlon=75 nlat=70 slat=40