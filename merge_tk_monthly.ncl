load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRF_contributed.ncl"

begin
;; read in tk and qv datasets
tk_cntl_2017_11=systemfunc("ls "+"/athenaData1/lpluo/run_jing_fromChinool_smb_part2/WRFV3_ParP_20172018_new_print/run/final_wrfout2/tk/tk_2017-11-*.nc")
tk_cntl_2017_12=systemfunc("ls "+"/athenaData1/lpluo/run_jing_fromChinool_smb_part2/WRFV3_ParP_20172018_new_print/run/final_wrfout2/tk/tk_2017-12-*.nc")
tk_cntl_2018_01=systemfunc("ls "+"/athenaData1/lpluo/run_jing_fromChinool_smb_part2/WRFV3_ParP_20172018_new_print/run/final_wrfout2/tk/tk_2018-01-*.nc")
tk_cntl_2018_02=systemfunc("ls "+"/athenaData1/lpluo/run_jing_fromChinool_smb_part2/WRFV3_ParP_20172018_new_print/run/final_wrfout2/tk/tk_2018-02-*.nc")

print(tk_cntl_2017_11)
print(tk_cntl_2017_12)
print(tk_cntl_2018_01)
print(tk_cntl_2018_02)

;;

tkfile_cntl_2017_11=addfiles(tk_cntl_2017_11, "r")
tkfile_cntl_2017_12=addfiles(tk_cntl_2017_12, "r")
tkfile_cntl_2018_01=addfiles(tk_cntl_2018_01, "r")
tkfile_cntl_2018_02=addfiles(tk_cntl_2018_02, "r")

ListSetType(tkfile_cntl_2017_11, "join")
ListSetType(tkfile_cntl_2017_12, "join")
ListSetType(tkfile_cntl_2018_01, "join")
ListSetType(tkfile_cntl_2018_02, "join")

; get variables TK
tk_b_2017_11=tkfile_cntl_2017_11[:]->TK
print("1")

tk_b_2017_12=tkfile_cntl_2017_12[:]->TK
print("2")

tk_b_2018_01=tkfile_cntl_2018_01[:]->TK
print("3")

tk_b_2018_02=tkfile_cntl_2018_02[:]->TK
print("4")

tk_2017_11_total=addfile("/athenaData1/lpluo/run_jing_fromChinool_smb_part2/WRFV3_ParP_20172018_new_print/run/final_wrfout2/tk/tk_total_2017_11.nc", "c")
tk_2017_12_total=addfile("/athenaData1/lpluo/run_jing_fromChinool_smb_part2/WRFV3_ParP_20172018_new_print/run/final_wrfout2/tk/tk_total_2017_12.nc", "c")
tk_2018_01_total=addfile("/athenaData1/lpluo/run_jing_fromChinool_smb_part2/WRFV3_ParP_20172018_new_print/run/final_wrfout2/tk/tk_total_2018_01.nc", "c")
tk_2018_02_total=addfile("/athenaData1/lpluo/run_jing_fromChinool_smb_part2/WRFV3_ParP_20172018_new_print/run/final_wrfout2/tk/tk_total_2018_02.nc", "c")

tk_2017_11_total->tk_b_2017_11=tk_b_2017_11
tk_2017_12_total->tk_b_2017_12=tk_b_2017_12
tk_2018_01_total->tk_b_2018_01=tk_b_2018_01
tk_2018_02_total->tk_b_2018_02=tk_b_2018_02

print("done written!")

end

