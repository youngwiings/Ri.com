#!/bin/bash

# Проверка наличия двух аргументов (директорий)
if [ $# -ne 2 ]; then
    echo "Использование: $0 <входная директория> <выходная директория>"
    exit 1
fi

# Присваивание входной и выходной директории переменным
INPUT_DIR=$1
OUTPUT_DIR=$2

# Проверка существования входной директории
if [ ! -d "$INPUT_DIR" ]; then
    echo "Входная директория не существует."
    exit 1
fi

# Создание выходной директории, если она не существует
mkdir -p "$OUTPUT_DIR"

# Находим все файлы в входной директории
find "$INPUT_DIR" -type f | while IFS= read -r FILE; do
    # Получаем базовое имя файла для копирования
    BASENAME=$(basename -- "$FILE")
    DEST_FILE="$OUTPUT_DIR/$BASENAME"

    # Проверям, существует ли уже файл с таким именем в выходной директории
    COUNTER=1
    while [ -e "$DEST_FILE" ]; do
        # Если файл существует, добавляем к имени файла счетчик
        FILE_EXT="${BASENAME##*.}"
        FILE_BASE="${BASENAME%.*}"
        DEST_FILE="$OUTPUT_DIR/${FILE_BASE}(${COUNTER}).${FILE_EXT}"
        ((COUNTER++))
    done
    
    # Копирование файла с уникальным именем
    cp -- "$FILE" "$DEST_FILE"
done

echo "Все файлы были скопированы в $OUTPUT_DIR."d   
