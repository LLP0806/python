load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRF_contributed.ncl"

begin
;; read in tk and qv datasets
bssub_cntl_2017_11=systemfunc("ls "+"/athenaData1/lpluo/run_jing_fromChinool_smb_part2/WRFV3_ParP_20172018_new_print/run/final_wrfout2/sb0_bssub/bssub_2017_11*.nc")
bssub_cntl_2017_12=systemfunc("ls "+"/athenaData1/lpluo/run_jing_fromChinool_smb_part2/WRFV3_ParP_20172018_new_print/run/final_wrfout2/sb0_bssub/bssub_2017_12*.nc")
bssub_cntl_2018_01=systemfunc("ls "+"/athenaData1/lpluo/run_jing_fromChinool_smb_part2/WRFV3_ParP_20172018_new_print/run/final_wrfout2/sb0_bssub/bssub_2018_01*.nc")
bssub_cntl_2018_02=systemfunc("ls "+"/athenaData1/lpluo/run_jing_fromChinool_smb_part2/WRFV3_ParP_20172018_new_print/run/final_wrfout2/sb0_bssub/bssub_2018_02*.nc")

print(bssub_cntl_2017_11)
print(bssub_cntl_2017_12)
print(bssub_cntl_2018_01)
print(bssub_cntl_2018_02)

;;

bssub_file_cntl_2017_11=addfiles(bssub_cntl_2017_11, "r")
bssub_file_cntl_2017_12=addfiles(bssub_cntl_2017_12, "r")
bssub_file_cntl_2018_01=addfiles(bssub_cntl_2018_01, "r")
bssub_file_cntl_2018_02=addfiles(bssub_cntl_2018_02, "r")

ListSetType(bssub_file_cntl_2017_11, "join")
ListSetType(bssub_file_cntl_2017_12, "join")
ListSetType(bssub_file_cntl_2018_01, "join")
ListSetType(bssub_file_cntl_2018_02, "join")

; get variables BSSUB
bssub_2017_11=bssub_file_cntl_2017_11[:]->BSSUB
print("1")

bssub_2017_12=bssub_file_cntl_2017_12[:]->BSSUB
print("2")

bssub_2018_01=bssub_file_cntl_2018_01[:]->BSSUB
print("3")

bssub_2018_02=bssub_file_cntl_2018_02[:]->BSSUB
print("4")

bssub_2017_11_total=addfile("/athenaData1/lpluo/run_jing_fromChinool_smb_part2/WRFV3_ParP_20172018_new_print/run/final_wrfout2/sb0_bssub/bssub_2017_11.nc", "c")
bssub_2017_12_total=addfile("/athenaData1/lpluo/run_jing_fromChinool_smb_part2/WRFV3_ParP_20172018_new_print/run/final_wrfout2/sb0_bssub/bssub_2017_12.nc", "c")
bssub_2018_01_total=addfile("/athenaData1/lpluo/run_jing_fromChinool_smb_part2/WRFV3_ParP_20172018_new_print/run/final_wrfout2/sb0_bssub/bssub_2018_01.nc", "c")
bssub_2018_02_total=addfile("/athenaData1/lpluo/run_jing_fromChinool_smb_part2/WRFV3_ParP_20172018_new_print/run/final_wrfout2/sb0_bssub/bssub_2018_02.nc", "c")

bssub_2017_11_total->bssub_2017_11=bssub_2017_11
bssub_2017_12_total->bssub_2017_12=bssub_2017_12
bssub_2018_01_total->bssub_2018_01=bssub_2018_01
bssub_2018_02_total->bssub_2018_02=bssub_2018_02

print("done written!")

end

