#!/bin/bash

while true; do
  # Obter temperatura atual
  TEMP=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader)

  # Ajustar velocidade do cooler com base na temperatura
  if [ "$TEMP" -gt 50 ]; then
    nvidia-settings -a '[gpu:0]/GPUFanControlState=1' >/dev/null 2>&1
    nvidia-settings -a "[fan:1]/GPUTargetFanSpeed=100" >/dev/null 2>&1
    nvidia-settings -a "[fan:0]/GPUTargetFanSpeed=100" >/dev/null 2>&1
  fi

  if [ "$TEMP" -ge 40 ] && [ "$TEMP" -le 50 ]; then
    nvidia-settings -a '[gpu:0]/GPUFanControlState=1' >/dev/null 2>&1
    nvidia-settings -a "[fan:1]/GPUTargetFanSpeed=50" >/dev/null 2>&1
    nvidia-settings -a "[fan:0]/GPUTargetFanSpeed=50" >/dev/null 2>&1
  fi

  if [ "$TEMP" -lt 40 ]; then
    nvidia-settings -a '[gpu:0]/GPUFanControlState=0' >/dev/null 2>&1
  fi

  # Intervalo de atualização (em segundos)
  sleep 5
done