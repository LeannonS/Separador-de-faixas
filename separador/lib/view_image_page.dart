import 'dart:io'; // Adicione esta importação para usar File
import 'package:flutter/material.dart';

class ViewImagePage extends StatefulWidget
{
  final List<String> imageFiles; // Lista contendo os caminhos das imagens selecionadas pelo usuário

  const ViewImagePage({super.key, required this.imageFiles});

  @override
  // ignore: library_private_types_in_public_api
  _ViewImagePageState createState() => _ViewImagePageState();
}

class _ViewImagePageState extends State<ViewImagePage>
{
  late TransformationController _transformationController; // Variável que vai controlar o zoom e movimento das imagens na tela
  final double scale = 4.5; // Escala inicial

  @override
  void initState()
  {
    super.initState();
    _transformationController = TransformationController(); // Inicia o controlador

    WidgetsBinding.instance.addPostFrameCallback((_)
    {
      final size = MediaQuery.of(context).size;
      final double containerHeight = size.height / 4; // Cada imagem ocupa 1/4 da tela

      // Ajuste a posição da imagem dentro do container
      const double translateX = 0;
      final double imageHeightVisible = containerHeight / scale; // Calcula a altura visível da imagem após o zoom
      final double translateY = containerHeight - imageHeightVisible; // Deslocamento vertical para ajustar a imagem

      // Faz com que a imagem comece sendo apresentada completa dentro do container
      Matrix4 matrix = Matrix4.identity()
        ..scale(scale)
        ..translate(translateX, -translateY);

      _transformationController.value = matrix;
    });
  }

  // Função para construir os containers com as imagens e os nomes de cada um
  Widget _buildImageContainer(String imagePath)
  {
    // Extrai o nome do arquivo sem a extensão
    final fileName = imagePath.split('/').last.split('.').first;

    return Column(
      children: [
        // Exibe o nome do arquivo
        Text(
          fileName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),

        SizedBox(
          height: MediaQuery.of(context).size.height / 4, // Ocupa um quarto da altura da tela
          width: double.infinity, // Ocupa toda a largura da tela

          child: InteractiveViewer(
            transformationController: _transformationController,
            minScale: scale, // Zoom mínimo da imagem
            maxScale: 8, // Zoom máximo da imagem

            child: Align(
              alignment: Alignment.bottomLeft, // Alinha a imagem na parte inferior esquerda

              child: Image.file(
                File(imagePath), // Usa File para carregar a imagem a partir do caminho
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
    return SingleChildScrollView(
      child: Column(
        children: [
          // Mostra uma imagem na tela para cada uma das imagens presentes na lista selecionada
          for (var imagePath in widget.imageFiles) ...[
            const SizedBox(height: 16),
            _buildImageContainer(imagePath), // Chama a função para criar as imagens dos sinais
          ],

          const SizedBox(height: 25),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.center,

              // Botão para mudar para a pagina que explica como analisar a separacao
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 57, 13, 65),
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  minimumSize: Size.zero, // Ajusta o tamanho mínimo do botão para o tamanho do texto
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Deixa o botao do tamanho do texto
                ),

                onPressed: ()
                {
                  Navigator.pushNamed(
                    context,
                    '/textPage',
                    arguments: 1, // Passa o número 1 para a TextPage
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
