import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class PickerPage extends StatefulWidget
{
  const PickerPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PickerPageState createState() => _PickerPageState();
}

class _PickerPageState extends State<PickerPage>
{
  final List<String> _audioFiles = []; // Lista para salvar o caminho dos audios selecionados pelo usuario
  final List<String> _imageFiles = []; // Lista para salvar o caminho das imagens selecionadas pelo usuario
  String _errorMessage = ''; // Mensagem de erro a ser exibida

  // Função para selecionar arquivos
  Future<void> _pickFiles() async
  {
    try
    {
      // Abre o seletor de arquivos e permite arquivos apenas com extensões mp3 e png
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['mp3', 'png'],
      );

      if (result != null)
      {
        final audioFiles = <String>[]; // Lista para armazenar os arquivos de áudio válidos
        final imageFiles = <String>[]; // Lista para armazenar os arquivos de imagem válidos

        for (var file in result.files)
        {
          final path = file.path!;

          if (_isValidFile(path))
          {
            final fileName = path.split('/').last; // Obtém o nome do arquivo removendo o caminho

            // Adiciona audios na lista de audios e imagens na lista de imagens
            if (path.endsWith('.mp3') && !_containsFile(_audioFiles, fileName))
            {
              audioFiles.add(path);
            }
            else if (path.endsWith('.png') && !_containsFile(_imageFiles, fileName))
            {
              imageFiles.add(path);
            }
          }
        }


        if (audioFiles.isEmpty && imageFiles.isEmpty)
        {
          setState(()
          {
            _errorMessage = 'Nenhum arquivo válido selecionado ou todos os arquivos selecionados já foram adicionados.';
          });
        }
        else
        {
          // Atualiza as listas com os arquivos selecionados
          setState(()
          {
            _audioFiles.addAll(audioFiles);
            _imageFiles.addAll(imageFiles);
            _errorMessage = '';
          });
        }
      }
      else
      {
        setState(()
        {
          _errorMessage = 'Nenhum arquivo selecionado.';
        });
      }
    }
    catch (e)
    {
      setState(()
      {
        _errorMessage = 'Erro ao selecionar os arquivos: $e';
      });
    }
  }

  // Verifica se o arquivo tem extetnsão .mp3 ou .png
  bool _isValidFile(String path)
  {
    return path.endsWith('.mp3') || path.endsWith('.png');
  }

  // Verifica se o arquivo já está na lista
  bool _containsFile(List<String> fileList, String fileName)
  {
    return fileList.any((file) => file.split('/').last == fileName);
  }

  // Limpa as listas com os arquivos selecionados de arquivos
  void _clearSelection()
  {
    setState(()
    {
      _audioFiles.clear();
      _imageFiles.clear();
      _errorMessage = '';
    });
  }

  // Função para abrir uma URL no navegador
  Future<void> _launchURL(String url) async
  {
    final Uri uri = Uri.parse(url);
    
    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication, // Isso força o link a ser aberto no navegador
    );
  }

  // Cria um botão para selecionar arquivos
  Widget _buildFilePickerButton()
  {
    return ElevatedButton(
      onPressed: _pickFiles,
      child: const Text('Selecionar Áudios e Imagens'),
    );
  }

  // Constrói o texto de erro se possuir
  Widget _buildErrorText()
  {
    return _errorMessage.isNotEmpty
        ? Text(
            _errorMessage,
            style: const TextStyle(color: Colors.red),
          )
        : const SizedBox.shrink(); // Retorna vazio se não tiver erro
  }

  // Mostra na tela todos os arquivos selecionados
  Widget _buildSelectedFilesList()
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        if (_audioFiles.isNotEmpty)
          const Text(
            'Áudios Selecionados:',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),

        for (var file in _audioFiles)
          Text(
            file.split('/').last,
            style: const TextStyle(color: Colors.white),
          ),
          
        if (_imageFiles.isNotEmpty)
          const Text(
            'Imagens Selecionadas:',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),

        for (var file in _imageFiles)
          Text(
            file.split('/').last,
            style: const TextStyle(color: Colors.white),
          ),
      ],
    );
  }

  AppBar _buildAppBar()
  {
    return AppBar(
      title: const Text(
        'Selecionar Áudios e Imagens',

        style: TextStyle(
          color: Colors.white,
        ),
      ),

      backgroundColor: Colors.black,
      iconTheme: const IconThemeData(color: Colors.white),
    );
  }

  Widget _body()
  {
    return Column(
      children: [
        const SizedBox(height: 16.0),

        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),

          child: Text(
            'Para realizar a separação de uma música clique no link abaixo e siga as instruções:',
            style: TextStyle(color: Colors.white, fontSize: 18.0),
          ),
        ),

        const SizedBox(height: 8.0),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),

          // Link para um site contendo o código em python
          child: GestureDetector(
            onTap: () => _launchURL('https://colab.research.google.com/drive/1R8XopcWmmOQHXu7BwfxQ0BHUTyTBa7fO?usp=sharing#scrollTo=UZMbNUumxB1Z'),
            
            child: const Text(
              'Clique aqui para ser redirecionado',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 18.0,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),

        const SizedBox(height: 8.0),

        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Após realizar a separação pegue e baixe a pasta "manipulacao302" depois clique no botão "Selecionar Áudios e Imagens" e selecione todos os arquivos de áudio e imagens dentro das pastas audios e images (Caso possua).',
            style: TextStyle(color: Colors.white, fontSize: 18.0),
          ),
        ),

        Expanded(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [
                _buildFilePickerButton(),
                const SizedBox(height: 16.0),
                _buildErrorText(),
                _buildSelectedFilesList(),
              ],
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(16.0),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,

            children: [
              // Botão para levar a pagina de visualização de imagens e audios
              ElevatedButton(
                onPressed: (_audioFiles.isNotEmpty)
                    ? () {
                        Navigator.pushNamed(
                          context,
                          '/viewAudio',

                          arguments:
                          {
                            'audioFiles': _audioFiles,
                            'imageFiles': _imageFiles,
                          },
                        );
                      }
                    : null,

                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  textStyle: const TextStyle(fontSize: 16.0),
                ),

                child: const Text('Visualizar Seleção'),
              ),

              // Botão para limpar a seleção de aarquivos
              ElevatedButton(
                onPressed: _clearSelection,

                style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero, // Deixa o botão quadrado
                  ),

                  padding: const EdgeInsets.all(16.0),
                  backgroundColor: Colors.red,
                ),

                child: const Icon(
                  Icons.close, // Ícone "X"
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: _buildAppBar(),

      backgroundColor: Colors.black,

      body: _body(),
    );
  }
}
