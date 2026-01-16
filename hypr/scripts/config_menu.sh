#!/bin/bash

# Define las rutas y acciones
# Formato: ["Icono Nombre"]="Ruta o Comando"
declare -A options=(
    ["󰘚 Hyprland"]="~/.config/hypr"
    ["󱓡 Waybar Style/Config"]="~/.config/waybar/"
    ["󰒓 Rofi Theme"]="~/.config/rofi/"
    ["󱅫 SwayNC Config"]="~/.config/swaync/"
    ["󰥔 Hyprlock"]="~/.config/hypr/hyprlock.conf"
    ["󱐋 Scripts Folder"]="~/.config/hypr/scripts/"
    ["󰄛 Kitty Config"]="~/.config/kitty/kitty.conf"
    ["󰑐 REINICIAR WAYBAR"]="killall waybar; waybar &"
    ["󰐥 RECARGAR HYPRLAND"]="hyprctl reload"
)

# Generar la lista para Rofi (ordenada para que las acciones queden al final)
choice=$(printf "%s\n" "${!options[@]}" | sort -r | rofi -dmenu -i -p "󰄼 Minecraft OS Control" -theme-str 'window { width: 50%; }')

if [ -n "$choice" ]; then
    selection=${options[$choice]}

    # Caso 1: Es un comando directo (Reiniciar)
    if [[ "$selection" == *"killall"* || "$selection" == *"hyprctl"* ]]; then
        eval "$selection"
        notify-send -t 2000 "Sistema" "Acción ejecutada: $choice" -i ~/Imágenes/mc_icon.png
    
    # Caso 2: Es un archivo o carpeta
    else
        full_path=$(eval echo "$selection")
        if [[ -f "$full_path" ]]; then
            # Es un archivo -> Editar
            kitty sh -c "micro $full_path"
        elif [[ -d "$full_path" ]]; then
            # Es una carpeta -> Abrir terminal ahí
            kitty sh -c "cd $full_path && $SHELL"
        fi
    fi
fi
