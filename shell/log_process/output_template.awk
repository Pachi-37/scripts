BEGIN{
  printf "%-10s%-10s%-10s%-10s\n", "User", "Total", "Successed", "Failed"
}

{
  USER[$6]+=$8
  SUCCESS[$6]+=$12
  FAILED[$6]+=$14
  if ($8 != $12 + $14)
    print "[ERROR]: Recoard lost. Line: " NR
}

END{
  for (user in USER)
    printf"%-10s%-10s%-10s%-10s\n", user, USER[user], SUCCESS[user], FAILED[user]
}
