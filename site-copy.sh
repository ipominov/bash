#!/bin/bash

echo "Укажи, откуда копировать (путь до каталога без слеша в конце)"
read srcdir

[ -d $srcdir ]

  if [[ $? -eq 0 ]]; then 
    shopt -s dotglob
    cp -rp $srcdir/* ./

    elif [[ ! $? -eq 0 ]]; then
      echo "Каталог не существует";
  fi

[ -f wp-config.php ]

  if [[ ! $? -eq 0 ]]; then

    src_db_name="$(cat wp-config.php | grep "DB_NAME" | awk -F "'" '{print $4}')"
    src_db_user="$(cat wp-config.php | grep "DB_USER" | awk -F "'" '{print $4}')"
    src_db_password="$(cat wp-config.php | grep "DB_PASSWORD" | awk -F "'" '{print $4}')"

  elif [[ ! $? -eq 0 ]]; then
    echo "Файла конфигурации Wordpress нет";

  fi
