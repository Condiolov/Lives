#!/bin/bash

sudo cp controle_de_temperatura_nvidia.service /etc/systemd/user/controle_de_temperatura_nvidia.service

#Recarregue o systemd para que ele reconheça o novo serviço:

systemctl --user daemon-reload
systemctl --user enable controle_de_temperatura_nvidia.service
systemctl --user start controle_de_temperatura_nvidia.service
