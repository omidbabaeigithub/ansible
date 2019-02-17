#!/bin/bash

# PUBLIC Parameters
export OPAM_BIN=/u01/oracle/products/11.1/oracle_home/idm_home/opam/bin/opam.sh
export OPAM_URL="https://172.25.67.83:18102/opam"

# Run Opam Command	
echo -e "Abc@1234" | ${OPAM_BIN} -url ${OPAM_URL} -u S.Joulazadeh -x addtarget -targettype unix -targetName iss2vldadf02 -host iss2vldadf02.msc-dc.local -port 22 -loginUser opam_service -loginUserpassword 123456 -loginShellPrompt '[$#%>~]'



