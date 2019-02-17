#! /bin/bash
echo -e "Abc@1234" | /u01/oracle/products/11.1/oracle_home/idm_home/opam/bin/opam.sh -url https://172.25.67.83:18102/opam -u S.Joulazadeh -x addtarget -targettype unix -targetName iss2vlpoig02 -host iss2vlpoig02.msc-dc.local -port 22 -loginUser opam_service -loginUserpassword 123456 -loginShellPrompt '[$#%>~]'

