#!/usr/bin/env python
# -*- coding:utf-8 -*-
# @Time : 2023/3/17 10:25
# @Author : LIPING LUO
# @File : station_map.py
# 只有需要转换投影方式的时候，才需要设置 transform,scatter和text的transform要一致，要么都设置，要么都不设置，否则报错

#导入python库，这些库需要提前安装，pycharm->settings->python interpreter-> + -> search libs and install, successed installed.
import pandas as pd
import matplotlib.pyplot as plt  # python画图的库，可以画比如线图、散点图、条形图、柱状图、3d图等
import cartopy.crs as ccrs   #地理制图的库：basemap是基于puthon2的，而2不再维护，接班的是cartopy；
import cartopy.feature as cfeature
import cartopy.mpl.ticker as cticker
import cartopy.io.shapereader as shpreader
import numpy as np
import math
'''
 read surface obs data with pb.read_csv function;
 sep='\s+': 文档分格符：无论多位分隔符由什么组成--good
 header： 可设可不设：表示第一行为表头；默认也是第一行表头，不读取，从第二行开始度；
'''
data = pd.read_csv("/Users/lpluo/Desktop/UPAR_CHN_MUL_MIN-2021043000.TXT",sep='\s+',header=0,\
                   usecols=["Station_Id_d","Lat","Lon","Alti"])

data[data == 999999] = np.nan
data.Station_Id_d[data.Station_Id_d > 100000] = np.nan
data.Alti[data.Alti > 10000] = np.nan

'''
创建输出文件，open， 'w':表示每次都重新打开，写入；
print(...,file=f1)：表示直接输出写入到文件中；
或者 f1.write(str(i)+'\n')，记得 f1.close
'''

# 开始画图
# 打开一个总的画布
fig = plt.figure(figsize=(12, 12))
#在画布中添加一个子区域，设置等距圆柱投影，调用 cartopy.crs，绘制地图，并返回这个子区域给ax1，
#几乎所有的画图操作都是在axes上完成的
ax = fig.add_subplot(1,1,1,projection = ccrs.PlateCarree())
# ax = plt.subplot(1,1,1)

#在子区域ax1上，设置图形范围及坐标轴刻度标注
ax.set_extent([70,140,15,55])
ax.set_xticks(np.arange(70,120,10))
ax.set_yticks(np.arange(15,60,10))
ax.xaxis.set_major_formatter(cticker.LongitudeFormatter())
ax.yaxis.set_major_formatter(cticker.LatitudeFormatter())

# 设置子区域ax1的图片标题: 内容、位置、字体大小、粗细
ax.set_title("sounding stations",loc='center',fontsize=20,fontweight='bold')
#绘制站点分布，plt.scatter,参数很多，常用的也就是x，y坐标，s：形状的大小，默认为20，s=20;c：形状的颜色，c='g，marker：'o'
# s = ax1.scatter(data.Lon[::10],data.Lat[::10],c=data.Alti[::10]cmap='jet',transform=ccrs.PlateCarree())
# 只有需要转换投影方式的时候，才需要设置 transform
s=ax.scatter(data.Lon[::10],data.Lat[::10],c=data.Alti[::10],cmap='jet',alpha=0.5)

f1=open("/Users/lpluo/Desktop/station_id.txt","w")

for i in range(0,len(data.Station_Id_d),10):
    if math.isnan(data.Station_Id_d[i]):
        print('NAN' + " " + str(i))
    else:
        lon=float(data.Lon[i])
        lat=float(data.Lat[i])
        # if data.Station_Id_d[i]>58000:
        #     print(int(data.Station_Id_d[i]),file=f1)
        ax.text(lon*1.01,lat*1.02,str(int(data.Station_Id_d[i])),fontsize=6,style='italic',\
                weight='light',verticalalignment='center',horizontalalignment='right',rotation=0)

f1.close()

#添加色标，ax=ax1,表示在ax1子区域旁边添加色标;fraction参数设置色标缩放比例;orientation表示色标的方位
#对多个子区域的色标，可以通过ax设置为哪个子区域添加色标；,
fig.colorbar(s,ax=ax,fraction=0.025,orientation='vertical',pad=0.05)
#添加海岸线等特征
ax.add_feature(cfeature.COASTLINE.with_scale('50m'))
china = shpreader.Reader("/Users/lpluo/Desktop/20210430_Cold_Vortex/observations/bou2_4l.dbf").geometries()
#在ax1子图区域添加中国国界省界九段线等
ax.add_geometries(china, ccrs.PlateCarree(),facecolor='none', edgecolor='black',zorder = 1)
#保存图片，路径+名称，图片分辨率:每英寸300个像素，缺省为80；
#bbox_inches="tight"：表示去除图片周围的空白部分
# plt.savefig("/Users/lpluo/Desktop/20210430_Cold_Vortex/observations/sations_soundings.png",dpi=200,bbox_inches="tight")
plt.savefig("/Users/lpluo/Desktop/20210430_Cold_Vortex/observations/sations_soundings"+'.pdf')

plt.show()