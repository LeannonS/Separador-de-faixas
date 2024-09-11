import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';
import 'package:separador/example_image_page.dart';
import 'dart:io';

class ExampleAudioPage extends StatefulWidget
{
  final int listNumber; // Recebe um numero para verificar o numero da musica de exemplo

  const ExampleAudioPage({super.key, required this.listNumber});

  @override
  State<StatefulWidget> createState() {
    return ExampleAudioPageState();
  }
}

class ExampleAudioPageState extends State<ExampleAudioPage>
{
  final List<Map<String, dynamic>> lists = [
    {
      'name': 'João Carreiro e Capataz - Prefacio',
      'audios': [
        'assets/audios/Prefacio_vocals.mp3',
        'assets/audios/Prefacio_drums.mp3',
        'assets/audios/Prefacio_bass.mp3',
        'assets/audios/Prefacio_piano.mp3',
        'assets/audios/Prefacio_other.mp3'
      ],
    },
    {
      'name': 'Crowded House - Don\'t Dream It\'s Over',
      'audios': [
        'assets/audios/dontDreamItsOver_vocals.mp3',
        'assets/audios/dontDreamItsOver_drums.mp3',
        'assets/audios/dontDreamItsOver_bass.mp3',
        'assets/audios/dontDreamItsOver_piano.mp3',
        'assets/audios/dontDreamItsOver_other.mp3'
      ],
    },
    {
      'name': 'Diogo Araújo - Calma Aí',
      'audios': [
        'assets/audios/CalmaAi_vocals.mp3',
        'assets/audios/CalmaAi_drums.mp3',
        'assets/audios/CalmaAi_bass.mp3',
        'assets/audios/CalmaAi_piano.mp3',
        'assets/audios/CalmaAi_other.mp3'
      ],
    },
  ];

  late List<AudioPlayer> _audioPlayers;
  late List<double> _volumeLevels;
  bool _isPlaying = false; // Verifica se os áudios estão tocando
  bool _isMounted = false; // Verifica se o widget está montado
  Duration _currentPosition = Duration.zero; // Posição atual do áudio
  Duration _totalDuration = Duration.zero; // Tempo total do áudio

  @override
  void initState()
  {
    super.initState();
    _isMounted = true; // Define que o widget está montado

    // Inicializa a lista de AudioPlayer
    _audioPlayers = List.generate(lists[widget.listNumber - 1]['audios'].length, (_) => AudioPlayer());
    _volumeLevels = List.generate(lists[widget.listNumber - 1]['audios'].length, (_) => 1.0); // Volume inicial 1.0 (máximo)

    _loadAudio(); // Carrega os áudios

    _audioPlayers[0].playerStateStream.listen((playerState)
    {
      if (!_isMounted) return;

      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;

      if (isPlaying != _isPlaying)
      {
        setState(()
        {
          _isPlaying = isPlaying;
        });
      }

      _audioPlayers[0].positionStream.listen((position)
      {
        if (!_isMounted) return;

        setState(()
        {
          _currentPosition = position;
        });
      });

      _audioPlayers[0].durationStream.listen((duration)
      {
        if (!_isMounted) return;

        setState(()
        {
          _totalDuration = duration ?? Duration.zero;
        });
      });

      if (processingState == ProcessingState.completed)
      {
        setState(()
        {
          _isPlaying = false;
        });
      }
    });
  }

  @override
  void dispose()
  {
    _isMounted = false;
    // ignore: avoid_function_literals_in_foreach_calls
    _audioPlayers.forEach((player) => player.dispose()); // Libera os recursos dos players de áudio
    super.dispose();
  }

  // Função para carregar os áudios
  Future<void> _loadAudio() async
  {
    // Pega a lista específica com base no número passado
    final selectedList = lists[widget.listNumber - 1];

    try
    {
      // Carrega e toca todos os áudios
      for (int i = 0; i < selectedList['audios'].length; i++)
      {
        await _audioPlayers[i].setAsset(selectedList['audios'][i]);
      }

      // Inicia a reprodução de todos os áudios
      await Future.wait(_audioPlayers.map((player) => player.play()));
    }
    catch (e)
    {
      // ignore: avoid_print
      print('Error loading audio: $e');
    }
  }

