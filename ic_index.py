#!/usr/bin/env python
# -*- coding:utf-8 -*-
# @Time : 2023/4/3 18:31
# @Author : LIPING LUO
# @File : ic_index.py

from netCDF4 import Dataset
import matplotlib.pyplot as plt
import cartopy.crs as ccrs
import cartopy.feature as cfeature
import cartopy.mpl.ticker as cticker
import cartopy.io.shapereader as shpreader
import numpy as np
import cmaps


