load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRF_contributed.ncl"

begin
;; read in tk and qv datasets
tkfile_cntl_2017_11=addfile("/athenaData1/lpluo/run_jing_fromChinool_smb_part2/WRFV3_ParP_20172018_new_print/run/final_wrfout2_noblow_off/tk/tk_total_2017_11.nc", "r")
tkfile_cntl_2017_12=addfile("/athenaData1/lpluo/run_jing_fromChinool_smb_part2/WRFV3_ParP_20172018_new_print/run/final_wrfout2_noblow_off/tk/tk_total_2017_12.nc", "r")
tkfile_cntl_2018_01=addfile("/athenaData1/lpluo/run_jing_fromChinool_smb_part2/WRFV3_ParP_20172018_new_print/run/final_wrfout2_noblow_off/tk/tk_total_2018_01.nc", "r")
tkfile_cntl_2018_02=addfile("/athenaData1/lpluo/run_jing_fromChinool_smb_part2/WRFV3_ParP_20172018_new_print/run/final_wrfout2_noblow_off/tk/tk_total_2018_02.nc", "r")

;;; bssub:
bssub_cntl_2017_11=addfile("/athenaData1/lpluo/run_jing_fromChinool_smb_part2/WRFV3_ParP_20172018_new_print/run/final_wrfout2/sb0_bssub/bssub_2017_11.nc", "r")
bssub_cntl_2017_12=addfile("/athenaData1/lpluo/run_jing_fromChinool_smb_part2/WRFV3_ParP_20172018_new_print/run/final_wrfout2/sb0_bssub/bssub_2017_12.nc", "r")
bssub_cntl_2018_01=addfile("/athenaData1/lpluo/run_jing_fromChinool_smb_part2/WRFV3_ParP_20172018_new_print/run/final_wrfout2/sb0_bssub/bssub_2018_01.nc", "r")
bssub_cntl_2018_02=addfile("/athenaData1/lpluo/run_jing_fromChinool_smb_part2/WRFV3_ParP_20172018_new_print/run/final_wrfout2/sb0_bssub/bssub_2018_02.nc", "r")
print("1")

;; get variables TK and QVAPOR
tk_b_11=tkfile_cntl_2017_11->tk_b_2017_11
print("2")

tk_b_12=tkfile_cntl_2017_12->tk_b_2017_12
print("3")

tk_b_01=tkfile_cntl_2018_01->tk_b_2018_01
print("4")

tk_b_02=tkfile_cntl_2018_02->tk_b_2018_02
print("5")

;;
bssub_b_11=bssub_cntl_2017_11->bssub_2017_11
print("6")

bssub_b_12=bssub_cntl_2017_12->bssub_2017_12
print("7")

bssub_b_01=bssub_cntl_2018_01->bssub_2018_01
print("8")

bssub_b_02=bssub_cntl_2018_02->bssub_2018_02
print("9")

printVarSummary(tk_b_11)

tk_b_11=where(bssub_b_11 .lt. 0.0, tk_b_11, tk_b_11@_FillValue)
tk_b_12=where(bssub_b_12 .lt. 0.0, tk_b_12, tk_b_12@_FillValue)
tk_b_01=where(bssub_b_01 .lt. 0.0, tk_b_01, tk_b_01@_FillValue)
tk_b_02=where(bssub_b_02 .lt. 0.0, tk_b_02, tk_b_02@_FillValue)

tk_2017_11_ave=dim_avg_n(tk_b_11,(/0,1/))
tk_2017_12_ave=dim_avg_n(tk_b_12,(/0,1/))
tk_2018_01_ave=dim_avg_n(tk_b_01,(/0,1/))
tk_2018_02_ave=dim_avg_n(tk_b_02,(/0,1/))

tk_total=(/tk_2017_11_ave,tk_2017_12_ave,tk_2018_01_ave,tk_2018_02_ave/)
printVarSummary(tk_total)
tk_total_ave_file=addfile("/athenaData1/lpluo/run_jing_fromChinool_smb_part2/WRFV3_ParP_20172018_new_print/run/final_wrfout2_noblow_off/tk/tk_total_monthly_ave_bssub.nc", "c")
tk_total_ave_file->tk_total=tk_total

end

