#!/bin/bash

set -uo pipefail

wd=$(pwd)
# directory of executables
binlist=$(find ./ -type f -executable ! -name run_tests.sh)
# directory of inputs

error=0
count=0
failed=""

checkerror() {
  if [ $1 -ne 0 ]
  then
    error=$(($error + 1))
    if [ -n "$2" ]
    then
      failed=$failed"\n $2"
    fi
  fi

  count=$(($count + 1))
}

for file in $binlist
do
  printf "\n****************************************************************\n"

  inputflag=false

  printf "%s----------------------------------------------------------------\n"
  printf "$file\n\n"
  $wd/$file
  checkerror $? "$file"

done

printf "\n****************************************************************\n"
printf "failed: $error\n"
printf "tests failed:\n$failed\n"
printf "total: $count\n"

