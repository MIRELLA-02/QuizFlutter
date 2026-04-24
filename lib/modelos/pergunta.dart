class Pergunta {
  final int id;
  final String? ilustracao;
  final String pergunta;
  final List<String> respostas;
  final int correta;

  Pergunta({
    required this.id,
    this.ilustracao,
    required this.pergunta,
    required this.respostas,
    required this.correta,
  });

  factory Pergunta.fromJson(Map<String, dynamic> json) {
    return Pergunta(
      id: json['id'],
      ilustracao: json['ilustracao'],
      pergunta: json['pergunta'],
      respostas: List<String>.from(json['respostas']),
      correta: json['correta'],
    );
  }
}
