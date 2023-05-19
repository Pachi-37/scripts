#!/bin/bash
#
HOME=./
FILE=process.ini

CONFIG_FILE=$HOME$FILE

script_pid=$$

get_all_groups ()
{
  echo `sed -n '/\[GROUPS\]/, /\[.*\]/p' $CONFIG_FILE | grep -v -E '\[.*\]|^$'`
}

is_group_exsits ()
{
  for group in `get_all_groups`
  do
    if [ "$group" == "$1" ]; then
      return
    fi
  done
  return 1
}

is_process_exsits ()
{
  for process in `get_all_processes`
  do
    if [ "$process" == "$1" ]; then
      return
    fi
  done
  return 1
}

get_all_processes_by_group ()
{
  if [[ `is_group_exsits $1` -eq 0 ]];then
    sed -n "/\[$1\]/, /\[.*\]/p" $CONFIG_FILE | grep -v -E '\[.*\]|^$'
  else
    echo "[ERROR]: Group $1 not in config file"
  fi
}

get_all_processes ()
{
  for group in `get_all_groups`
  do
    get_all_processes_by_group $group
  done
}

get_process_pid_by_name ()
{
  echo `ps -ef | grep $1 | grep -v grep | grep -v $script_pid | awk '{print $2}'`
}

get_process_msg_by_pid ()
{
  if [[ `ps -ef | awk -v pid=$1 '$2==pid{print $0}' | wc -l` -eq 1 ]]; then
    local process_status='RUNNING'
  else
    local process_status='STOPPED'
  fi

  local msg=`ps -aux | awk -v pid=$1 '$2==pid{print $0}'`
  local process_cpu=`echo $msg | awk '{print $3}'`
  local process_mem=`echo $msg | awk '{print $4}'`
  local process_start_time=`ps -p $1 -o lstart | grep -v STARTED`

  awk -v status="$process_status" -v cpu="$process_cpu" \
      -v mem="$process_mem" -v start_time="$process_start_time" \
      -v pid=$1 \
      'BEGIN{printf "%-13s%-10s%-10s%-10s%-10s\n", status, pid, cpu, mem, start_time}'
}

get_group_by_process_name() {
  for group in `get_all_groups`
  do
    for process in `get_all_processes_by_group $group`
    do
      if [ "$process" == "$1" ]; then
        echo $group
        return
      fi
    done
  done
  echo "[ERROR]: Process $1 not in config file"
}

print_msgs ()
{
  ps -ef | grep $1 | grep -v grep | grep -v $script_pid >> /dev/null
  if [ $? -eq 0 ]; then
    pids=`get_process_pid_by_name $1`
    for pid in $pids
    do
      awk -v process="$1" -v group="$2" 'BEGIN{printf "%-19s%-17s", process, group}'
      get_process_msg_by_pid $pid
    done
  else
    is_process_exsits $1 && awk -v process="$1" -v group="$2" \
                            'BEGIN{printf "%-19s%-17s%-13s%-10s%-10s%-10s%-10s\n", process, group, "STOPED", "NULL", "NULL", "NULL", "NULL", "NULL"}'
  fi
}

title="PROCESS_NAME-------GROUP_NAME-------STATUS-------PID-------CPU-------MEM-------START_TIME"
echo $title
if [ $# -gt 0 ];then
  if [ "$1" == "-g" ];then
    shift
    for group_name in $@
    do
      for process in `get_all_processes_by_group $group_name`
      do
        print_msgs $process $group_name
      done
    done
  elif [[ "$1" == "-p" ]]; then
    shift
    for process in $@
    do
      print_msgs $process `get_group_by_process_name $process`
    done
  fi
else
  for process in `get_all_processes`
  do
    print_msgs $process `get_group_by_process_name $process`
  done
fi

