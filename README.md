# Separador de Faixas (App "Just Voice")

Neste trabalho, foi desenvolvido um aplicativo utilizando **Flutter** para a separação de faixas musicais e aplicação de reverb. O app permite separar as faixas de áudio em componentes como: Vocal, Bateria, Baixo e Outros. Para isso, ele redireciona o usuário para um link no **Google Colaboratory**, onde um código em **Python** realiza o processo de separação (ou reverb) e disponibiliza os arquivos para download.

## Funcionalidades do Aplicativo

- **Separação de Faixas**: O app permite que o usuário visualize exemplos de músicas que passaram pelo procedimento de separação de faixas.
- **Exibição dos Sinais de Áudio**: Além das faixas separadas, o aplicativo também oferece a visualização dos sinais de áudio para cada faixa.
- **Execução em Desktop**: A separação também pode ser realizada em um desktop através do **Google Colaboratory**, onde o arquivo `Sinais_Sistemas.ipynb` pode ser carregado e alterado conforme as instruções do tutorial.
- **Reverb**: O aplicativo também permite aplicar efeitos de reverb nas faixas separadas.

## Instalação

Para utilizar o aplicativo, basta instalar o arquivo `apk-release.apk` em seu smartphone Android. O aplicativo inclui tutoriais de uso para guiar o usuário no processo de separação de faixas e aplicação de reverb.

### Permissões Necessárias

No Android, o aplicativo requer as seguintes permissões:
- Acesso ao armazenamento (leitura/escrita/gerenciamento)
- Acesso à internet

No iOS, as permissões necessárias incluem:
- Acesso à biblioteca de mídia e à pasta de documentos

### Principais Arquivos do Projeto

1. **AndroidManifest.xml**: Localizado em `android/app/src/main/AndroidManifest.xml`. Este arquivo define permissões e componentes necessários para o aplicativo Android.
2. **Info.plist**: Localizado em `ios/Runner/Info.plist`. Responsável pelas permissões e configurações para dispositivos iOS.
3. **Pubspec.yaml**: Define as dependências e recursos adicionais (assets) utilizados no projeto.
4. **Pasta lib**: Contém todo o código-fonte do aplicativo, incluindo as funções que controlam a navegação, interação com o usuário e manipulação de arquivos de áudio e imagem.

#### Principais Arquivos da Pasta lib:

- **app_widget.dart**: Define as rotas e transições entre telas.
  
  - Função principal: 
    ```dart
    Widget build (BuildContext context)
    ```
    Define as rotas do aplicativo.

- **example_audio_page.dart**: Responsável pela reprodução e manipulação dos arquivos de áudio utilizados como exemplos.

  - Funções principais:
    ```dart
    Future<void> _loadAudio() async
    ```
    Carrega e inicia a reprodução dos áudios.

    ```dart
    Future<void> _togglePlayPause() async
    ```
    Alterna entre pausar e reproduzir o áudio.

    ```dart
    Future<void> _seek(Duration position) async
    ```
    Modifica a minutagem do áudio.

    ```dart
    Future<void> _skipForward() async
    Future<void> _skipBackward() async
    ```
    Avançam ou retrocedem a reprodução do áudio.

    ```dart
    Future<void> _saveAudio(String directory, String fileName, String assetPath) async
    Future<void> _saveAllAudios(String directory, Map<String, dynamic> audioData) async
    ```
    Salvam um ou todos os arquivos de áudio.

    ```dart
    void _updateVolume(int index, double volume)
    ```
    Atualiza o volume do áudio.

- **example_image_page.dart**: Gerencia a exibição das imagens dos sinais de áudio utilizados como exemplo.

  - Função principal:
    ```dart
    Widget _buildImageContainer(String imageName, String categoryName)
    ```
    Constrói os contêineres para exibição das imagens.

- **home_page.dart**: Tela inicial do aplicativo.

  - Função principal:
    ```dart
    Future<bool> _onWillPop() async
    ```
    Verifica se o usuário deseja sair do aplicativo.

- **main.dart**: Função principal que inicializa o aplicativo.

- **picker_page.dart**: Responsável pela seleção de arquivos durante a execução do aplicativo.

  - Funções principais:
    ```dart
    Future<void> _pickFiles() async
    ```
    Seleciona os arquivos de áudio ou imagem.

    ```dart
    bool _isValidFile(String path)
    ```
    Verifica se o arquivo tem extensão `.mp3` (áudio) ou `.png` (imagem).

    ```dart
    void _clearSelection()
    ```
    Limpa a lista de arquivos selecionados.

    ```dart
    Future<void> _launchURL(String url) async
    ```
    Abre uma URL no navegador.

- **text_page.dart**: Contém o tutorial de uso do aplicativo em formato de texto.

- **video_intro_page.dart**: Reproduz o vídeo introdutório do aplicativo.

