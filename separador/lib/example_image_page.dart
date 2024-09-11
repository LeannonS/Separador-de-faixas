import 'package:flutter/material.dart';

class ExampleImagePage extends StatefulWidget
{
  final int index; // numero que indica qual musica foi selecionada 0- prefacio, 1- dont'dream, 2- calmaAi

  const ExampleImagePage({super.key, required this.index});

  @override
  // ignore: library_private_types_in_public_api
  _ExampleImagePageState createState() => _ExampleImagePageState();
}

class _ExampleImagePageState extends State<ExampleImagePage>
{
  late TransformationController _transformationController;
  final double scale = 4.5; // Escala inicial

  // Lista de imagens de cada uma das musicas teste
  final List<List<String>> imageLists = [
    ['Prefacio.png', 'Prefacio_vocals.png', 'Prefacio_drums.png', 'Prefacio_bass.png', 'Prefacio_piano.png', 'Prefacio_other.png'],
    ['CalmaAi_sinal.png', 'CalmaAi_vocals.png', 'CalmaAi_drums.png', 'CalmaAi_bass.png', 'CalmaAi_piano.png', 'CalmaAi_other.png'],
    ['teste.png', 'teste.png', 'teste.png', 'teste.png', 'teste.png', 'teste.png'],
  ];

  final categories = ['Música', 'Vocal', 'Bateria', 'Baixo', 'Piano', 'Outros']; // Categorias correspondentes às imagens

  @override
  void initState()
  {
    super.initState();
    _transformationController = TransformationController();

    WidgetsBinding.instance.addPostFrameCallback((_)
    {
      final size = MediaQuery.of(context).size;
      final double containerHeight = size.height / 4;

      // Ajuste a posição da imagem dentro do container
      const double translateX = 0;
      final double imageHeightVisible = containerHeight / scale;
      final double translateY = containerHeight - imageHeightVisible;

      // faz com que a imagem comece sendo apresentada completa dentro do container
      Matrix4 matrix = Matrix4.identity()
        ..scale(scale)
        ..translate(translateX, -translateY);

      _transformationController.value = matrix;
    });
  }

  // Função para construir os containers com as imagens e seus nomes
  Widget _buildImageContainer(String imageName, String categoryName)
  {
    return Column(
      children: [
        // Exibe a categoria acima da imagem
        Text(
          categoryName,
          
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),

        const SizedBox(height: 8),

        SizedBox(
          height: MediaQuery.of(context).size.height / 4, // Ocupa um quarto da altura da tela
          width: double.infinity, // Ocupa toda a largura da tela

          child: InteractiveViewer(
            transformationController: _transformationController,
            minScale: scale, // Zoom mínimo da imagem
            maxScale: 8, // Zoom máximo da imagem

            child: Align(
              alignment: Alignment.bottomLeft, // Alinha a imagem na parte inferior esquerda
              
              child: Image.asset(
                'assets/images/$imageName',
                fit: BoxFit.contain, // Mantém a proporção da imagem
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _body()
  {
    // Obtenha a lista de imagens com base no índice passado
    final List<String> images = imageLists[widget.index];

    return SingleChildScrollView(
      child: Column(
        children: [
          // Mostra o sinal na tela e o nome para cada uma das imagens presente na lista selecionada
          for (var i = 0; i < images.length; i++) ...[
            const SizedBox(height: 16),
            _buildImageContainer(images[i], categories[i]), // Chama a função para criar a imagem e exibir a categoria
          ],

          const SizedBox(height: 25),

          Padding(
            padding: const EdgeInsets.all(8.0),

            child: Align(
              alignment: Alignment.center,

              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 57, 13, 65),
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  minimumSize: Size.zero, // Ajusta o tamanho mínimo do botao para o tamanho do texto
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Reduz o tamanho do botão ao conteúdo
                ),
                
                onPressed: ()
                {
                  Navigator.pushNamed(
                    context,
                    '/textPage',
                    arguments: 1, // Passa o número 0 para a TextPage
                  );
                },

                child: const Text(
                  'Como analisar os sinais?',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Colors.black,

      body: _body(),
    );
  }
}