import 'package:flutter/material.dart';

class TextPage extends StatelessWidget
{
  final int textIndex;

  const TextPage({super.key, required this.textIndex});

  static const List<String> texts = [
    'Quando um arquivo de áudio é enviado para o Spleeter, o sistema primeiro analisa o espectro de frequências do áudio, mapeando as diferentes frequências associadas a cada elemento sonoro. Cada componente, como a voz humana, que geralmente ocupa uma faixa de frequência entre 40 e 50 Hz, é identificado com base em seu padrão único de frequência. Depois, ele separa esta frequência das outras possíveis faixas contidas no arquivo de áudio, como por exemplo, uma bateria. A partir disso, é criada uma faixa de áudio para cada frequência existente. O Spleeter consegue fazer essa separação por conta das diferenças existentes em cada som emitido. O processo é totalmente automatizado e resulta na criação de faixas individuais para cada elemento da música.',
    
    'Para analisar como a separação das faixas de áudio afeta a música e entender o impacto da convolução, como o reverb, siga alguns passos essenciais. Primeiro, observe cada faixa individualmente após a separação para identificar mudanças na clareza e no equilíbrio dos elementos musicais. Por exemplo, ao isolar os vocais, você pode verificar se eles mantêm sua presença ou se perdem força em comparação com a mixagem original. Em seguida, ao convoluir uma faixa com reverb, por exemplo, compare o sinal original com o sinal convoluído, o próprio aplicativo irá gerar um gráfico mostrando as faixas de frequência dos áudios, então você consegue analisar o tempo de decaimento e a distribuição das frequências. O reverb geralmente estende o som, adicionando um eco perceptível e aumentando a sensação de espaço. Se o sinal mostra um decaimento mais longo e uma dispersão de frequências mais ampla, isso indica que a convolução com reverb foi aplicada corretamente.',
    
    'Quando aplicamos o reverb a uma faixa de áudio, utilizamos uma técnica chamada convolução, que combina o sinal original com um "impulse response" (IR), ou resposta ao impulso, que geralmente tem cerca de 1 segundo de duração. Essa resposta ao impulso é uma gravação de como o som se comporta em um ambiente específico, como uma sala ou catedral. Ao convoluir o áudio original com essa resposta ao impulso, criamos uma simulação de como o som seria percebido naquele espaço.\n\nO reverb gerado através da convolução com um áudio de 1 segundo ocorre porque o impulso captura as reflexões iniciais e o decaimento do som no ambiente. Quando esse padrão é aplicado ao áudio original, ele replica essas características, adicionando profundidade e eco à faixa. O resultado é um som que parece ter sido gravado em um ambiente muito maior do que o espaço em que foi originalmente capturado, criando uma sensação de espaço e atmosfera que é essencial em muitas produções musicais.'
  ];

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),

        child: Center(
          child: Text(
            texts[textIndex],

            style: const TextStyle(
              fontSize: 18.0,
              color: Colors.black,
            ),
            
            textAlign: TextAlign.justify,
          ),
        ),
      ),
    );
  }
}
