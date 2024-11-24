#!/bin/bash
clear
# Configurações
WHISPER_MODEL="small"  # Modelo do Whisper
AUDIO_INPUT="audio_input.wav"  # Arquivo temporário para áudio capturado
TEXT_RESPONSE="response.txt"  # Arquivo para texto gerado pela IA
TTS_OUTPUT="response.mp3"  # Arquivo de áudio gerado para resposta

# Função para capturar áudio
capture_audio() {
  echo "Gravando sua fala. Pressione Ctrl+C para parar."
  arecord -f cd -t wav -d 5 -r 16000 -c 1 "$AUDIO_INPUT"
}

# Função para transcrever áudio usando Whisper
transcribe_audio() {
  conda deactivate
  conda activate whisper
  echo "Transcrevendo áudio..."
  whisper "$AUDIO_INPUT" --model "$WHISPER_MODEL" --output_format txt
  TRANSCRIBED_TEXT=$(cat "${AUDIO_INPUT%.*}.txt") &> /dev/null
  echo "Você disse: $TRANSCRIBED_TEXT"
}

# Função para gerar texto com Ollama
generate_response() {
conda deactivate
  echo "Enviando para o modelo Llama3.2..."
  RESPONSE=$(ollama run llama3.2 "$TRANSCRIBED_TEXT")
  echo "$RESPONSE" > "$TEXT_RESPONSE"
  echo "Resposta: $RESPONSE"
}

# Função para sintetizar voz com TTS
# conda create -n tts python=3.9 -y
# conda activate tts
# sudo apt install tts
synthesize_speech() {
conda deactivate
conda activate tts
  echo "Gerando resposta de áudio..."

  tts --text "$( cat $TEXT_RESPONSE)" --model_name tts_models/multilingual/multi-dataset/xtts_v2 --speaker_idx "Claribel Dervla" --language_idx "pt" --out_path "$TTS_OUTPUT" &> /dev/null

  aplay $TTS_OUTPUT
}

# Loop principal do assistente
while true; do
clear
  echo "==== Assistente de Voz ===="
  capture_audio       # Captura áudio do usuário
  transcribe_audio    # Transcreve áudio para texto
  generate_response   # Gera resposta com Ollama
  synthesize_speech   # Converte a resposta em áudio

  echo "acabou!!"
  read
done

conda deactivate