- **view_audio_page.dart**: Gerencia a reprodução dos áudios manipulados.

  - Funções principais:
    ```dart
    Future<void> _loadAudio() async
    ```
    Carrega os áudios.

    ```dart
    Future<void> _togglePlayPause() async
    ```
    Alterna entre play e pause.

    ```dart
    void _updateVolume(int index, double volume)
    ```
    Atualiza o volume do áudio.

- **view_image_page.dart**: Gerencia a exibição das imagens dos sinais das músicas.

## Execução em Desktop

Se você deseja realizar a separação de faixas ou aplicar reverb em um desktop, siga o procedimento abaixo:

1. Abra o **Google Colaboratory**.
2. Faça o upload do arquivo `Sinais_Sistemas.ipynb`.
3. Siga as instruções no notebook para obter a separação ou aplicar o reverb na música desejada.

## Funcionalidades

- **Separação de faixas de áudio**: Usando o Spleeter, você pode separar o áudio em múltiplos componentes, como vocais, bateria, baixo, piano e outros.
- **Aplicação de reverb**: Aplica o efeito de reverb a um arquivo de áudio, utilizando um arquivo base para convolução.
- **Download de áudio de vídeos do YouTube**: Automatiza o download de faixas de áudio no formato .mp3 a partir de vídeos do YouTube, usando o yt-dlp.
- **Geração de gráficos**: Cria gráficos que representam o envelope do áudio, visualizando a amplitude ao longo do tempo.
- **Conversão de formatos de áudio**: Converte arquivos de áudio para outros formatos (por exemplo, de .wav para .mp3).
- **Renomeação automática de faixas**: Renomeia os arquivos de áudio baseando-se em suas traduções para o português (ex: "vocals" para "vocais").

## Tecnologias Utilizadas

1. **yt-dlp**: Para download de áudios a partir do YouTube.
2. **Spleeter**: Para separar faixas de áudio em componentes como voz, bateria, baixo, etc.
3. **Librosa**: Para análise e processamento de áudio.
4. **Pydub**: Para manipulação e conversão de arquivos de áudio.
5. **Matplotlib**: Para geração de gráficos de amplitude de áudio.
6. **Subprocess**: Para a execução de comandos externos, como o download de áudio.

## Estrutura das Opções

O projeto oferece diferentes modos de operação, selecionados por meio de uma variável de controle:

- **Opção 0**: Separação de áudio em 2 partes (vocais e acompanhamento).
- **Opção 1**: Separação de áudio em 4 partes (vocais, bateria, baixo, e acompanhamento).
- **Opção 2**: Separação de áudio em 5 partes (vocais, bateria, baixo, piano, e acompanhamento).
- **Opção 3**: Aplicação de efeito de reverb ao áudio utilizando outro arquivo como base.

## Requisitos de instalação

Antes de rodar o projeto, instale as seguintes dependências:

- **Python 3.x**
- **yt-dlp**
- **Spleeter**
- **Librosa**
- **Pydub**
- **Matplotlib**

Para instalar essas dependências, você pode usar o pip:

```dart
    pip install spleeter yt-dlp librosa pydub matplotlib
```

Além disso, certifique-se de que o ffmpeg esteja instalado em seu sistema, pois é necessário para a manipulação de arquivos de áudio.

## Como Usar

1. **Download de Áudio**: Insira o link do vídeo do YouTube no código e ele baixará automaticamente o áudio no formato .mp3.
2. **Separação de Faixas**: Escolha uma das opções de separação (2, 4 ou 5 faixas) e o áudio será separado em componentes.
3. **Efeito de Reverb**: Utilize a opção de reverb para aplicar o efeito utilizando um segundo arquivo de áudio como base.
4. **Geração de Gráficos**: Após a separação ou manipulação do áudio, gráficos de amplitude são gerados automaticamente para visualização.

### Exemplo de Execução

O código principal pode ser rodado com diferentes configurações:

- **Separar em 2 faixas**: Vocais e acompanhamento.
- **Separar em 4 faixas**: Vocais, bateria, baixo, e acompanhamento.
- **Separar em 5 faixas**: Vocais, bateria, baixo, piano, e acompanhamento.
- **Aplicar Reverb**: Convolução entre dois arquivos de áudio para adicionar reverb.
- Os resultados são salvos em uma pasta local, organizados em arquivos de áudio e imagens.

## Link para instalação do APK

Para fazer o download do apk do aplicativo, basta entrar no link a seguir e seguir as instruções de download: https://www.mediafire.com/file/m8qrlo20y495v3y/app-release.apk/file

## Considerações Finais

O aplicativo "Just Voice" é uma solução prática e intuitiva para separar e manipular faixas musicais. Ele pode ser utilizado tanto em dispositivos móveis quanto em desktops, oferecendo flexibilidade para os usuários que desejam editar suas músicas de maneira eficiente.
