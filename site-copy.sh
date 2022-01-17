#!/bin/bash

# Скрипт для Timemweb, делает копию сайта на Wordpress в другом каталоге
# Запускать в том каталоге, КУДА нужно сделать копию

# Здесь указываем название и пароль НОВОЙ базы (предварительно нужно создать ее)
new_db_name=******
new_db_password=******

echo "Укажи, откуда копировать (путь до каталога без слеша в конце)"
read srcdir

# Проверяем существование отдающего каталога, копируем файлы

[ -d $srcdir ]

  if [[ $? -eq 0 ]]; then 
    shopt -s dotglob
    cp -rp $srcdir/* ./

    elif [[ ! $? -eq 0 ]]; then
      echo "Каталог не существует";
  fi

# Проверяем наличие в файлах конфига Wordpress, выдергиваем реквизиты базы

[ -f wp-config.php ]

  if [[ $? -eq 0 ]]; then

    src_db_name="$(cat wp-config.php | grep "DB_NAME" | awk -F "'" '{print $4}')"
    src_db_user="$(cat wp-config.php | grep "DB_USER" | awk -F "'" '{print $4}')"
    src_db_password="$(cat wp-config.php | grep "DB_PASSWORD" | awk -F "'" '{print $4}')"

  elif [[ ! $? -eq 0 ]]; then
    echo "Файла конфигурации Wordpress нет";

  fi

# Делаем дамп старой базы, импортируем его в новую

mysqldump -u"$src_db_user" "$src_db_name" -p"$src_db_password" --no-tablespaces > "$src_db_name".sql
mysql -u"$new_db_name" "$new_db_name" -p"$new_db_password" < "$src_db_name".sql
