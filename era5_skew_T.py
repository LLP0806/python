#!/usr/bin/env python
# -*- coding:utf-8 -*-
# @Time : 2023/3/28 18:42
# @Author : LIPING LUO
# @File : era5_skew_T.py

import matplotlib.pyplot as plt
# 如果我们已经安装matplotlib库，那么也会同时安装mpl_toolkits包。
# 这样，可以通过“import mpl_toolkits”语句，直接导入mpl_toolkits包.
from mpl_toolkits.axes_grid1.inset_locator import inset_axes
import numpy as np
import pandas as pd
# MetPy是一个用于气象数据分析的开源项目。包括数据的读写、天气学相关计算以及诊断分析可视化。
# 与其他 Python 库相比，MetPy的一大特点就是在传递给MetPy的函数之前，
# 通常需要将单位属性附加给数组，从而保证更高的计算准确性，不用再次进行单位的转换
from metpy.units import units
from metpy.cbook import get_test_data
from metpy.plots import add_metpy_logo, Hodograph, SkewT
# metpy.calc:Provide tools for unit-aware, meteorological calculations.有很多好用的气象诊断计算的函数
# from metpy.calc import parcel_profile,cape_cin,dewpoint_from_relative_humidity,wind_components
import metpy.calc as mpcal
#所有的ncl自带的colormap库，用cmap=cmaps.***nclcolormap name即可；
import cmaps
#通过matplotlib.ticker.MaxNLocator(nbins=n)来设置colorbar上的刻度值个数
import matplotlib.ticker as ticker

# Upper air data can be obtained using the siphon package, but for this example
# we will use some of MetPy’s sample data.

station_total = ['sounding_00UTC_117.25_34.25_58027_Xuzhou','sounding_00UTC_120.25_33.75_58150_Yancheng','sounding_00UTC_119_32_58238_Nanjing',\
                 'sounding_00UTC_121.5_31.5_58362_Shanghaibaoshan','sounding_12UTC_117.25_34.25_58027_Xuzhou','sounding_12UTC_120.25_33.75_58150_Yancheng',\
                 'sounding_12UTC_119_32_58238_Nanjing','sounding_12UTC_121.5_31.5_58362_Shanghaibaoshan',\
                 'sounding_06UTC_117.25_34.25_58027_Xuzhou','sounding_06UTC_119_32_58238_Nanjing','sounding_06UTC_120.25_33.75_58150_Yancheng','sounding_06UTC_121.5_31.5_58362_Shanghaibaoshan',\
                 'sounding_06UTC_123.5_34']
for i in range(len(station_total)):
    print(i)
    station_obstime = station_total[i]
    print(station_obstime)
# station_obstime = 'sounding_00UTC_117.25_34.25_58027_Xuzhou'  #徐州站
# station_obstime = 'sounding_00UTC_120.25_33.75_58150_Yancheng'  #盐城
# station_obstime = 'sounding_00UTC_119_32_58238_Nanjing'  #南京
# station_obstime = 'sounding_00UTC_121.5_31.5_58362_Shanghaibaoshan'  #上海宝山

