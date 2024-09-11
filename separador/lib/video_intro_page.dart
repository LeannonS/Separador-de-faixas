import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class VideoIntroPage extends StatefulWidget
{
  const VideoIntroPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _VideoIntroPageState createState() => _VideoIntroPageState();
}

class _VideoIntroPageState extends State<VideoIntroPage>
{
  // Cria um controlador de video
  late VideoPlayerController _controller;

  @override
  void initState()
  {
    // Define a orientação fixa para esta tela (retrato neste exemplo)
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    super.initState();
    // Inicializa o controlador de vídeo com o arquivo de vídeo na pasta assets
    _controller = VideoPlayerController.asset('assets/videos/intro_video.mp4')

    ..initialize().then((_)
    {
      setState(() {});
      // Reproduz o video
      _controller.play();

      // Adiciona um listener para verificar quando o vídeo termina
      _controller.addListener(()
      {
        // Verifica se o vídeo acabou
        if (_controller.value.position == _controller.value.duration)
        {
          Navigator.pushReplacementNamed(context, '/home');
        }
      });
    });
  }

  @override
  void dispose()
  {
    // Remove o listener quando sair da pagina
    _controller.removeListener(() {});
    // Libera os recursos do controlador de vídeo
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: const Color(0xFF2C2B2C),

      body: Center(
        child: _controller.value.isInitialized
          ? AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            )
          : const CircularProgressIndicator(),
      ),
    );
  }
}
