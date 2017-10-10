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
ExecStep $xv_path/bin/xsim gcd_sys_behav -key {Behavioral:sim_1:Functional:gcd_sys} -tclbatch gcd_sys.tcl -log simulate.log
