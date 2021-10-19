#!/bin/bash

func () {

if [ -d /home/igor ]; then
  echo "yes";
fi;
}

# Берем в переменную count количество файлов
count=`ls -l /home/igor/etc | wc -l`

# Берем в переменную summa общий размер файлов
summa=`ls -la /home/igor/etc | awk '{ SUM += $5 } END {print SUM}'`

# Делим общий размер на количество файлов
avg_size=$(($summa/$count))

echo $avg_size
