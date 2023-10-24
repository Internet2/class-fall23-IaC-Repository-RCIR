#!/usr/bin/env python
"""
Subsets a netCDF file.
"""

__version__ = '0.1.0'
__author__ = 'Riley Conroy (rpconroy@ucar.edu)'

import sys
import os
import pdb
import argparse
import datetime
import xarray
import logging
import numpy

LOG_DIR = "./" # Default log file.
log_kwargs = {
        'filename' : os.path.join(LOG_DIR, "log.log"),
        'format' : '%(levelname)s:%(asctime)s:%(message)s',
        'datefmt' : '%Y-%m-%d %H:%M:%S',
        'level' : logging.DEBUG  # Can be DEBUG, INFO, WARNING, ERROR, CRITICAL
        }
default_subset_dir = "./"

def end_subset(message="Ending Program", errnum=1):
    """End processing and optionally provide error message and error number."""
    logging.error(message)
    exit(errnum)

def is_remote(filename):
    if filename[:4] == 'http':
        return True
    return False

def open_remote(filename):
    """Opens a remote (via http) netCDF file into an xarray dataset.
    """
    filename += "#mode=bytes"
    return xarray.open_dataset(filename, decode_coords=False)

def open_file(filename):
    """Opens a netCDF file into an xarray dataset.
    Will work on both local disk or Object storage.

    Args:
        filename(str): Name of remote or local file

    Returns:
        (xarray.Dataset): Dataset object

    """
    if is_remote(filename):
        return open_remote(filename)
    return xarray.open_dataset(filename)

def guess_primary_variable(ds):
    """Get variable most likely to be primary key.

    Args:
        ds (xarray:Dataset)

    Returns (str): Name of primary_key
    """
    most_dims_var = None
    most_dims = 0
    for k,v in ds.data_vars.items():
        if len(v.dims) > most_dims:
            most_dims_var = k
            most_dims = len(v.dims)
    return most_dims_var

def get_level_variable(ds, var=None):
    """Get level variable.
    """
    for k,v in ds.coords.items():
        if 'standard_name' in v.attrs and v.attrs['standard_name'] == 'height':
            return k
        if 'standard_name' in v.attrs and v.attrs['standard_name'] == 'air_pressure':
            return k
        if 'standard_name' in v.attrs and v.attrs['standard_name'] == 'depth':
            return k
        if k == 'theta':
            return k
    raise LevelNotFoundError()

def get_time_variable(ds):
    """Get Longitude Variable.
    Will try different methods for finding time in decreasing authority.
    """

    for k,v in ds.coords.items():
        if 'standard_name' in v.attrs and v.attrs['standard_name'] == 'time':
            return k
        if 'standard_name' in v.attrs and v.attrs['standard_name'] == 'forecast_reference_time':
            return k
        if 'long_name' in v.attrs and v.attrs['long_name'] == 'time':
            return k
        if 'short_name' in v.attrs and v.attrs['short_name'] == 'time':
            return k
        if k == 'time':
            return k
    # Raise error if not found
    raise TimeNotFoundError()

def get_longitude_variable(ds):
    """Get Longitude Variable.
    Will try different methods for finding lat in decreasing authority.
    """
    for k,v in ds.coords.items():
        if 'standard_name' in v.attrs and v.attrs['standard_name'] == 'longitude':
            return k
        if 'long_name' in v.attrs and v.attrs['long_name'] == 'longitude':
            return k
        if 'short_name' in v.attrs and v.attrs['short_name'] == 'lon':
            return k
        if k == 'longitude' or k == 'lon':
            return k
        if 'units' in v.attrs and v.attrs['units'] == 'degrees_east':
            return k
    # Raise error if not found
    raise latNotFoundError()


def get_latitude_variable(ds):
    """Get latitude Variable"""
    for k,v in ds.coords.items():
        if 'standard_name' in v.attrs and v.attrs['standard_name'] == 'latitude':
            return k
        if 'long_name' in v.attrs and v.attrs['long_name'] == 'latitude':
            return k
        if 'short_name' in v.attrs and v.attrs['short_name'] == 'lat':
            return k
        if k == 'latitude' or k == 'lat':
            return k
        if 'units' in v.attrs and v.attrs['units'] == 'degrees_north':
            return k
    # Raise error if not found
    raise lonNotFoundError()



