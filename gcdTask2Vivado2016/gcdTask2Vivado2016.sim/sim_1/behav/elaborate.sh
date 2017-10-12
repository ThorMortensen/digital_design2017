#!/bin/bash -f
xv_path="/home/thor/Xillinx/Vivado/2016.4"
ExecStep()
{
"$@"
RETVAL=$?
if [ $RETVAL -ne 0 ]
then
exit $RETVAL
fi
}
ExecStep $xv_path/bin/xelab -wto 62cff71aba3b4b348e30dc4bba939ba2 -m64 --debug typical --relax --mt 8 -L xil_defaultlib -L secureip --snapshot gcd_sys_behav xil_defaultlib.gcd_sys -log elaborate.log
