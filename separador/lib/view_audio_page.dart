// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:separador/view_image_page.dart';

class ViewAudioPage extends StatefulWidget
{
  final List<String> audioFiles; // Lista com audios selecionados pelo usuario
  final List<String> imageFiles; // Lista com imagens selecionadas pelo usuario

  const ViewAudioPage({
    super.key,
    required this.audioFiles,
    required this.imageFiles,
  });

  @override
  State<StatefulWidget> createState()
  {
    return ViewAudioPageState();
  }
}

class ViewAudioPageState extends State<ViewAudioPage>
{
  late List<AudioPlayer> _audioPlayers; // Lista de players para cada audio
  late List<double> _volumeLevels; // Lista de volume para cada audio
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
    _audioPlayers = List.generate(widget.audioFiles.length, (_) => AudioPlayer());
    _volumeLevels = List.generate(widget.audioFiles.length, (_) => 1.0); // Volume inicial 1.0 (máximo)

    _loadAudio(); // Carrega os áudios

    // Verificador para atualizar a interface conforme o estado do player
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

      // Verificador para a posição do áudio
      _audioPlayers[0].positionStream.listen((position)
      {
        if (!_isMounted) return;

        setState(()
        {
          _currentPosition = position;
        });
      });

      // Verificador para a duração total do áudio
      _audioPlayers[0].durationStream.listen((duration)
      {
        if (!_isMounted) return;

        setState(()
        {
          _totalDuration = duration ?? Duration.zero;
        });
      });

      // Se o áudio tiver terminaado define que ele nao esta tocando (_isPlaying = false;)
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
    _isMounted = false; // Define que os players e recursos não estão mais montados

    // Libera os recursos dos players de áudio
    for (var player in _audioPlayers)
    {
      player.dispose();
    }
    super.dispose();
  }

  // Função para carregar os áudios
  Future<void> _loadAudio() async
  {
    try
    {
      // Define o caminho do arquivo para cada player
      for (int i = 0; i < widget.audioFiles.length; i++)
      {
        final filePath = widget.audioFiles[i];
        await _audioPlayers[i].setFilePath(filePath);
      }

      // Reproduz todos os áudios
      await Future.wait(_audioPlayers.map((player) => player.play()));
    }
    catch (e)
    {
      print('Erro ao carregar áudio: $e');
    }
  }

  // Alterna entre reproduzir e pausar os áudios
  Future<void> _togglePlayPause() async
  {
    try
    {
      // Se está tocando (_isPlaying == true) então pausa os áudios senão coloca eles para tocar
      if (_isPlaying)
      {
        await Future.wait(_audioPlayers.map((player) => player.pause()));
      }
      else
      {
        await Future.wait(_audioPlayers.map((player) => player.play()));
      }
    }
    catch (e)
    {
      print('Erro: $e');
    }
  }

  // Função para alterar a posição do áudio
  Future<void> _seek(Duration position) async
  {
    await Future.wait(_audioPlayers.map((player) => player.seek(position)));
  }

  // Pula 10 segundos para frente
  Future<void> _skipForward() async
  {
    final newPosition = _currentPosition + const Duration(seconds: 10);

    if (newPosition < _totalDuration)
    {
      await _seek(newPosition);
    }
  }

  // Pula 10 segundos para trás
  Future<void> _skipBackward() async
  {
    final newPosition = _currentPosition - const Duration(seconds: 10);

    // Verifica se a nova posição após voltar 10 segundos é maior que 0
    if (newPosition > Duration.zero)
    {
      await _seek(newPosition);
    }
    else
    {
      await _seek(Duration.zero);
    }
  }

  // Atualiza o volume do áudio
  void _updateVolume(int index, double volume)
  {
    _audioPlayers[index].setVolume(volume);

    setState(()
    {
      _volumeLevels[index] = volume;
    });
  }

  // Cria um texto com o nome do arquivo de áudio e um controle de volume
  Widget _buildCategoryTile(int index, List<String> category)
  {
    return ListTile(
      title: Text(
        category[index], // Nome do arquivo de áudio
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
        ],
      ),
    );
  }

  AppBar _buildAppBar()
  {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),

      title: const Text(
        'Música',
        style: TextStyle(color: Colors.white),
      ),

      centerTitle: true,

      iconTheme: const IconThemeData(
        color: Colors.white,
      ),

      bottom: widget.imageFiles.isEmpty ? null // Se a lista de imagens estiver vazia, não adiciona uma TabBar
        : const TabBar(
            tabs: [
              Tab(text: 'Música'),
              Tab(text: 'Sinais'),
            ],
            indicatorColor: Colors.yellow,
            labelColor: Colors.yellow,
            unselectedLabelColor: Colors.white,
          ),
    );
  }

  Widget _body()
  {
    final categories = widget.audioFiles.map((audioFile)
    {
      return audioFile.split('/').last.split('.').first; // Nome do arquivo sem extensão
    }).toList();

    return ListView(
      children: [
        const SizedBox(height: 16),

        ...List.generate(categories.length, (index) => _buildCategoryTile(index, categories)),

        Padding(
          padding: const EdgeInsets.all(8.0),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,

            // Botão para a página esxplicando sobre separação
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 57, 13, 65),
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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

              const SizedBox(width: 16),

              // Botão para a pagina que explica como funciona a aplicação de efeitos
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 57, 13, 65),
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),

                onPressed: ()
                {
                  Navigator.pushNamed(
                    context,
                    '/textPage',
                    arguments: 2, // Passa o número 2 para a TextPage
                  );
                },

                child: const Text(
                  'Como é feito os efeitos?',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Cria na parte de baixo da tela o controle de reprodução de audio
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
              _seek(Duration(seconds: value.toInt()));
            },
          ),

          // Duração da musica
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
                onPressed: _skipBackward,
              ),

              IconButton(
                icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white),
                onPressed: _togglePlayPause,
              ),

              IconButton(
                icon: const Icon(Icons.skip_next, color: Colors.white),
                onPressed: _skipForward,
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
      length: widget.imageFiles.isEmpty ? 1 : 2, // Caso o usuario não selecione imagem define o numero de telas como 1

      child: Scaffold(
        appBar: _buildAppBar(),

        backgroundColor: const Color.fromARGB(255, 0, 0, 0),

        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(), // Desativa mudar a tela para o lado arrastando

          children: [
            _body(),

            if (widget.imageFiles.isNotEmpty)
              ViewImagePage(imageFiles: widget.imageFiles), // Se tiver imagem cria a segunda pagina
          ],
        ),

        bottomNavigationBar: _buildBottomAppBar(),
      ),
    );
  }
}