  Future<void> _togglePlayPause() async
  {
    try
    {
      if (_isPlaying)
      {
        await Future.wait(_audioPlayers.map((player) => player.pause())); // Pausa todos os áudios
      }
      else
      {
        await Future.wait(_audioPlayers.map((player) => player.play())); // Toca todos os áudios
      }
    }
    catch (e)
    {
      // ignore: avoid_print
      print('Error: $e');
    }
  }

  // Muda a posição do áudio
  Future<void> _seek(Duration position) async
  {
    await Future.wait(_audioPlayers.map((player) => player.seek(position))); // Define a nova posição para todos os áudios
  }

  // Avança o áudio 10 segundos
  Future<void> _skipForward() async
  {
    final newPosition = _currentPosition + const Duration(seconds: 10);
    if (newPosition < _totalDuration)
    {
      await _seek(newPosition);
    }
  }

  // Retrocede o áudio 10 segundos
  Future<void> _skipBackward() async
  {
    final newPosition = _currentPosition - const Duration(seconds: 10);

    if (newPosition > Duration.zero)
    {
      await _seek(newPosition);
    }
    else
    {
      await _seek(Duration.zero);
    }
  }

  Future<bool> _hasPermission() async
  {
    var status = await Permission.storage.status;

    if (status.isDenied)
    {
      status = await Permission.storage.request();
    }
    return status.isGranted;
  }

