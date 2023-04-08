#!/bin/bash

get_user_msg ()
{
  index=1
  for user in `cat /etc/passwd | cut -d ":" -f 1`; do
    echo "User index is $index, user name is $user" 
    index=$(($index + 1))
  done
}

get_user_msg
