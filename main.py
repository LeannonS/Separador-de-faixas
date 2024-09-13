!pip install pydub
!pip install spleeter
!pip install librosa
!pip install matplotlib
!pwd
!pip install --upgrade click typer
!pip install yt-dlp

import yt_dlp
import warnings
warnings.filterwarnings("ignore")
from spleeter.separator import Separator
import spleeter as spl
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.ticker as ticker
import librosa
import subprocess
from pydub import AudioSegment
import os


class Option_error(Exception):
    pass

def format_time(x, pos):
    mins, secs = divmod(int(x), 60)
    return f'{mins}:{secs:02}'

def convert_name(palavra):
    traducoes = {
        'vocals': 'vocais',
        'accompaniment': 'outros',
        'drums': 'bateria',
        'bass': 'baixo',
        'piano': 'piano'
    }
    palavra = palavra.lower()

    return traducoes.get(palavra, palavra)


def plot_figures(input_file,output_file,namefile):
    y, sr = librosa.load(input_file)

    hop_length = 512
    envelope = np.abs(librosa.onset.onset_strength(y=y, sr=sr, hop_length=hop_length))

    tempo = np.linspace(0, len(y) / sr, len(envelope))

    plt.figure(figsize=(40, 4), dpi=350)  # Ajuste o dpi para aumentar a resolução
    plt.plot(tempo, envelope, label='Envelope do Áudio')
    plt.title('Envelope do Áudio')
    plt.xlabel('Tempo (min:seg)')
    plt.ylabel('Amplitude')
    plt.legend()

    plt.gca().xaxis.set_major_formatter(ticker.FuncFormatter(format_time))
    plt.xticks(np.arange(0, np.max(tempo) + 3, 5))

    figure_path=os.path.join(output_file,"images")
    plt.savefig(os.path.join(figure_path,namefile+".png"), bbox_inches='tight', dpi=350)
    plt.close()

def load_audio(file_path):
    audio = AudioSegment.from_file(file_path).set_channels(1)
    samples = np.array(audio.get_array_of_samples(), dtype=np.float32) / 32768.0
    return samples, audio.frame_rate

def save_audio(samples, sample_rate, output_file,output_type):
    samples = np.int16(samples / np.max(np.abs(samples)) * 32767)
    audio_out = AudioSegment(
        samples.tobytes(),
        frame_rate=sample_rate,
        sample_width=2,
        channels=1
    )
    saida = output_file
    saida=saida+'/'
    audio_out.export(saida+'reverb'+'.'+output_type, format=output_type)

def reverb_file(input_file,output_file,base_file,output_type):
    samples1, sample_rate1 = load_audio(input_file)
    samples2, sample_rate2 = load_audio(base_file)
    # if sample_rate1 != sample_rate2:
    #     raise ValueError("As taxas de amostragem dos arquivos de áudio são diferentes.")
    convolved_samples = np.convolve(samples1, samples2, mode='full')
    save_audio(convolved_samples,sample_rate1,output_file,output_type)

def Change_type(output_file,files):
  for file in files:
    new_file=output_file+"/"+file
    output_path=os.path.splitext(new_file)[0] + "." + output_type
    audio = AudioSegment.from_file(new_file)
    audio.export(output_path, format=output_type)
    os.remove(new_file)

def change_audios(caminho_pasta):
  for nome_arquivo in os.listdir(caminho_pasta):
        if nome_arquivo.endswith('.mp3'):
            nome_base = os.path.splitext(nome_arquivo)[0]

            nome_traduzido = convert_name(nome_base)

            novo_nome = f"{nome_traduzido}.mp3"

            caminho_antigo = os.path.join(caminho_pasta, nome_arquivo)
            caminho_novo = os.path.join(caminho_pasta, novo_nome)

            os.rename(caminho_antigo, caminho_novo)

def base_function(option,input_file,output_file,output_type,base_file,plot):
    if option == 0:

        audio_file = input_file
        separator = Separator('spleeter:2stems')
        separator.separate_to_file(audio_file, output_file)
        output_file=output_file + input_file.split('.')[-2]
        files = os.listdir(output_file)
        if output_type != "wav":
          Change_type(output_file,files)
        pasta_audios = "manipulacao302/audios"
        change_audios(pasta_audios)

    elif option == 1:

        audio_file = input_file
        separator = Separator('spleeter:4stems')
        separator.separate_to_file(audio_file, output_file)
        output_file=output_file + input_file.split('.')[-2]
        files = os.listdir(output_file)
        if output_type != "wav":
            Change_type(output_file,files)
        pasta_audios = "manipulacao302/audios"
        change_audios(pasta_audios)

    elif option == 2:

        audio_file = input_file
        separator = Separator('spleeter:5stems')
        separator.separate_to_file(audio_file, output_file)
        output_file=output_file + input_file.split('.')[-2]
        files = os.listdir(output_file)
        if output_type != "wav":
            Change_type(output_file,files)
        pasta_audios = "manipulacao302/audios"
        change_audios(pasta_audios)

    elif option == 3:
        output_file=output_file+input_file.split('.')[-2]
        os.makedirs(output_file, exist_ok=True)
        #print(output_file)
        reverb_file(input_file,output_file,base_file,output_type)

    else:
        raise Option_error("OPTION ERROR")

    if plot:
        base_output_file="manipulacao302/"
        os.makedirs(os.path.join(base_output_file, 'images'), exist_ok=True)
        new_output_file=os.path.join(base_output_file, 'images')
        plot_figures(input_file,base_output_file,namefile="musica")
        if option == 3:
            plot_figures(output_file+'/reverb'+"."+output_type,base_output_file,namefile="Reverb")
        else:
            output_file=output_file.replace("//","/")
            new_files=os.listdir(output_file)
            for file in new_files:
                name=convert_name(file.split(".")[0])
                plot_figures(os.path.join(output_file,file),base_output_file,namefile=name)

if __name__ == '__main__':
  #os.makedirs("manipulação302", exist_ok=True)
  LINK = "https://www.youtube.com/watch?v=J9gKyRmic20"
  OPTION = 3
  PLOT = True
  output_file="manipulacao302/"
  nome_arquivo="audios.mp3"
  input_file=nome_arquivo
  output_type='mp3'
  base_file="audio1 (2).mp3"
  comando = [
    'yt-dlp',
    '-x',
    '--audio-format', 'mp3',
    '--output', nome_arquivo,
    LINK
  ]
  resultado = subprocess.run(comando, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
  if OPTION == 3:
    reverb=[
      'yt-dlp',
      '-x',
      '--audio-format', 'mp3',
      '--output', base_file,
      'https://www.youtube.com/watch?v=1JrI1qJRSmY'
    ]
    reverbs= subprocess.run(reverb, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
  try:
      base_function(OPTION,input_file,output_file,output_type,base_file,PLOT)
  except Option_error as error:
      print(f"Erro: {error}")