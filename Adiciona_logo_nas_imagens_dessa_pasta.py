from PIL import Image, ImageDraw, ImageFont
import os

def add_watermark(input_image_path, output_image_path, watermark_path):
    # Carregue a imagem de entrada e converta para RGBA se necessário
    if os.path.basename(input_image_path) == os.path.basename(watermark_path):
        return
    base = Image.open(input_image_path).convert("RGBA")

    # Carregue a imagem de marca d'água
    watermark = Image.open(watermark_path).convert("RGBA")

    # Redimensione a marca d'água para o tamanho da imagem principal
    width, height = base.size
    width_logo, height_logo = watermark.size
    new_width = int(width_logo * 0.2)
    new_height = int(height_logo * 0.2)
    # watermark = watermark.resize((new_width, new_height), Image.ANTIALIAS)

    if watermark.width != new_width or watermark.height != new_height:
        watermark = watermark.resize((new_width, new_height), Image.ANTIALIAS)

    borda=2
    # Posicione a marca d'água no canto inferior direito
    position = (width - borda * watermark.width, height - borda * watermark.height)
     # Ajuste a opacidade da marca d'água
     # Crie uma nova imagem transparente (com fundo alfa)
    transparent = base.copy()

    # Aplicar a marca d'água com a máscara de alfa diretamente
    transparent.paste(watermark, position, mask=watermark.split()[3])  # Use a 
# máscara de alpha para a máscara

    # Salve a imagem resultante
    transparent.save(output_image_path)


def process_images_in_folder(input_folder, output_folder, watermark_path):
    if not os.path.exists(output_folder):
        os.makedirs(output_folder)
        
    for filename in os.listdir(input_folder):
        if filename.endswith(('.png', '.jpg', '.jpeg', '.bmp', '.gif')):
            input_image_path = os.path.join(input_folder, filename)
            output_image_path = os.path.join(output_folder, filename)
            add_watermark(input_image_path, output_image_path, watermark_path)

# Defina o caminho para a pasta de entrada e saída
input_folder = './'  # Substitua pelo caminho da sua pasta de entrada
output_folder = './imagens_com_logo'  # Substitua pelo caminho da sua pasta de saída

# Defina o caminho para a marca d'água
watermark_path = './logo.png'  # Substitua pelo caminho completo para sua marca d'água

process_images_in_folder(input_folder, output_folder, watermark_path)
