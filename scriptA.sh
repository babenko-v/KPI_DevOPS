#!/bin/bash

# Параметры
IMAGE="babenkovalera/multistage"
CPU_CORES=(0 1 2)                   # Ядра CPU для контейнеров
CONTAINERS=("srv1" "srv2" "srv3")   # Названия контейнеров
PORTS=(8081 8082 8083)              # Порты на хосте
CHECK_INTERVAL=10                   # Интервал проверки (в секундах)
BUSY_THRESHOLD=70.0                 # Порог загрузки CPU для "занятости"
IDLE_THRESHOLD=5.0                 # Порог для простоя

# Функция запуска контейнера на указанном ядре и порту
launch_container() {
    local name=$1
    local core=$2
    local port=$3
    echo "Запуск контейнера $name на CPU core#$core..."
    docker run -d --name $name --cpuset-cpus=$core -p $port:8081 $IMAGE
    sleep 10
}

# Функция проверки загрузки контейнера
get_cpu_usage() {
    local name=$1
    docker stats --no-stream --format "{{.CPUPerc}}" $name | sed 's/%//'
}

# Функция остановки контейнера
stop_container() {
    local name=$1
    echo "Остановка контейнера $name..."
    docker kill --signal=SIGINT $name
    docker wait $name
    docker rm $name
}

# Основная логика управления контейнерами
active_containers=()

# Запуск srv1 (первый контейнер)
launch_container "${CONTAINERS[0]}" "${CPU_CORES[0]}" "${PORTS[0]}"
active_containers+=("${CONTAINERS[0]}")

while true; do
    for i in "${!CONTAINERS[@]}"; do
        name="${CONTAINERS[$i]}"

        # Проверка, запущен ли контейнер
        if [[ $(docker ps -q --filter "name=$name") ]]; then
            cpu_usage=$(get_cpu_usage "$name")
            echo "Контейнер $name: CPU usage = $cpu_usage%"

            # Если загружен и есть следующий контейнер
            if (( $(echo "$cpu_usage > $BUSY_THRESHOLD" | bc -l) )) && [[ $i -lt 2 ]]; then
                next_name="${CONTAINERS[$i+1]}"
                if ! [[ "${active_containers[@]}" =~ $next_name ]]; then
                    launch_container "$next_name" "${CPU_CORES[$i+1]}" "${PORTS[$i+1]}"
                    active_containers+=("$next_name")
                fi
            fi
	   
            # Если контейнер простаивает, остановить его
            if (( $(echo "$cpu_usage < $IDLE_THRESHOLD" | bc -l) )) && [[ $i -gt 0 ]]; then
                echo "Контейнер $name простаивает. Останавливаем..."
                stop_container "$name"
                active_containers=("${active_containers[@]/$name}")
            fi
        fi
    done

    # Проверка обновления образа
    echo "Проверка на обновление образа..."
    pullResult=$(docker pull $IMAGE | grep "Downloaded newer image")
    if [[ -n "$pullResult" ]]; then
        echo "Обновление образа найдено. Перезапуск контейнеров..."
        for name in "${active_containers[@]}"; do
            stop_container "$name"
            i=${!CONTAINERS[@]}
            launch_container "$name" "${CPU_CORES[$i]}" "${PORTS[$i]}"
        done
    fi

    sleep $CHECK_INTERVAL
done
