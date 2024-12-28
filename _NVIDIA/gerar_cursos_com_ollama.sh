#!/bin/bash

# Nome do arquivo de saída
OUTPUT_FILE="cursos_gerados.txt"

# Certifique-se de que o arquivo exista e esteja vazio no início
>"$OUTPUT_FILE"

# Lista de tópicos para gerar cursos
TOPICOS=(
    "Inteligência Artificial para iniciantes"
    "Machine Learning avançado"
    "Redes Neurais com Python"
    "Deep Learning com TensorFlow e PyTorch"
    "Processamento de Linguagem Natural"
    "Visão Computacional aplicada"
    "Engenharia de Dados com IA"
    "Sistemas de recomendação"
    "IA Generativa e Modelos de Linguagem"
    "Aprendizado por Reforço"
)

# Loop infinito para gerar cursos
while true; do
    for TOPICO in "${TOPICOS[@]}"; do
        echo "Gerando curso para o tópico: $TOPICO..."

        # Comando para gerar um curso usando o Ollama
        NOVO_CURSO=$(ollama run llama3.2 "Crie um curso completo sobre o tema: $TOPICO")

        # Verifica se o curso já existe no arquivo
        #         if grep -Fxq "$NOVO_CURSO" "$OUTPUT_FILE"; then
        #             echo "Curso já existe. Pulando..."
        #         else
        # Adiciona o novo curso ao arquivo
        echo "$NOVO_CURSO" >>"$OUTPUT_FILE"
        #             echo "Curso salvo: $NOVO_CURSO"
        #         fi

        # Pausa entre cada iteração (opcional)
        sleep 2
    done

    echo "Todos os tópicos foram gerados. Reiniciando a lista..."
done
