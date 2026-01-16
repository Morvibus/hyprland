#!/bin/bash

LOW_BAT=20
CRITICAL_BAT=10

while true; do
    BAT_PATH=$(ls /sys/class/power_supply/ | grep -E "BAT|BATT" | head -1)
    PERCENT=$(cat /sys/class/power_supply/$BAT_PATH/capacity)
    STATUS=$(cat /sys/class/power_supply/$BAT_PATH/status)

    if [ "$STATUS" != "Charging" ]; then
        if [ "$PERCENT" -le "$CRITICAL_BAT" ]; then
            # Alerta Crítica: -t 0 para que NO se quite sola hasta que la cierres
            notify-send -u critical -t 0 "¡Peligro de Muerte!" "Batería al $PERCENT%. ¡Busca un cargador YA!"
           # paplay ~/.config/hypr/sounds/hit.ogg &
        elif [ "$PERCENT" -le "$LOW_BAT" ]; then
            # Alerta Baja: -t 10000 son 10 segundos
            notify-send -u normal -t 10000 "Batería Baja" "Tienes $PERCENT% de energía restante."
            #paplay ~/.config/hypr/sounds/hit.ogg &
        fi
    fi
    
    sleep 120
done
