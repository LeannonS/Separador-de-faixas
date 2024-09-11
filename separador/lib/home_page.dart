import 'package:flutter/material.dart';

class HomePage extends StatefulWidget
{
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState()
  {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage>
{
  AppBar _buildAppBar()
  {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,

      // Realiza um degrade entre as cores Color(0xFF430050), Colors.black
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF430050), Colors.black],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),

      leading: _buildLogo(),
      title: _buildText(),
    );
  }

  Widget _body()
  {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            const Text(
              'Realize a separação de vocais e instrumentos\n'
              'de suas músicas favoritas!',

              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),

              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 50),

            _buildButtonToPicker(context), // Chama a função que constroi um botao para levar a pagina de selecoa de audio

            const SizedBox(height: 100),

            const Text(
              'Veja exemplos de algumas músicas',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),
            _buildButtonContainer(context, 'assets/images/prefacio.jpg', 'João Carreiro e Capataz - Prefacio', 1),

            const SizedBox(height: 20),
            _buildButtonContainer(context, 'assets/images/dontDreamItsOver.jpeg', 'Crowded House - Don\'t Dream It\'s Over', 2),

            const SizedBox(height: 20),
            _buildButtonContainer(context, 'assets/images/calmaAi.png', 'Diogo Araújo - Calma Aí', 3),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Constroi o botao que leva para uma pagina de selecao de audio
  Widget _buildButtonToPicker(BuildContext context)
  {
    return GestureDetector(
      onTap: ()
      {
        Navigator.pushNamed(context, '/picker');
      },

      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(8),

        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white,
            width: 2,
            style: BorderStyle.solid,
          ),

          borderRadius: BorderRadius.circular(12), // Arredonda as bordas
        ),

        child: const Center(
          child: Text(
            'Visualize a separação',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),

            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  // Constroi os botoes com a imagem e nome das musicas de exemplo
  Widget _buildButtonContainer(BuildContext context, String imagePath, String musicName, int n)
  {
    return GestureDetector(
      onTap: ()
      {
        Navigator.pushNamed(
          context,
          '/example',
          arguments: n, // Passa um número de referencia para ver qual lista pegar
        );
      },

      child: Container(
        // Espaçamento entre as caixas e as bordas
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        color: const Color.fromARGB(255, 0, 0, 0),

        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),

              child: Image.asset(
                imagePath,
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.2,
                fit: BoxFit.cover,
              ),
            ),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),

              decoration: BoxDecoration(
                color: Colors.grey[850],

                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),

                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(2, 2),
                  ),
                ],
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Alinha o texto à esquerda

                children: [
                  Text(
                    musicName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  const Text(
                    'Vocais / Bateria / Baixo / Piano / Outros',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Constroi a logo que fica na AppBar
  Widget _buildLogo()
  {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      
      child: Image.asset(
        'assets/images/logo.png',
        height: 60,
        fit: BoxFit.cover,
      ),
    );
  }

  // Monta o texto presente na appBar
  Widget _buildText()
  {
    return const Text(
      'Just Voice',
      style: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  // faz a confirmacao se o usuario realmente quer sair do app quando ele clica no botao de voltar
  Future<bool> _onWillPop() async
  {
    return (await showDialog(
      context: context,

      // Mostra um aviso ao usuario
      builder: (context) => AlertDialog(
        title: const Text('Confirmação'),
        content: const Text('Você realmente deseja fechar o aplicativo?'),

        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Não'),
          ),

          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Sim'),
          ),
        ],
      ),
    )) ??

    false;
  }

  @override
  Widget build(BuildContext context)
  {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: _onWillPop,

      child: Scaffold(
        appBar: _buildAppBar(),

        backgroundColor: Colors.black,
        
        body: _body(),
      ),
    );
  }
}
