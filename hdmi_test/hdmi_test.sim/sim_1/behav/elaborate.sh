#!/bin/sh -f
xv_path="/afs/ece/support/xilinx/xilinx.release/Vivado"
ExecStep()
{
"$@"
RETVAL=$?
if [ $RETVAL -ne 0 ]
then
exit $RETVAL
fi
}
ExecStep $xv_path/bin/xelab -wto a9b16b7ac1c3445b8c6c50c6678513ac -m64 --debug typical --relax --mt 8 -L xil_defaultlib -L blk_mem_gen_v8_2 -L unisims_ver -L unimacro_ver -L secureip --snapshot test_behav xil_defaultlib.test xil_defaultlib.glbl -log elaborate.log
