#!/bin/bash

# URL для отправки запросов
SERVER_URL="127.0.0.1/compute"

# Функция для отправки HTTP-запроса
send_request() {
    while true; do
        echo "Sending request to $SERVER_URL at $(date)"
        curl -i -X GET $SERVER_URL > /dev/null 2>&1
        sleep $((RANDOM % 6 + 5))  # Интервал от 5 до 10 секунд
    done
}

# Запуск нескольких фоновых потоков для асинхронных запросов
for i in {1..5}; do
    send_request &
done

# Ожидание завершения всех фоновых процессов
wait
