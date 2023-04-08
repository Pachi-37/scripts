#!/bin/bash
# Prompt the user for a positive integer and enter it again if it does not conform, calculate 1 + 2 + 3 + ... + n; 

while true; do
  read -p "Please enter a positive integer: " num
  expr $num + 1 > /dev/null
  if [ $? -eq 0 ]; then
    if [ `expr $num \> 0` -eq 1 ]; then
      declare -i res=0
      for ((i=0; i<=$num;i++)); do
        res=`expr $res + $i`
      done
      echo $res
      break 
    fi
  fi
done

