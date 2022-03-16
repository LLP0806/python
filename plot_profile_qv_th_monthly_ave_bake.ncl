load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRF_contributed.ncl"

begin
;; read in tk and qv datasets
tkfile_cntl=addfile("/athenaData1/lpluo/run_jing_fromChinool_smb_part2/WRFV3_ParP_20172018_new_print/run/final_wrfout2/tk/tk_total_monthly_ave_bssub.nc", "r")
tkfile_blowoff=addfile("/athenaData1/lpluo/run_jing_fromChinool_smb_part2/WRFV3_ParP_20172018_new_print/run/final_wrfout2_noblow_off/tk/tk_total_monthly_ave_bssub.nc", "r")
qvfile_cntl=addfile("/athenaData1/lpluo/run_jing_fromChinool_smb_part2/WRFV3_ParP_20172018_new_print/run/final_wrfout2/Qtotal/qv_total_monthly_ave_bssub.nc", "r")
qvfile_blowoff=addfile("/athenaData1/lpluo/run_jing_fromChinool_smb_part2/WRFV3_ParP_20172018_new_print/run/final_wrfout2_noblow_off/Qtotal/qv_total_monthly_ave_bssub.nc", "r")

;; get variables TK and QVAPOR
tk_b=tkfile_cntl->tk_total
tk_blowoff=tkfile_blowoff->tk_total
qv_cntl=qvfile_cntl->qv_total
qv_blowoff=qvfile_blowoff->qv_total

qv_cntl=qv_cntl*1000.       ; unit from kg/kg to g/kg
qv_blowoff=qv_blowoff*1000.       ; unit from kg/kg to g/kg

printVarSummary(tk_b)

printMinMax(tk_b(3,:,:,:), True)

data=(/tk_b,tk_blowoff,qv_cntl,qv_blowoff/)
printVarSummary(data)

;;
wrffile=addfile("/athenaData1/lpluo/run_jing_fromChinool_smb_part2/WRFV3_ParP_20172018_new_print/run/final_wrfout2/wrfout_d02_2017-11-01_00:00:00", "r")
zz=wrf_user_getvar(wrffile, "z",0)     ; Full model height [m]

printVarSummary(zz)

iceshelf = addfile("/athenaData1/lpluo/run_jing_fromChinool_smb_part2/plots_1year_test_resolution/for_2018/for_paper_ERL/iceshelf_d02.nc", "r")
shelf = iceshelf->ICE_SHELF
istype = wrffile->ISLTYP

printVarSummary(shelf)
printVarSummary(istype)

shelf_temp = conform_dims(dimsizes(data), shelf, (/3,4/))
istype_temp = conform_dims(dimsizes(data), istype(0,:,:), (/3,4/))

data=where(shelf_temp .gt. 0.5 .and. shelf_temp .lt. 1.5, data, data@_FillValue)
data=where(istype_temp .eq. 16, data@_FillValue, data)
data(:,:,:,:,0:67)=data@_FillValue
data(:,:,:,170:,:)=data@_FillValue

data_file=addfile("./data_total.nc", "c")
data_file->data=data

shelf_temp_1=conform_dims(dimsizes(zz), shelf, (/1,2/))
istype_temp_1=conform_dims(dimsizes(zz), istype(0,:,:), (/1,2/))

zz=where(shelf_temp_1 .gt. 0.5 .and. shelf_temp_1 .lt. 1.5, zz, zz@_FillValue)
zz=where(istype_temp_1 .eq. 16, zz@_FillValue, zz)
zz(:,:,0:67)=zz@_FillValue
zz(:,170:,:)=zz@_FillValue

zz_ave=dim_avg_n(zz, (/1,2/))
printVarSummary(zz_ave)

printMinMax(data(0,:,:,:,:), True)
; data=where(data .gt. 10000, data@_FillValue, data)
printVarSummary(data)
data_ave_area=dim_avg_n(data, (/3,4/))

printVarSummary(data_ave_area)
printMinMax(data_ave_area, True)

