#!/bin/bash
# Generate log test information
#

create_random ()
{
  local min=$1
  local max=$(($2 - $min + 1))
  local num=$(date +%s%N)
  echo $(($num % $max + $min))
}

INDEX=0

while [[ true ]]; do
  for user in A B C D E F G H
  do
    COUNT=`create_random 10 200`
    NUM1=`create_random 1 $COUNT`
    NUM2=$(($COUNT - $NUM1))
    echo "`date '+%Y-%m-%d %H:%M:%S'` $INDEX Batches: user $user insert $COUNT records into db, $NUM1 successfully, $NUM2 failed" >> ./db.log.`date +%Y%m%d`
    INDEX=`expr $INDEX + 1`
  done
done

