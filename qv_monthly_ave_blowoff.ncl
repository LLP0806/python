load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRF_contributed.ncl"

begin
;; read in qv datasets
qvfile_cntl_2017_11=addfile("/athenaData1/lpluo/run_jing_fromChinool_smb_part2/WRFV3_ParP_20172018_new_print/run/final_wrfout2_noblow_off/Qtotal/qtotal_11.nc", "r")
qvfile_cntl_2017_12=addfile("/athenaData1/lpluo/run_jing_fromChinool_smb_part2/WRFV3_ParP_20172018_new_print/run/final_wrfout2_noblow_off/Qtotal/qtotal_12.nc", "r")
qvfile_cntl_2018_01=addfile("/athenaData1/lpluo/run_jing_fromChinool_smb_part2/WRFV3_ParP_20172018_new_print/run/final_wrfout2_noblow_off/Qtotal/qtotal_1.nc", "r")
qvfile_cntl_2018_02=addfile("/athenaData1/lpluo/run_jing_fromChinool_smb_part2/WRFV3_ParP_20172018_new_print/run/final_wrfout2_noblow_off/Qtotal/qtotal_2.nc", "r")
print("1")

;;; bssub:
bssub_cntl_2017_11=addfile("/athenaData1/lpluo/run_jing_fromChinool_smb_part2/WRFV3_ParP_20172018_new_print/run/final_wrfout2/sb0_bssub/bssub_2017_11.nc", "r")
bssub_cntl_2017_12=addfile("/athenaData1/lpluo/run_jing_fromChinool_smb_part2/WRFV3_ParP_20172018_new_print/run/final_wrfout2/sb0_bssub/bssub_2017_12.nc", "r")
bssub_cntl_2018_01=addfile("/athenaData1/lpluo/run_jing_fromChinool_smb_part2/WRFV3_ParP_20172018_new_print/run/final_wrfout2/sb0_bssub/bssub_2018_01.nc", "r")
bssub_cntl_2018_02=addfile("/athenaData1/lpluo/run_jing_fromChinool_smb_part2/WRFV3_ParP_20172018_new_print/run/final_wrfout2/sb0_bssub/bssub_2018_02.nc", "r")

;; get variables QVAPOR
qv_b_11=qvfile_cntl_2017_11->QVAPOR
print("2")

qv_b_12=qvfile_cntl_2017_12->QVAPOR
print("3")

qv_b_01=qvfile_cntl_2018_01->QVAPOR
print("4")

qv_b_02=qvfile_cntl_2018_02->QVAPOR
print("5")

bssub_b_11=bssub_cntl_2017_11->bssub_2017_11
print("6")
dims_11=dimsizes(bssub_b_11)
tt_11=dims_11(0)*dims_11(1)
lev=dims_11(2)
nx=dims_11(3)
ny=dims_11(4)

bssub_b_12=bssub_cntl_2017_12->bssub_2017_12
print("7")
dims_12=dimsizes(bssub_b_12)
tt_12=dims_12(0)*dims_12(1)

bssub_b_01=bssub_cntl_2018_01->bssub_2018_01
print("8")
dims_01=dimsizes(bssub_b_01)
tt_01=dims_01(0)*dims_01(1)

bssub_b_02=bssub_cntl_2018_02->bssub_2018_02
print("9")
dims_02=dimsizes(bssub_b_02)
tt_02=dims_02(0)*dims_02(1)

bssub_b_11:=reshape(bssub_b_11, (/tt_11,lev,nx,ny/))
bssub_b_12:=reshape(bssub_b_12, (/tt_12,lev,nx,ny/))
bssub_b_01:=reshape(bssub_b_01, (/tt_01,lev,nx,ny/))
bssub_b_02:=reshape(bssub_b_02, (/tt_02,lev,nx,ny/))

printVarSummary(qv_b_11)

qv_b_11=where(bssub_b_11 .lt. 0.0, qv_b_11, qv_b_11@_FillValue)
qv_b_12=where(bssub_b_12 .lt. 0.0, qv_b_12, qv_b_12@_FillValue)
qv_b_01=where(bssub_b_01 .lt. 0.0, qv_b_01, qv_b_01@_FillValue)
qv_b_02=where(bssub_b_02 .lt. 0.0, qv_b_02, qv_b_02@_FillValue)

qv_2017_11_ave=dim_avg_n(qv_b_11,(/0/))
qv_2017_12_ave=dim_avg_n(qv_b_12,(/0/))
qv_2018_01_ave=dim_avg_n(qv_b_01,(/0/))
qv_2018_02_ave=dim_avg_n(qv_b_02,(/0/))

qv_total=(/qv_2017_11_ave,qv_2017_12_ave,qv_2018_01_ave,qv_2018_02_ave/)
printVarSummary(qv_total)
qv_total_ave_file=addfile("/athenaData1/lpluo/run_jing_fromChinool_smb_part2/WRFV3_ParP_20172018_new_print/run/final_wrfout2_noblow_off/Qtotal/qv_total_monthly_ave_bssub.nc", "c")
qv_total_ave_file->qv_total=qv_total

end

