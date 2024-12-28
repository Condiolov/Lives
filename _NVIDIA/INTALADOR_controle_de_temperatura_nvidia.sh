#!/bin/bash

sudo cp controle_de_temperatura_nvidia.service /etc/systemd/user/controle_de_temperatura_nvidia.service

#Recarregue o systemd para que ele reconheça o novo serviço:

SUDOERS_FILE="/etc/sudoers"
COMMAND_TO_ALLOW="/usr/bin/nvidia-settings"

if ! sudo grep -q "$USER ALL=(ALL) NOPASSWD: $COMMAND_TO_ALLOW" "$SUDOERS_FILE"; then
    echo "$USER ALL=(ALL) NOPASSWD: $COMMAND_TO_ALLOW" | sudo tee -a "$SUDOERS_FILE" >/dev/null
    echo "Permissão adicionada para o comando $COMMAND_TO_ALLOW."
else
    echo "Permissão já existe."
fi

sudo usermod -aG video $USER

systemctl --user daemon-reload
systemctl --user enable controle_de_temperatura_nvidia.service
systemctl --user start controle_de_temperatura_nvidia.service
# systemctl --user status controle_de_temperatura_nvidia.service