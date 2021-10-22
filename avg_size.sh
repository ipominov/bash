#!/bin/bash

# Скрипт показывает средний размер файлов в указанном каталоге

echo "Укажи каталог"
read dirname

calc_avg_size () {

  [ -d $1 ]

  if [[ $? -eq 0 ]]; then
    count=`ls -l $1 | grep ^- | wc -l`
    summa=`ls -l $1 | grep ^- | awk '{ SUM += $5 } END {print SUM}'`
    avg_size=$(($summa/$count))

    echo "Средний размер файлов в каталоге $1 в байтах - '$avg_size'"

    elif [[ ! $? -eq 0 ]]; then
      echo "Каталог не существует";
  fi

}

calc_avg_size $dirname
