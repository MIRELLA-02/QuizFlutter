// home.dart
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'resultado.dart';

class Home extends StatefulWidget {
  final String nome;
  const Home({super.key, required this.nome});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int perguntaAtual = 0;
  int pontuacao = 0;
  String? respostaSelecionada;
  bool respondeu = false;
  List<dynamic> perguntas = [];

  bool flutuar = true;

  @override
  void initState() {
    super.initState();
    carregarPerguntas();
  }

  Future<void> carregarPerguntas() async {
    final String response = await rootBundle.loadString(
      'assets/mokup/perguntas.json',
    );
    final data = json.decode(response);
    setState(() => perguntas = data);
  }

  void verificarResposta() {
    if (respostaSelecionada == null || respondeu) return;

    if (respostaSelecionada == perguntas[perguntaAtual]["correta"]) {
      setState(() => pontuacao++);
    }
    setState(() => respondeu = true);
  }

  void proximaPergunta() {
    if (perguntaAtual < perguntas.length - 1) {
      setState(() {
        perguntaAtual++;
        respostaSelecionada = null;
        respondeu = false;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              Resultado(nome: widget.nome, pontuacao: pontuacao),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (perguntas.isEmpty)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));

    var p = perguntas[perguntaAtual];

    return Scaffold(
      appBar: AppBar(
        title: Text("Questão ${perguntaAtual + 1}"),
        backgroundColor: Colors.green[700],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: flutuar ? 12 : 0),
              duration: const Duration(seconds: 1),
              onEnd: () => setState(() => flutuar = !flutuar),
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, value),
                  child: child,
                );
              },
              child: const Icon(Icons.science, size: 80, color: Colors.green),
            ),

            const SizedBox(height: 10),
            Text(
              "Pontos: $pontuacao",
              style: const TextStyle(
                fontSize: 18,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            Text(
              p["pergunta"],
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 30),

            ...List.generate(p["opcoes"].length, (i) {
              String opcao = p["opcoes"][i];
              bool eCorreta = opcao == p["correta"];
              bool eSelecionada = opcao == respostaSelecionada;

              Color? corFundo;
              if (respondeu) {
                if (eCorreta)
                  corFundo = Colors.green[100];
                else if (eSelecionada)
                  corFundo = Colors.red[100];
              }

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: corFundo ?? Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: respondeu && eCorreta
                        ? Colors.green
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: RadioListTile<String>(
                  title: Text(opcao, style: const TextStyle(fontSize: 16)),
                  value: opcao,
                  groupValue: respostaSelecionada,
                  activeColor: Colors.green[700],
                  onChanged: respondeu
                      ? null
                      : (v) => setState(() => respostaSelecionada = v),
                  secondary: respondeu && eCorreta
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : (respondeu && eSelecionada
                            ? const Icon(Icons.cancel, color: Colors.red)
                            : null),
                ),
              );
            }),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: respondeu ? proximaPergunta : verificarResposta,
                style: ElevatedButton.styleFrom(
                  backgroundColor: respondeu
                      ? Colors.blueGrey
                      : Colors.green[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  respondeu ? "Próxima Questão" : "Confirmar Resposta",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
