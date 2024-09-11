import 'package:flutter/material.dart';
import 'package:separador/home_page.dart';
import 'package:separador/picker_page.dart';
import 'package:separador/video_intro_page.dart';
import 'package:separador/example_audio_page.dart';
import 'package:separador/text_page.dart';
import 'package:separador/view_audio_page.dart';

class AppWidget extends StatelessWidget
{
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      // Define a rota inicial
      initialRoute: '/',

      onGenerateRoute: (settings)
      {
        if (settings.name == '/view')
        {
          final args = settings.arguments as int;

          return MaterialPageRoute(
            builder: (context)
            {
              return ExampleAudioPage(listNumber: args);
            },
          );
        }

        // Rota para TextPage
        if (settings.name == '/textPage')
        {
          final args = settings.arguments as int;

          return MaterialPageRoute(
            builder: (context)
            {
              return TextPage(textIndex: args);
            },
          );
        }

        // Rota para ViewAudioPage
        if (settings.name == '/viewAudio') {
          final args = settings.arguments as Map<String, List<String>>; // Recebe List<String>

          return MaterialPageRoute(
            builder: (context) {
              final audioFiles = args['audioFiles'] ?? [];
              final imageFiles = args['imageFiles'] ?? [];
              return ViewAudioPage(audioFiles: audioFiles, imageFiles: imageFiles);
            },
          );
        }

        // Definindo rotas padrões
        switch (settings.name)
        {
          case '/':
            return MaterialPageRoute(builder: (context) => const VideoIntroPage());

          case '/home':
            return MaterialPageRoute(builder: (context) => const HomePage());

          case '/picker':
            return MaterialPageRoute(builder: (context) => const PickerPage());

          case '/example':
          // Recebe o argumento passado para a rota
            final args = settings.arguments as int;

            return MaterialPageRoute(
              builder: (context) => ExampleAudioPage(listNumber: args),
            );

          default:
            return MaterialPageRoute(builder: (context) => const HomePage());
        }
      },
    );
  }
}
