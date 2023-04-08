#!/bin/bash
# Write a script to process the mysql config file my.cnf, mainly to achieve the following features:
# 1) Print the file has several segment
# 2) Count the total number of configuration parameters for each segment

MYSQL_CONFIG_FILE=./my.cnf

get_segment ()
{
  echo "`sed -n '/\[*\]/p' $MYSQL_CONFIG_FILE | sed -e 's/\[\(.*\)\]/\1/g'`"
}


get_item_in_segment ()
{
  local segment=$1
  local items=`sed -n -e '/\['$segment'\]/,/\[.*\]/p' $MYSQL_CONFIG_FILE | grep -v ^# | grep -v ^$ | grep -v '\[.*\]'`
  local count=0

  for item in $items
  do
    count=`expr $count + 1`
  done

  echo $count
}


count_blank_line ()
{
  echo `awk BEGIN{sum=0}'/^&/{sum++}'END{print sum}`
}


for seg in `get_segment`
do 
  echo "Segment: $seg", "items: `get_item_in_segment $seg`"
done

