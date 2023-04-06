#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Apr  3 18:55:42 2023
@author: lpluo
"""
from netCDF4 import Dataset
import matplotlib.pyplot as plt
import numpy as np
import cartopy.crs as ccrs
import cartopy.feature as cfeature
import cartopy.io.shapereader as shpreader
import cartopy.mpl.ticker as cticker
import cmaps

mon = '01'

era5_data = Dataset(r'/Volumes/LLP_CMC/era5_2022_01_02months/era5_' + mon + '.nc',mode = 'r')
print(era5_data)
print(era5_data.variables)
print(era5_data.dimensions)

lons = era5_data.variables['longitude'][:]
lats = era5_data.variables['latitude'][:]
# print(lons)
# print(lats)
T = era5_data.variables['t'][:] - 273.15 # unit to 摄氏度
rh = era5_data.variables['r'][:]
ww = era5_data.variables['w'][:]
qci = era5_data.variables['ciwc'][:]
qcl = era5_data.variables['clwc'][:]
qr = era5_data.variables['crwc'][:]
qs = era5_data.variables['cswc'][:]

rh_ave=np.average(rh,axis=0)
T_ave=np.average(T,axis=0)
rh_ave[rh_ave > 100.0] = np.nan
rh_ave[rh_ave < 0.0] = np.nan

# print(rh_ave.shape)
# print(np.max(rh_ave))
# print(np.min(rh_ave))
#
# print(np.max(T_ave))
# print(np.min(T_ave))

ic_index = 2*(rh_ave-50)*(T_ave*(T_ave+14)/-49)
# print(ic_index.shape)

# 创建画布、添加子图、设置画图范围
for kk in range(6):
    print(kk)
    fig = plt.figure(figsize=(9, 9))
    ax = fig.add_subplot(1, 1, 1, projection=ccrs.PlateCarree())
    # extend 设置在contourf里的，否则不会画两端的色标；
    cf = ax.contourf(lons,lats,ic_index[kk,:,:],np.arange(0,90,10),cmap='binary',extend='both',transform=ccrs.PlateCarree())
    fig.colorbar(cf,ax=ax,fraction=0.025,orientation='vertical',pad=0.05)

    ax.set_extent([70,140,10,55])
    ax.set_xticks(np.arange(70,150,10))
    ax.set_yticks(np.arange(10,55,10))
    ax.xaxis.set_major_formatter(cticker.LongitudeFormatter())
    ax.yaxis.set_major_formatter(cticker.LatitudeFormatter())

    ax.set_title('IC_index_ave_'+ mon + '_level_' + str(kk) ,loc='center',fontsize=15,fontweight='bold')

    #添加海岸线等特征
    ax.add_feature(cfeature.COASTLINE.with_scale('50m'))
    china = shpreader.Reader("/Users/lpluo/Desktop/20210430_Cold_Vortex/observations/bou2_4l.dbf").geometries()
    #添加中国国界省界九段线等
    ax.add_geometries(china, ccrs.PlateCarree(),facecolor='none', edgecolor='black',zorder = 1)

    plt.savefig('/Volumes/LLP_CMC/era5_2022_01_02months/ic_index_'+ mon + '_level_' + str(kk) + '.pdf')
    # plt.show()

    ff = open(r'/Volumes/LLP_CMC/era5_2022_01_02months/data_T_rh_ICindex.txt', 'a')
    dims = T_ave.shape
    print(dims)
    print(dims[0])
    print(dims[1])

    # '\n' 为换行显示
    for i in range(dims[1]):
        for j in range(dims[2]):
            ff.write(str(kk) + ' ' + str(T_ave[kk,i,j]) + ' ' + str(rh_ave[kk,i,j]) + ' ' + str(ic_index[kk,i,j]) + '\n')

ff.close()





