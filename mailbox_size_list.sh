#!/usr/local/bin/bash

# variables
DIR=~/MailBox/
INPUT_FILE_PATH="/maildir/maildirsize"
THRESHOLD=0
if [ ! -z "$1" ]; then THRESHOLD=$1; fi

# human readable fuction
hr(){
  bytes=$1
  if [ $bytes -lt 1024 ]; then
    echo "${bytes}B"
  elif [ $bytes -lt 1048576 ]; then
    echo "$(echo "scale=2; ${bytes}/1024" | bc)KB"
  elif [ $bytes -lt 1073741824 ]; then
    echo "$(echo "scale=2; ${bytes}/1048576" | bc)MB"
  elif [ $bytes -lt 1099511627776 ]; then
    echo "$(echo "scale=2; ${bytes}/1073741824" | bc)GB"
  else
    echo "$(echo "scale=2; ${bytes}/1099511627776" | bc)TB"
  fi
}

# main
ls ${DIR} | while read box; do
  DATA="${DIR}${box}${INPUT_FILE_PATH}"
  if [ -r $DATA ]; then

    BOXLIMIT=`grep S $DATA | grep -o [0-9]*`;
    BOXSIZE=`grep -v S $DATA | awk '{sum+=$1}END{print sum}'`;


    PERCENT=`echo "scale=2; 100 * ${BOXSIZE} / ${BOXLIMIT}" | bc`
    HR_BOXSIZE=`hr $BOXSIZE`
    HR_BOXLIMIT=`hr $BOXLIMIT`

    if [ $(echo "${PERCENT} >= ${THRESHOLD}" | bc) -eq 1 ]; then
      echo "${BOXNAME} ${PERCENT}% (${HR_BOXSIZE}/${HR_BOXLIMIT})"
    fi
  fi
done
