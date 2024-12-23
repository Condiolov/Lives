#!/usr/local/bin/python3
# creditos: @condiolov  baseado: royshil/ffmpeg_concat_xfade.py

import argparse
import subprocess
import itertools
import random
import json
import os

FADE_TIME=3

parser = argparse.ArgumentParser(description="Processar cortes de vídeo com FFmpeg")
parser.add_argument('-j', required=True, help="Caminho para o arquivo JSON")
parser.add_argument('-i', required=True, help="Nome do arquivo de vídeo de entrada")
parser.add_argument('-o', required=True, help="Nome do arquivo de vídeo de saída final")

# Parseando os argumentos
args = parser.parse_args()

# Nome do arquivo JSON e dos vídeos
json_file = args.j
input_video = args.i
output_video = args.o

temp_dir = "temp_cortes"
partes_do_video = []
# Criar diretório temporário
os.makedirs(temp_dir, exist_ok=True)

# Ler o arquivo JSON
with open(json_file, "r") as f:
    cortes = json.load(f)

# Cortar os trechos
for i, corte in enumerate(cortes):
    start = corte['start']
    end = corte['end']

    # Comando FFmpeg em formato de string
    temp_output = os.path.join(temp_dir, f"parte_{i}.mp4")
    command = f"ffmpeg -i {input_video} -ss {start} -to {end} -c copy -r 30 {temp_output} -y"

    # Executando o comando FFmpeg diretamente
    subprocess.run(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    partes_do_video.append(temp_output)

SCALER_DEFAULT = "scale=1280:720"  # Exemplo de escalonamento padrão

files_input = [['-i', f] for f in partes_do_video]

# Prepare the filter graph
video_fades = ""
audio_fades = ""
last_fade_output = "0v"
last_audio_output = "0:a"
video_offset = 0
normalizer = ""

for i in range(len(partes_do_video)):

    if i == 0:
        continue

    xfade_effects = ["fade", "fadeblack","fadewhite","distance","wipeleft","wiperight","wipeup","wipedown","slideleft","slideright","slideup","slidedown","smoothleft","smoothright","smoothup","smoothdown","circlecrop","rectcrop","circleclose","circleopen","horzclose","horzopen","vertclose","vertopen","diagbl","diagbr","diagtl","diagtr","hlslice","hrslice","vuslice","vdslice","dissolve","pixelize","radial","hblur","wipetl","wipetr","wipebl","wipebr","zoomin","transition","for","xfade","fadegrays","squeezev","squeezeh","zoomin","hlwind","hrwind","vuwind","vdwind","coverleft","coverright","coverup","coverdown","revealleft","revealright","revealup","revealdown"]  # Exemplos de efeitos
    effect = random.choice(xfade_effects)

    # Video graph: chain the xfade operator together
    file_lengths = float(subprocess.run(['/bin/ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1', partes_do_video[i]],capture_output=True).stdout.splitlines()[0])
    video_offset += file_lengths - FADE_TIME
    next_fade_output = "v%d%d" % (i - 1, i)
    video_fades += "[%s][%dv]xfade=%s:duration=%d:offset=%.5f[%s];" % (last_fade_output, i, effect, FADE_TIME, video_offset, next_fade_output)
    last_fade_output = next_fade_output


    # Audio graph:
    next_audio_output = "a%d%d" % (i - 1, i)
    audio_fades += f"[{last_audio_output}][{i}:a]acrossfade=d=%d[{next_audio_output}];" % (FADE_TIME)
    last_audio_output = next_audio_output

video_fades += f"[{last_fade_output}]format=pix_fmts=yuv420p[final];"

# Assemble the FFMPEG command arguments
ffmpeg_args = ['/bin/ffmpeg',
               *itertools.chain(*files_input),
               '-filter_complex', video_fades + audio_fades[:-1],
               '-map', '[final]',
               '-map', f"[{last_audio_output}]",
               '-y',
               args.o]

# print(" ".join(ffmpeg_args))
# Run FFMPEG
subprocess.run(ffmpeg_args)