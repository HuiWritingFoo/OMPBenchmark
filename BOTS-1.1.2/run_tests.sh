#!/bin/bash

set -uo pipefail

wd=$(pwd)
# directory of executables
binlist=$(find bin/ -type f -executable)
# directory of inputs
inputdirlist=$(find inputs/ ! -path inputs/ -type d)

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

  for inputdir in $inputdirlist
  do
    inputdirbase=$(basename $inputdir)

    grep $inputdirbase $file
    if [[ $? -eq 0 ]]
    then
      inputflag=true
      inputlist=$(find $wd/$inputdir -type f)
      for input in $inputlist
      do
        printf "%s----------------------------------------------------------------\n"
        printf "$file -f $input\n\n"
        $wd/$file -f $input
        checkerror $? "$file -f $input"
      done
    fi
    args=""
  done
  if [[ $inputflag = false ]]
  then
    printf "%s----------------------------------------------------------------\n"
    printf "$file\n\n"
    $wd/$file
    checkerror $? "$file"
  fi

done

printf "\n****************************************************************\n"
printf "failed: $error\n"
printf "tests failed:\n$failed\n"
printf "total: $count\n"

