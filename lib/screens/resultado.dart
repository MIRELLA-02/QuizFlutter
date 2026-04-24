import 'package:flutter/material.dart';

class Resultado extends StatelessWidget {
  final String nome;
  final int pontuacao;

  const Resultado({super.key, required this.nome, required this.pontuacao});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.emoji_events, size: 100, color: Colors.amber),
            const SizedBox(height: 20),
            Text(
              "Parabéns, $nome!",
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            Text(
              "Você acertou $pontuacao questões!",
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () =>
                  Navigator.popUntil(context, (route) => route.isFirst),
              child: const Text("Reiniciar Quiz"),
            ),
          ],
        ),
      ),
    );
  }
}