  Future<void> _saveAudio(String directory, String fileName, String assetPath) async
  {
    try
    {
      final byteData = await rootBundle.load(assetPath);
      final buffer = byteData.buffer.asUint8List();
      final file = File('$directory/$fileName');
      await file.writeAsBytes(buffer);

      if (mounted)
      {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Áudio salvo com sucesso em: ${file.path}')),
        );
      }
    }
    catch (e)
    {
      if (mounted)
      {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Não é possível salvar o áudio. Selecione outra pasta.')),
        );
      }
    }
  }

  Future<void> _saveAllAudios(String directory, Map<String, dynamic> audioData) async
  {
    try
    {
      final folderName = audioData['name'].replaceAll(' ', '_');
      final folderPath = '$directory/$folderName';
      final folder = Directory(folderPath);

      if (!await folder.exists())
      {
        await folder.create(recursive: true);
      }

      for (var audioPath in audioData['audios'])
      {
        final fileName = audioPath.split('/').last;
        await _saveAudio(folderPath, fileName, audioPath);
      }

      if (mounted)
      {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Todos os áudios salvos com sucesso em: $folderPath')),
        );
      }
    }
    catch (e)
    {
      if (mounted)
      {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Não é possível salvar os áudios. Selecione outra pasta.')),
        );
      }
    }
  }

  Future<void> _pickAndSaveSingleAudio(int index) async
  {
    bool hasPermission = await _hasPermission();
    if (!hasPermission)
    {
      if (mounted)
      {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permissão de armazenamento não concedida.')),
        );
      }
      return;
    }

    final result = await FilePicker.platform.getDirectoryPath();

    if (result != null)
    {
      final fileName = lists[widget.listNumber - 1]['audios'][index].split('/').last;
      await _saveAudio(result, fileName, lists[widget.listNumber - 1]['audios'][index]);
    }
  }

  Future<void> _pickAndSaveAllAudios() async
  {
    bool hasPermission = await _hasPermission();
    if (!hasPermission)
    {
      if (mounted)
      {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permissão de armazenamento não concedida.')),
        );
      }
      return;
    }

    final result = await FilePicker.platform.getDirectoryPath();

    if (result != null)
    {
      await _saveAllAudios(result, lists[widget.listNumber - 1]);
    }
  }

  // Atualiza o volume de um áudio específico
  void _updateVolume(int index, double volume)
  {
    _audioPlayers[index].setVolume(volume);
    setState(()
    {
      _volumeLevels[index] = volume;
    });
  }

  // Cria o botão para salvar todos os áudios
  _buildSaveAllButton()
  {
    return Padding(
      padding: const EdgeInsets.all(8.0),

      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.black, // Cor do texto do botão
          padding: const EdgeInsets.symmetric(vertical: 15.0),
        ),

        onPressed: _pickAndSaveAllAudios,

        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.download, color: Colors.white),
            SizedBox(width: 8.0),
            Text('Salvar Todos os Áudios'),
          ],
        ),
      ),
    );
  }

  // Constrói o título da categoria, controle de volume e botão de download.
  _buildCategoryTile(int index, List<String> category)
  {
    return ListTile(
      title: Text(
        category[index],
        style: const TextStyle(color: Colors.white),
      ),

      subtitle: Row(
        children: [
          Expanded(
            child: Slider(
              min: 0.0,
              max: 1.0,
              value: _volumeLevels[index],
              onChanged: (value) => _updateVolume(index, value),
              activeColor: Colors.white,
              inactiveColor: Colors.grey,
            ),
          ),

          IconButton(
            icon: const Icon(Icons.download, color: Colors.white),
            onPressed: () => _pickAndSaveSingleAudio(index),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar()
  {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),

      title: Text(
        lists[widget.listNumber - 1]['name'],
        style: const TextStyle(color: Colors.white),
      ),

      centerTitle: true,

      iconTheme: const IconThemeData(
        color: Colors.white,
      ),

      bottom: const TabBar(
        tabs: [
          Tab(text: 'Música'),
          Tab(text: 'Sinais'),
        ],

        indicatorColor: Colors.yellow, // Cor da linha abaixo da aba selecionada
        labelColor: Colors.yellow, // Cor do texto da aba selecionada
        unselectedLabelColor: Colors.white, // Cor do texto da aba não selecionada
      ),
    );
  }

  Widget _body()
  {
    final categories = ['Vocal', 'Bateria', 'Baixo', 'Piano', 'Outros'];

    return ListView(
      children: [
        const SizedBox(height: 16),
        
        ...List.generate(categories.length, (index) => _buildCategoryTile(index, categories)),
        _buildSaveAllButton(),

        // Botão para fornecer informações da separação
        Padding(
          padding: const EdgeInsets.all(8.0),

          child: Align(
            alignment: Alignment.center,

            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 57, 13, 65),
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                minimumSize: Size.zero, // Ajusta o tamanho mínimo para o tamanho do texto
                tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Reduz o tamanho do botão ao conteúdo
              ),

              onPressed: ()
              {
                Navigator.pushNamed(
                  context,
                  '/textPage',
                  arguments: 0, // Passa o número 0 para a TextPage
                );
              },

              child: const Text(
                'Como é feito a separação?',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }

  BottomAppBar _buildBottomAppBar()
  {
    return BottomAppBar(
      height: 143.0,
      color: Colors.black,

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Slider(
            min: 0.0,
            max: _totalDuration.inSeconds.toDouble(),
            value: _currentPosition.inSeconds.toDouble(),

            onChanged: (value)
            {
              _seek(Duration(seconds: value.toInt())); // Muda a posição do áudio
            },
          ),

          Text(
            '${_currentPosition.inMinutes}:${(_currentPosition.inSeconds % 60).toString().padLeft(2, '0')} / '
            '${_totalDuration.inMinutes}:${(_totalDuration.inSeconds % 60).toString().padLeft(2, '0')}',
            style: const TextStyle(color: Colors.white),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,

            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.skip_previous, color: Colors.white),
                onPressed: _skipBackward, // Função para retroceder
              ),

              IconButton(
                icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white),
                onPressed: _togglePlayPause, // Função para alternar entre play e pause
              ),

              IconButton(
                icon: const Icon(Icons.skip_next, color: Colors.white),
                onPressed: _skipForward, // Função para avançar
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context)
  {
    return DefaultTabController(
      length: 2, // Número de abas

      child: Scaffold(
        appBar: _buildAppBar(),

        backgroundColor: Colors.black,

        // Cria uma barra para trocar entre duas telas
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(), // Desativa a mudar de pagina arrastando
          
          children: [
            //Tela das musicas
            _body(),
            //Tela dos sinais
            const ExampleImagePage(index: 1),
          ],
        ),

        bottomNavigationBar: _buildBottomAppBar(),
      ),
    );
  }
}