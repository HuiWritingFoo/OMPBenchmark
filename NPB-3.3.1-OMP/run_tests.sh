#!/bin/bash

set -uo pipefail

wd=$(pwd)/bin
cd bin

# directory of executables
binlist=$(find $wd -type f -executable)
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

  printf "$file\n\n"
  $file
  checkerror $? "$file"

done

echo "failed: "$error
printf "tests failed:\n$failed\n"
echo "total: "$count

