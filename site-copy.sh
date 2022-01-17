#!/bin/bash

new_db_name=cr42035_in
new_db_password=edgbku34h89

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

  if [[ $? -eq 0 ]]; then

    src_db_name="$(cat wp-config.php | grep "DB_NAME" | awk -F "'" '{print $4}')"
    src_db_user="$(cat wp-config.php | grep "DB_USER" | awk -F "'" '{print $4}')"
    src_db_password="$(cat wp-config.php | grep "DB_PASSWORD" | awk -F "'" '{print $4}')"

  elif [[ ! $? -eq 0 ]]; then
    echo "Файла конфигурации Wordpress нет";

  fi

mysqldump -u"$src_db_user" "$src_db_name" -p"$src_db_password" --no-tablespaces > "$src_db_name".sql

mysql -u"$new_db_name" "$new_db_name" -p"$new_db_password" < "$src_db_name".sql