;; plots
  res                    = True              ; plot mods desired
  res@gsnDraw            = False
  res@gsnFrame           = False
  res@gsnMaximize        = False
  res@tiMainPosition        = "Center"
  res@tiMainFontHeightF     = 0.016
  res@tiMainFontThicknessF  = 5
  res@xyMonoLineColor       = False             ; want colored lines
  res@tiYAxisString         = "Height (km)"
  res@tiXAxisString         = "Mean T (K)"
  res@tiYAxisFontThicknessF = 4
  res@tiXAxisFontThicknessF = 4
  res@tiYAxisFontHeightF    = 0.025
  res@tiXAxisFontHeightF    = 0.025
  res@tmXBLabelFontHeightF  = 0.025
  res@tmYLLabelFontHeightF  = 0.025                 ; set the funt size of x/y labls axis
  res@pmLegendDisplayMode    = "Never"            ; turn on legend

  res@tmXTOn = False
  res@tmYROn = False

  zz_km=zz_ave/1000.0
  printVarSummary(zz_km)
  print(zz_km)

  res@trXMinF = 267.0
  res@trXMaxF = 272.0
  res@trYMinF = zz_km(0)
  res@trYMaxF = 0.6
  res@tmXBLabelStride = 2

  plots=new(2, graphic)
  wks=gsn_open_wks("pdf","/athenaData1/lpluo/run_jing_fromChinool_smb_part2/plots_1year_test_resolution/for_2018/for_paper_ERL/pic/profile_th_qv_bbsub_500m")
  
  res@xyLineColors       = (/"red","blue","black","green","red","blue","black","green"/)
  res@xyLineThicknesses  = (/4,4,4,4,4,4,4,4/)
  res@xyDashPatterns     = (/0,0,0,0,1,1,1,1/)
  res@xyExplicitLegendLabels = (/"CNTL-Nov","CNTL-Dec","CNTL-Jan","CNTL-Feb","Blowoff-Nov","Blowoff-Dec","Blowoff-Jan","Blowoff-Feb"/)

  dims=dimsizes(data_ave_area)

  tk_final=(/data_ave_area(0,0,:),data_ave_area(0,1,:),data_ave_area(0,2,:),data_ave_area(0,3,:),data_ave_area(1,0,:),data_ave_area(1,1,:),data_ave_area(1,2,:),data_ave_area(1,3,:)/)
  qv_final=(/data_ave_area(2,0,:),data_ave_area(2,1,:),data_ave_area(2,2,:),data_ave_area(2,3,:),data_ave_area(3,0,:),data_ave_area(3,1,:),data_ave_area(3,2,:),data_ave_area(3,3,:)/)

  printVarSummary(tk_final)
  
    plots(0)=gsn_csm_xy(wks,tk_final(:,0:10),zz_km(0:10),res)
    
    res_qv=res
    res_qv@tiXAxisString         = "Mean Qv (g/kg)"
    res_qv@tiYAxisString         = ""
    
    res_qv@pmLegendDisplayMode    = "Always"            ; turn on legend
    res_qv@pmLegendSide           = "top"               ; Change location of
    res_qv@pmLegendParallelPosF   = 0.75
    res_qv@pmLegendOrthogonalPosF = -0.4
    res_qv@lgPerimOn              =  False

    res_qv@pmLegendWidthF         = 0.08                 ; Change width and
    res_qv@pmLegendHeightF        = 0.3                  ; height of legend.
    res_qv@lgLabelFontHeightF     = 0.02                ; label font height
    res_qv@trXMinF = 1.5
    res_qv@trXMaxF = 3.3

    plots(1)=gsn_csm_xy(wks,qv_final(:,0:10),zz_km(0:10),res_qv)

;;;;; add two label strings to each panels  ［为各个小图片添加图注］

  txres=True
  txres@txPerimOn = True
  txres@txFontHeightF = 0.025

  ;; top right strings
  amres_tr = True
  amres_tr@amParallelPosF = -0.5            ;This is the right edge of the plot.
  amres_tr@amOrthogonalPosF = 0.5         ; This is the top edge of the plot.
  amres_tr@amJust = "BottomLeft"
  text_tr = (/"(a)","(b)"/)

  ;; Create text strings  ; 注意是graphic类型；然后才能gsn_add_annotation
  txid_tr= new(2, graphic)
  amid_tr= new(2, graphic)

 do i = 0, 1
  txid_tr(i) = gsn_create_text(wks, text_tr(i), txres)
  amid_tr(i) = gsn_add_annotation(plots(i), txid_tr(i), amres_tr)
 end do

  resP=True
  resP@gsnMaximize         = True
  resP@gsnPanelRowSpec     = True    ; to define number of panel specificly
  resP@gsnPanelCenter      = False   ; default panels on the center, to set fause that panel on the left to the most

 gsn_panel(wks, plots, (/2,1/), resP)

end