def temporal_subset(ds, start_date=None, end_date=None, **args):
    """Temporally reduce dataset.

    Args:
        ds (xarray.Dataset): Dataset to be reduced
        start_date (str) : ISO formatted date.
        end_date : north ISO formatted date.

    Returns:
        (xarray.Dataset)
    """
    time = get_time_variable(ds)
    if start_date is None:
        start_date = time[0]
    if end_date is None:
        end_date = time[-1]

    if len(start_date) == 12: # rda standard
        start_date = datetime.datetime.strptime(start_date, '%Y%m%d%H%S')
    if len(end_date) == 12: # rda standard
        end_date = datetime.datetime.strptime(end_date, '%Y%m%d%H%S')

    time_mask = (ds[time] >= numpy.datetime64(start_date)) & (ds[time] <= numpy.datetime64(end_date))

    # subset each datavar
    new_vars = {}
    for k,v in ds.data_vars.items():
        if 'coordinates' in v.attrs:
            del v.attrs['coordinates'] # for serializing
        if time in v.dims:
            new_vars[k] = ds[k].isel({time:time_mask})
        else:
            new_vars[k] = v

    new_dataset = xarray.Dataset(new_vars)

    return new_dataset


def level_subset(ds, levels=None, **args):
    """Reduces dataset to only specifed levels

    Args:
        ds (xarray.Dataset): Dataset to be reduced
        levels (list): list of level keys

    Returns:
        (xarray.Dataset)
    """
    try:
        lev = get_level_variable(ds)
    except:
        if len(levels) <= 1:
            return ds
    lev_mask = None
    for level in levels:
        if lev_mask is not None:
            lev_mask = lev_mask | (ds[lev] == float(level))
        else:
            lev_mask = (ds[lev] == float(level))

    # subset each datavar
    new_vars = {}
    for k,v in ds.data_vars.items():
        if lev in v.dims:
            new_vars[k] = ds[k].isel({lev:lev_mask})
        else:
            new_vars[k] = v

    new_dataset = xarray.Dataset(new_vars)

    return new_dataset



def spatial_subset(ds, nlat=None, slat=None, elon=None, wlon=None, **args):
    """Spatially reduces dataset.

    Args:
        ds (xarray.Dataset): Dataset to be reduced
        nlat : north extent of latitude
        slat : south extent of latitude
        elon : east extent of longitude
        wlon : west  extent of longitude

    Returns:
        (xarray.Dataset)
    """

    # Deal with latitude
    if nlat is None:
        nlat = 90
    if slat is None:
        slat = -90
    lat = get_latitude_variable(ds)
    lat_mask = (ds[lat] <= float(nlat)) & (ds[lat] >= float(slat))

    # Deal with longitude
    if elon is None:
        elon = 0
    if wlon is None:
        wlon = 360
    lon = get_longitude_variable(ds)
    lon_mask = (ds[lon] <= float(elon)) & (ds[lon] >= float(wlon))
    #new_var = ds[var].isel({lat:lat_mask, lon:lon_mask})

    # subset each datavar
    new_vars = {}
    for k,v in ds.data_vars.items():
        if lon in v.dims and lat in v.dims:
            new_vars[k] = ds[k].isel({lat:lat_mask, lon:lon_mask})
        else:
            new_vars[k] = v

    new_dataset = xarray.Dataset(new_vars)

    return new_dataset



def subset(infile, outfile, **args):
    """Determine where infile and outfile will be and call appropriate subset routine."""
    subset_file(infile, outfile, **args)

def subset_file(infile, outfile, **args):
    """Given an infile, subset.
    kwargs keys may include:
    elon
    wlon
    nlat
    slat
    level
    """
    ds = open_file(infile)
    if 'nlat' in args or 'slat' in args or 'wlon' in args or 'elon' in args:
        new_ds = spatial_subset(ds, **args)
    if 'start_date' in args or 'end_date' in args:
        new_ds = temporal_subset(new_ds,**args)
    if 'levels' in args:
        new_ds = level_subset(new_ds, **args)

    new_ds.to_netcdf(outfile )

if __name__ == '__main__':
    """Calls subset if from command line."""
    if len(sys.argv) < 3:
        logging.basicConfig(**log_kwargs)
        logging.warning("Not enough arguments")
        exit(1)
    else:
        args = dict(item.split('=') for item in sys.argv[3:])
        if 'levels' in args:
            args['levels'] = args['levels'].split(',')
        subset(sys.argv[1], sys.argv[2], **args)

class LatNotFoundError(Exception):
    def __init__(self):
        self.message('Latitude variable not found in file')

class LonNotFoundError(Exception):
    def __init__(self):
        self.message('Longitude variable not found in file')

class TimeNotFoundError(Exception):
    def __init__(self):
        self.message('Time variable not found in file')

class LevelNotFoundError(Exception):
    def __init__(self):
        self.message('Level variable not found in file')
