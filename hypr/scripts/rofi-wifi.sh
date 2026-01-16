#!/bin/bash

# Obtener la lista de redes con SSID, Barras de señal y Seguridad
# Usamos 'tail -n +2' para quitar el encabezado
wifi_list=$(nmcli -f "SSID,BARS,SECURITY" device wifi list | tail -n +2 | sed 's/\s\{2,\}/|/g')

# Si no hay redes, avisar
if [ -z "$wifi_list" ]; then
    notify-send "Wi-Fi" "No se encontraron redes"
    exit
fi

# Formatear la lista para Rofi (Icono + SSID + Señal)
formatted_list=$(echo "$wifi_list" | while read -r line; do
    SSID=$(echo "$line" | cut -d'|' -f1)
    BARS=$(echo "$line" | cut -d'|' -f2)
    SEC=$(echo "$line" | cut -d'|' -f3)
    
    # Si el SSID está vacío (red oculta), saltar o nombrar
    if [ -z "$SSID" ]; then SSID="Red Oculta"; fi
    
    echo "󰖩  $SSID  ($BARS)  $SEC"
done)

# Lanzar Rofi con tu tema morvibus
chosen_line=$(echo -e "$formatted_list" | rofi -dmenu -i -p "Seleccionar Wi-Fi" -theme ~/.config/rofi/themes/morvibus_pywal.rasi)

# Si el usuario cierra Rofi sin elegir
if [ -z "$chosen_line" ]; then
    exit
fi

# Extraer el SSID real (quitando el icono y los detalles de señal)
# Esto limpia todo lo que está después del nombre
chosen_ssid=$(echo "$chosen_line" | sed 's/^󰖩  //' | sed 's/  (.*$//')

# Intentar conectar
notify-send "Wi-Fi" "Conectando a $chosen_ssid..."

# Verificar si ya tiene contraseña guardada
if nmcli -t -f TYPE,NAME connection show --active | grep -q "802-11-wireless.$chosen_ssid"; then
    nmcli device wifi connect "$chosen_ssid"
else
    # Si falla o es nueva, pedir contraseña
   password=$(rofi -dmenu -p "Contraseña" -password -theme ~/.config/rofi/themes/listado.rasi)
    
    if [ -z "$password" ]; then
        nmcli device wifi connect "$chosen_ssid"
    else
        nmcli device wifi connect "$chosen_ssid" password "$password"
    fi
fi
