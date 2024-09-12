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

## Link para instalação do APK

Para fazer o download do apk do aplicativo, basta entrar no link a seguir e seguir as instruções de download: https://www.mediafire.com/file/m8qrlo20y495v3y/app-release.apk/file

## Considerações Finais

O aplicativo "Just Voice" é uma solução prática e intuitiva para separar e manipular faixas musicais. Ele pode ser utilizado tanto em dispositivos móveis quanto em desktops, oferecendo flexibilidade para os usuários que desejam editar suas músicas de maneira eficiente.
