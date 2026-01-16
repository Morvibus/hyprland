#!/bin/bash

WALL_DIR="$HOME/Imágenes/fondos"
THEME_RASI="$HOME/.config/rofi/themes/morvibus_pywal.rasi"

# 1. Construir la lista de imágenes con iconos para Rofi
# Formato: nombre-archivo\0icon\x1fruta-al-archivo
list_wallpapers() {
    for wall in "$WALL_DIR"/*.{png,jpg,jpeg,webp}; do
        if [ -f "$wall" ]; then
            echo -en "$(basename "$wall")\0icon\x1f$wall\n"
        fi
    done
}

# 2. Mostrar Rofi con las miniaturas
CHOICE=$(list_wallpapers | rofi -dmenu -i -theme "$THEME_RASI" -p "Seleccionar Fondo")

# Si no se elige nada, salir
if [ -z "$CHOICE" ]; then
    exit 1
fi

FULL_PATH="$WALL_DIR/$CHOICE"

# 3. Aplicar el fondo con swww
swww img "$FULL_PATH" --transition-type wipe --transition-fps 60

# 4. Generar colores con Pywal
wal -i "$FULL_PATH" -n -s

cp "$FULL_PATH" "$HOME/.cache/wal/menu-bg.jpg"

# 5. Reiniciar componentes para aplicar colores
killall waybar && waybar &
swaync-client -rs

