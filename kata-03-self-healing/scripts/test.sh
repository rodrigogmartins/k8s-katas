#!/bin/bash

SERVICE_URL=${1:-http://unstable-service}

echo "Starting chaos + observability test on $SERVICE_URL"
echo "Press Ctrl+C to stop"
echo ""

while true; do
  EVENTS=(
    "timeout" "timeout" "timeout" "timeout" "timeout"
    "ok" "ok" "ok" "ok"
    "shutdown"
  )

  SHUFFLED=($(printf "%s\n" "${EVENTS[@]}" | shuf))

  for EVENT in "${SHUFFLED[@]}"; do
    TIMESTAMP=$(date +"%H:%M:%S")

    # 🔹 gera o evento
    case $EVENT in
      ok)
        curl -s "$SERVICE_URL/" > /dev/null
        ;;
      timeout)
        curl -s --max-time 1 "$SERVICE_URL:81" > /dev/null
        ;;
      shutdown)
        curl -s "$SERVICE_URL/shutdown" > /dev/null
        ;;
    esac

    # 🔹 observabilidade do tráfego
    TRAFFIC=$(curl -s --max-time 2 "$SERVICE_URL/")
    TRAFFIC_CODE=$(curl -s -o /dev/null -w "%{http_code}" --max-time 2 "$SERVICE_URL/")
    READY=$(curl -s -o /dev/null -w "%{http_code}" --max-time 2 "$SERVICE_URL/readyz")
    HEALTH=$(curl -s -o /dev/null -w "%{http_code}" --max-time 2 "$SERVICE_URL/healthz")

    # 🔥 NOVO: identifica o pod que respondeu
    POD=$(curl -s --max-time 2 "$SERVICE_URL/hostname" 2>/dev/null)

    if [ -z "$POD" ]; then
      POD="unknown"
    fi

    # interpretação
    if [ "$TRAFFIC_CODE" == "200" ]; then
      TRAFFIC_STATUS="✅ OK"
    elif [ "$TRAFFIC_CODE" == "000" ]; then
      TRAFFIC_STATUS="⏱️ TIMEOUT"
    else
      TRAFFIC_STATUS="❌ $TRAFFIC_CODE"
    fi

    echo "[$TIMESTAMP] event=$EVENT | traffic=$TRAFFIC_STATUS | pod=$POD | ready=$READY | health=$HEALTH"

    sleep 1
  done
done