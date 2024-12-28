
# Controle de Temperatura NVIDIA - Prevenção de Superaquecimento

Assista ao video completo: https://www.youtube.com/live/oE1Pjn1CNo4

Este repositório contém um script que monitora a temperatura da sua placa de vídeo NVIDIA e ajusta a velocidade do cooler automaticamente para evitar superaquecimento. Ele foi projetado para garantir que sua GPU funcione dentro de uma faixa segura de temperatura durante a execução de tarefas pesadas, como treinamento de modelos de IA ou processamento gráfico.

O objetivo do script é garantir que sua GPU tenha um controle adequado de temperatura, ajustando a rotação do cooler conforme a necessidade.

## Funcionalidade

O script `controle_de_temperatura_nvidia.sh` faz o seguinte:

1. **Monitora a Temperatura da GPU**: A temperatura da GPU é verificada a cada 5 segundos.
2. **Ajuste Automático do Cooler**: Se a temperatura da GPU estiver entre 45°C e 55°C, a velocidade do cooler será ajustada para 60%. Caso a temperatura ultrapasse 55°C, a velocidade do cooler será ajustada para 100%.
3. **Protege contra Superaquecimento**: Evita que a temperatura da GPU atinja níveis perigosos, prevenindo danos à placa.

## Requisitos

- Uma placa de vídeo NVIDIA com o driver adequado instalado.
- Saber a quantidade de coolers
- O utilitário `nvidia-smi` deve estar disponível no sistema.
- O sistema deve estar rodando em um ambiente Linux com `systemd` para gerenciar o serviço.

## Instalação

### 1. Baixe o repositório

Clone o repositório ou baixe os arquivos diretamente:

```bash
git clone https://github.com/Condiolov/Lives/_NVIDIA/controle_temperatura_nvidia.git
cd controle_temperatura_nvidia
```

### 2. Torne o script executável

Dê permissão de execução ao script `controle_de_temperatura_nvidia.sh`:

```bash
chmod +x controle_de_temperatura_nvidia.sh
```

### 3. Instale o Serviço `systemd`

Dê permissão de execução ao script `controle_de_temperatura_nvidia.sh`:

```bash
chmod +x INTALADOR_controle_de_temperatura_nvidia.sh
./INTALADOR_controle_de_temperatura_nvidia.sh
```

### 4. Inicie o Serviço

Agora você pode iniciar o serviço para monitorar a temperatura da sua GPU automaticamente:

```bash
sudo systemctl start controle_de_temperatura_nvidia.service
```

### 5. Habilite o Serviço para Inicialização Automática

Se você deseja que o serviço seja iniciado automaticamente na inicialização do sistema, use o comando abaixo:

```bash
sudo systemctl enable controle_de_temperatura_nvidia.service
```

## Como Funciona

### Script `controle_de_temperatura_nvidia.sh`

Este script monitora constantemente a temperatura da sua placa de vídeo NVIDIA e ajusta a rotação do cooler de acordo com a temperatura. O controle de temperatura é feito da seguinte forma:

1. **Temperatura abaixo de 45°C**: Não há alteração na velocidade do cooler.
2. **Temperatura entre 45°C e 55°C**: A rotação do cooler é ajustada para 60%.
3. **Temperatura acima de 55°C**: A rotação do cooler é ajustada para 100%.

### Arquivo de Serviço `controle_de_temperatura_nvidia.service`

O arquivo de serviço `systemd` configura o script para ser executado em segundo plano e reiniciado automaticamente, caso seja interrompido. Ele também permite que o script seja executado durante o processo de inicialização do sistema.

## Teste do Script

O objetivo principal do script é **evitar o superaquecimento da GPU durante a execução de processos pesados**, como **geração de cursos** com ferramentas de IA ou treinamentos de modelos, que geralmente exigem alto uso de GPU.

Para **gerar cursos com o Ollama**, basta rodar o script `gerar_cursos_com_ollama.sh` enquanto o serviço de controle de temperatura estiver ativo, garantindo que a temperatura da GPU seja monitorada enquanto o processo ocorre.

## Logs e Monitoramento

Os logs do serviço podem ser visualizados utilizando o comando `journalctl`:

```bash
journalctl -xeu controle_de_temperatura_nvidia.service
```

Isso permite verificar a temperatura da GPU e o estado do cooler durante a execução.

## Desinstalação

Se você deseja desinstalar o serviço, siga os passos abaixo:

1. Pare o serviço:

   ```bash
   sudo systemctl stop controle_de_temperatura_nvidia.service
   ```

2. Desative o serviço para não iniciar automaticamente:

   ```bash
   sudo systemctl disable controle_de_temperatura_nvidia.service
   ```

3. Remova o arquivo de serviço:

   ```bash
   sudo rm /etc/systemd/system/controle_de_temperatura_nvidia.service
   ```



## Contribuição

Sinta-se à vontade para contribuir com melhorias no script ou para adicionar novos recursos. Se você encontrar algum bug ou tiver sugestões, por favor, abra uma **issue** no GitHub.
