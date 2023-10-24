#!/bin/bash
for file in `cat ERA5_TMP_2m.txt`; do 
    wget $file
    ./netcdf_subset.py $file subset_$file elon=85 wlon=75 nlat=70 slat=40
done
