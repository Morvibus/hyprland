#!/bin/bash

# Detectar el nombre de la fuente de energía (AC o ADP)
AC_PATH=$(ls /sys/class/power_supply/ | grep -E "AC|ADP" | head -1)
last_state=$(cat /sys/class/power_supply/$AC_PATH/online)

while true; do
    current_state=$(cat /sys/class/power_supply/$AC_PATH/online)

    if [ "$current_state" != "$last_state" ]; then
        if [ "$current_state" == "1" ]; then
            # ACABAS DE CONECTAR EL CARGADOR
            notify-send -u normal -t 1000 -i battery-charging "Cargador Conectado" "Tu energía se está restaurando..."
            paplay ~/.config/hypr/sounds/levelup.ogg &
        else
            # ACABAS DE DESCONECTAR EL CARGADOR
            notify-send -u normal -t 1000 -i battery-discharging "Modo Batería" "Cargador desconectado."
            # Opcional: sonido de click o hit al desconectar
            paplay ~/.config/hypr/sounds/click.ogg &
        fi
        last_state=$current_state
    fi
    sleep 2 # Revisa cada 2 segundos para ser instantáneo
done
