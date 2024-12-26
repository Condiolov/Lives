
# Iniciando Script Automaticamente no Armbian Linux

### Vídeo passo a passo
[Assista no YouTube](https://www.youtube.com/watch?v=yxwKsv4yIFM)

---

## Listar e Configurar Dispositivos de Áudio

1. **Listar dispositivos de áudio disponíveis**:
   ```bash
   pactl list short sinks
   ```

2. **Definir a saída de áudio padrão**:
   ```bash
   pactl list short sinks       # LISTA AS SAÍDAS DE ÁUDIO
   # pactl set-default-sink 0  # PELO ID OU PELO NOME:
   pactl set-default-sink alsa_output.usb-C-Media_Electronics_Inc._USB_PnP_Sound_Device-00.stereo-fallback
   ```

---

## Passo 1: Criar Serviço no Armbian

### 1. Instalar o Gerenciador de Login
Atualize o sistema e instale o `lightdm`:
```bash
sudo apt update
sudo apt install lightdm
```

### 2. Configurar Login Automático
Edite o arquivo de configuração do `lightdm`:
```bash
sudo nano /etc/lightdm/lightdm.conf -m
```

Adicione ou edite o conteúdo para configurar o login automático:
```
[SeatDefaults]
autologin-user=<LOGIN_DO_USUARIO>
autologin-user-timeout=0
```

Depois de editar, pressione `CTRL+S` para salvar e `CTRL+X` para sair.

---

## Passo 3: Criar o Script SH

Crie um script `agora_deu.sh`:
```bash
nano -m agora_deu.sh
```

Adicione o seguinte conteúdo ao script:

```bash
#!/bin/bash
texto="Script para falar esse texto!"
pactl list short sinks       # LISTA AS SAÍDAS DE ÁUDIO
# pactl set-default-sink 0  # PELO ID OU PELO NOME:
pactl set-default-sink alsa_output.usb-C-Media_Electronics_Inc._USB_PnP_Sound_Device-00.stereo-fallback
pactl set-sink-volume @DEFAULT_SINK@ 50%  # VOLUME EM 50%
espeak -v mb-br4 -s 140 -p 50 "$(echo $texto), deu certo? tudo bem?" --stdout | sox -t wav - -t wav -r 48000 -c 2 -b 16 -e signed-integer - | aplay
```

Pressione `CTRL+S` para salvar e `CTRL+X` para sair.

## 4. Tornar o Script Executável
```bash
chmod +x agora_deu.sh
```

---

## Passo 5: Criar o Serviço Systemd

1. Crie o diretório para o serviço:
   ```bash
   sudo mkdir -p /etc/systemd/user/
   ```

2. Crie o arquivo de serviço:
   ```bash
   sudo nano -m /etc/systemd/user/*SCRIPT*.service
   ```

Adicione o conteúdo abaixo ao arquivo:

```ini
[Unit]
Description='AAAAAvCase - Assistente de Voz Caseiro'

[Service]
Type=forking
ExecStart=/home/thiago/aaa.sh
Restart=no

[Install]
WantedBy=default.target
```

Pressione `CTRL+S` para salvar e `CTRL+X` para sair.

---

## Passo 6: Ativar e Iniciar o Serviço

Sempre que alterar o arquivo `*SCRIPT*.service`, use os seguintes comandos:

```bash
systemctl --user daemon-reload
systemctl --user enable *SCRIPT*.service  # HABILITA O SERVIÇO
systemctl --user start *SCRIPT*.service   # INICIA O SERVIÇO PARA TESTE
systemctl --user status *SCRIPT*.service  # VERIFICA O STATUS DO SERVIÇO
systemctl --user disable *SCRIPT*.service # DESABILITA O SERVIÇO
systemctl --user stop *SCRIPT*.service    # PARA O SERVIÇO
```

---

## Passo 7: Próximo Reboot

Após realizar todas as configurações, reinicie o sistema:
```bash
reboot
```