# station_obstime = 'sounding_12UTC_117.25_34.25_58027_Xuzhou'  #徐州站
# station_obstime = 'sounding_12UTC_120.25_33.75_58150_Yancheng'
# station_obstime = 'sounding_12UTC_119_32_58238_Nanjing'
# station_obstime = 'sounding_12UTC_121.5_31.5_58362_Shanghaibaoshan'

    data = pd.read_csv('/Users/lpluo/Desktop/20210430_Cold_Vortex/observations/'+station_obstime+'.txt',sep='\s+',header=0,\
                       usecols=['PRES', 'HGHT', 'TMPC', 'DWPC', 'DRCT', 'SPED'])
    data[data == 999999] = np.nan

    # Drop any rows with all NaN values for 'TEM', 'RHU', 'WIN_D', 'WIN_S'
    # 如果data行中存在任何any一个缺测，则把axis=0整行去掉；并且drop=true删除原始行号，重置行号
    data = data.dropna(axis=0, how='any').reset_index(drop=True)
    data_no_duplicate = data.drop_duplicates()  # 删除重复行

    ##获取温压湿风信息
    # We will pull the data out of the example dataset into individual variables and assign units.
    # Dataframe values 函数使用：获取某一列的数据；
    height = data_no_duplicate['HGHT'].values # * units.gpm   # units:gph
    p = data_no_duplicate['PRES'].values # * units.hPa    # units:hPa
    T = data_no_duplicate['TMPC'].values  # * units.degC       # units:degC
    Td = data_no_duplicate['DWPC'].values # * units.percent                 # units: %
    wind_speed = data_no_duplicate['SPED'].values # * units("m/s")
    wind_dir = data_no_duplicate['DRCT'].values # * units.degrees

    # calculate dew point: in oC；通常需要将单位属性附加给数组，从而保证更高的计算准确性，不用再次进行单位的转换
    # Td = mpcal.dewpoint_from_relative_humidity(T * units.degC, rh * units.percent)
    # print(len(Td))
    # print(max(rh))
    u, v = mpcal.wind_components(wind_speed * units("m/s"), wind_dir * units.degrees) #units: m/s
    print(type(u))

    # metpy.calc中诊断计算的结果均带有单位，不方便实数运算，加.m可以得到变量的实属类型：即 Td.m， 可用于实数运算等
    data_new = [height,p,T,Td,wind_speed,wind_dir,u.m,v.m]

    # python 行列互换
    # map() 会根据提供的函数对指定序列做映射.
    # list(zip(a,b)) 函数用于将可迭代的对象作为参数，将a,b对象中对应的元素打包成一个个元组，然后返回由这些元组组成的列表.
    # *和** 在定义函数形参时，前面加*或者**有压缩的意思，为可传入任意长度的参数；
    # 在调用函数时，表示把列表解压成一个个参数，传入zip，逐一打包为元组；
    data_new_1 = list(map(list,zip(*data_new)))
    data_new_sorted = sorted(data_new_1,key=lambda x:x[0],reverse=False)

    height_new = []
    p_new = []
    T_new = []
    Td_new = []
    wind_speed_new = []
    wind_dir_new = []
    u_new = []
    v_new = []

    #二维列表遍历，好像不可以直接[0][:]，只可以整行处理，不可以整列处理？
    # 但是可以逐个元素去索引；
    #这里没办法，只能先把二维列表，逐个元素索引，然后添加到新建的空列表中，再得到新的一维列表；
    for i in range(len(data_new_sorted)):
        if data_new_sorted[i][1] >= 100:  # 只选取气压大于100hPa的值；
            height_new.append(data_new_sorted[i][0])
            p_new.append(data_new_sorted[i][1])
            T_new.append(data_new_sorted[i][2])
            Td_new.append(data_new_sorted[i][3])
            wind_speed_new.append(data_new_sorted[i][4])
            wind_dir_new.append(data_new_sorted[i][5])
            u_new.append(data_new_sorted[i][6])
            v_new.append(data_new_sorted[i][7])

    height_new = height_new* units.gpm
    p_new = p_new * units.hPa
    T_new = T_new * units.degC
    Td_new = Td_new * units.degC
    wind_speed_new = wind_speed_new * units("m/s")
    wind_dir_new = wind_dir_new * units.degrees
    u_new = u_new * units("m/s")
    v_new = v_new * units("m/s")

    # print(height_new)
    # print(p_new)

    ######## start to plot #############
    # Create a new figure. The dimensions here give a good aspect ratio
    fig = plt.figure(figsize=(9, 9))
    # add_metpy_logo(fig, 115, 100)

    # Grid for plots
    # The rotation keyword changes how skewed the temperature lines are. MetPy has
    # a default skew of 30 degrees
    skew = SkewT(fig, rotation=45)

    # Plot the data using normal plotting functions, in this case using
    # log scaling in Y, as dictated by the typical meteorological plot
    # plot temperature and dew point，颜色分别为红色和绿色
    # 添加legend：T,Td,T_parcel; 设置label，直接紧接着plt.legend(loc='lower left')：表示左下角
    skew.plot(p_new, T_new, 'r',linewidth=2.5,label='T')
    skew.plot(p_new, Td_new, 'g',linewidth=2.5,label='Td')

    # Draw parcel path，计算气块干绝热上升
    prof=mpcal.parcel_profile(p_new, T_new[0], Td_new[0])
    skew.plot(p_new,prof,'k',linestyle='dashed',linewidth=2.5,label='T_parcel')
    plt.legend(loc='lower left')

    # add wind bars：每隔1层画一个风向标，设置y轴范围1000hPa~100hPa
    skew.plot_barbs(p_new, u_new, v_new)

    # skew.plot_barbs(p_new[::30], u_new[::30], v_new[::30])

    # f1=open('/Users/lpluo/Desktop/20210430_Cold_Vortex/observations/data_sounding.txt','w')
    #calculate parcel temperature
    # print(T_new[0])
    # print(Td_new[0])
    # print(str(p_new),file=f1)

    #calculate surface based CAPE/CIN，level of free convection (LFC).
    cape, cin = mpcal.cape_cin(p_new,T_new,Td_new,prof)
    LFC = mpcal.lfc(p_new,T_new,Td_new)
    lcl_press, lcl_temp = mpcal.lcl(p_new[0],T_new[0],Td_new[0])  #
    K_index = mpcal.k_index(p_new,T_new,Td_new)
    Bulk_shear = mpcal.bulk_shear(p_new,u_new,v_new,height_new,depth=6 * units.km, bottom=height_new[0])

    print('cape ',cape.m)
    print('cin ',cin.m)
    print('LFC ',LFC)
    print(lcl_press, lcl_temp)
    print('Kindex ',K_index)
    print('BSH ',Bulk_shear)
    print(len(Bulk_shear))
    print(Bulk_shear)

    # Bulk_shear_total = np.sqrt(Bulk_shear.m[0]^2+Bulk_shear[1]^2)
    # print(Bulk_shear_total)
    # fig.suptitle(station_obstime,fontsize=16,y=0.9)
    plt.title('ERA5_' + station_obstime[9::] + '  ' + 'CAPE = ' + str(round(cape.m,2)) + ' J/Kilogram' + '  ' + 'CIN = ' + ' ' + str(round(cin.m,2)) + ' J/Kilogram', \
              loc='center', y=1, fontproperties='Times New Roman',size=14)
    plt.xlabel('Temperature (degree_Celsius)',size=14)
    plt.ylabel('Pressure (hPa)',size=14)
    plt.xticks(fontproperties='Times New Roman',size=14)
    plt.yticks(fontproperties='Times New Roman',size=14)

    # Add the relevant special lines
    skew.plot_dry_adiabats()
    skew.plot_moist_adiabats()
    skew.plot_mixing_lines()

    # Good bounds for aspect ratio,设置x轴温度范围，oC
    skew.ax.set_xlim(-60, 50)
    skew.ax.set_ylim(1000, 100)
    # skew.ax.text(30,150,'CAPE='+str(cape))
    # skew.ax.text(30,170,'CIN='+str(cin))
    # # plt.text(30,190,'LCL='+str(lcl_temp),str(lcl_press))
    # skew.ax.text(30,210,'LFC='+str(LFC))
    # skew.ax.text(30,230,'K_index='+str(K_index))
    # skew.ax.text(30,250,'BRS_6km='+str(Bulk_shear))

    # Create a hodograph
    # Create an inset axes with a given width and height.
    # Both sizes used can be specified either in inches or percentage.
    # inset_axes(parent_axes, width='40%', height='30%', loc=3)
    # loc=1,2,3,4   : 'upper right','upper left','lower left' ,'lower right'

    ax_hod = inset_axes(skew.ax, '28%', '28%', loc=2)
    h = Hodograph(ax_hod, component_range=60.)
    h.add_grid(increment=30)
    # l=h.plot_colormapped(u_new, v_new, height_new/1000.,cmap=cmaps.BlGrYeOrReVi200)
    l = h.plot_colormapped(u_new, v_new, height_new / 1000.)
    # l=h.plot_colormapped(u_new[::30], v_new[::30], height_new[::30]/1000.,cmap=cmaps.BlGrYeOrReVi200)

    # cax设置colorbar位置：很方便调整：四个参数：左 下 宽 高；这个设置好了之后，就不需要再设置shrink了，这个参数也是对colorbar设置缩放；
    # cax = fig.add_axes([ax_hod.get_position().x1+0.01,ax_hod.get_position().y0,0.02,ax_hod.get_position().height])
    cax = fig.add_axes([0.325,0.61,0.013,0.16])
    cb1 = plt.colorbar(l,cax=cax,orientation='vertical')
    # plt.colorbar(l,shrink=0.3,orientation='horizontal')
    # 设置colorbar的间隔数
    tick_locator = ticker.MaxNLocator(nbins=6)
    cb1.locator = tick_locator
    cb1.update_ticks()

    # Show the plot，先保存，后显示，否则会停在显示窗口
    plt.savefig('/Users/lpluo/Desktop/20210430_Cold_Vortex/observations/' + 'ERA5_' + station_obstime[9::] + '.pdf')
    # plt.show()

