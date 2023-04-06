#!/usr/bin/env python
# -*- coding:utf-8 -*-
# @Time : 2023/3/17 21:22
# @Author : LIPING LUO
# @File : station_numpy.py
import pandas as pd
import matplotlib.pyplot as plt
import cartopy.crs as ccrs
import cartopy.feature as cfeature
import cartopy.mpl.ticker as cticker
import cartopy.io.shapereader as shpreader
import numpy as np

data = pd.read_csv("/Users/lpluo/Desktop/UPAR_CHN_MUL_MIN-2021043000.TXT",sep='\s+',header=0,\
                   usecols=["Station_Id_d","Lat","Lon","Alti"])
print(data.Lat[::100])
print(data.Lon[::100])
print(data.Alti[::100])
print(data.Station_Id_d[::100])

fig = plt.figure(figsize=(15, 15))
ax1 = fig.add_subplot(1,1,1,projection = ccrs.PlateCarree(central_longitude=105) )
#设置图形范围及刻度
ax1.set_extent([70,140,10,60], crs=ccrs.PlateCarree())
ax1.set_xticks(np.arange(70,120,10), crs=ccrs.PlateCarree())
ax1.set_yticks(np.arange(10,70,10), crs=ccrs.PlateCarree())
ax1.xaxis.set_major_formatter(cticker.LongitudeFormatter())
ax1.yaxis.set_major_formatter(cticker.LatitudeFormatter())
ax1.set_title("sounding stations",loc='center',fontsize=15)

#绘制站点分布
s = ax1.scatter(data.Lon[::100],data.Lat[::100],cmap='jet',transform=ccrs.PlateCarree(),label=data.Station_Id_d)
plt.text(data.Lon[::100],data.Lat[::100],data.Station_Id_d[::100],fontsize=20,style='italic')
#添加色标，fraction参数设置色标缩放比例
# s = ax1.scatter(data.Lon,data.Lat,cmap='jet',transform=ccrs.PlateCarree())
fig.colorbar(s,ax=ax1,fraction=0.034)
#添加海岸线等特征
ax1.add_feature(cfeature.COASTLINE.with_scale('50m'))
china = shpreader.Reader("/Users/lpluo/Desktop/20210430_Cold_Vortex/observations/bou2_4l.dbf").geometries()
#添加中国国界省界九段线等
ax1.add_geometries(china, ccrs.PlateCarree(),facecolor='none', edgecolor='black',zorder = 1)
plt.savefig("/Users/lpluo/Desktop/20210430_Cold_Vortex/observations/sations_soundings.png",dpi=300)
plt.show()