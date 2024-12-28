#!/bin/bash

# Ativar controle manual do cooler
nvidia-settings -a '[gpu:0]/GPUFanControlState=1' >/dev/null 2>&1

while true; do
  # Obter temperatura atual
  TEMP=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader)

  # Ajustar velocidade do cooler com base na temperatura
  if [ "$TEMP" -gt 55 ]; then
    nvidia-settings -a '[gpu:0]/GPUFanControlState=1' >/dev/null 2>&1
    nvidia-settings -a "[fan:1]/GPUTargetFanSpeed=100" >/dev/null 2>&1
    nvidia-settings -a "[fan:0]/GPUTargetFanSpeed=100" >/dev/null 2>&1
  elif [ "$TEMP" -ge 45 ] && [ "$TEMP" -le 55 ]; then
    nvidia-settings -a '[gpu:0]/GPUFanControlState=1' >/dev/null 2>&1
    nvidia-settings -a "[fan:1]/GPUTargetFanSpeed=50" >/dev/null 2>&1
    nvidia-settings -a "[fan:0]/GPUTargetFanSpeed=50" >/dev/null 2>&1
  else
    nvidia-settings -a '[gpu:0]/GPUFanControlState=0' >/dev/null 2>&1
  fi

  # Intervalo de atualização (em segundos)
  sleep 5
done