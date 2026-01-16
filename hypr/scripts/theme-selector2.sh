#!/bin/bash

WALL_DIR="$HOME/Imágenes/fondos" # Ajustado a tu ruta

CHOICE=$(ls "$WALL_DIR" | rofi -dmenu -theme ~/.config/rofi/themes/morvibus_pywal.rasi -p "Seleccionar Fondo:")

if [ -z "$CHOICE" ]; then
    exit 1
fi

FULL_PATH="$WALL_DIR/$CHOICE"

# 1. Cambiar fondo
swww img "$FULL_PATH" --transition-type wipe

# 2. Generar colores (Esto actualiza ~/.cache/wal/colors-rofi-dark.rasi)
wal -i "$FULL_PATH" -n

cp "$FULL_PATH" "$HOME/.cache/wal/menu-bg.jpg"

# 3. Notificar
#notify-send -i "$FULL_PATH" "Tema Dinámico" "Colores aplicados desde $CHOICE"

# ... (después de wal -i "$FULL_PATH" -n)

# 1. Matar dunst para que tome la nueva configuración
#killall dunst

# 2. Iniciar dunst usando la configuración generada por Pywal
# Esta config ya trae los colores del fondo de pantalla aplicados
#dunst -config ~/.cache/wal/dunstrc &

# 3. (Opcional) Enviar una notificación de prueba para ver el cambio
#notify-send -i "$FULL_PATH" "Esquema de Colores" "Dunst se ha sincronizado con el fondo"

# ... (después de wal -i)

# Reiniciar Waybar para aplicar colores de Pywal
killall waybar
waybar &

# Recargar estilos de SwayNC con los nuevos colores de Pywal
swaync-client -rs
