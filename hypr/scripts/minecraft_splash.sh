#!/bin/bash

# Ruta del archivo de frases
FRASES="$HOME/.config/hypr/scripts/splash_texts.txt"

# Elegir una frase al azar
FRASE=$(shuf -n 1 "$FRASES")

# Mostrar la frase con espacios para que parezca que flota
echo ""
echo -e "      $FRASE" | lolcat -f
echo ""

