class Embarcacao {
  const Embarcacao({
    required this.idEmbarcacao,
    required this.nomeE,
    required this.tipo,
    required this.descricao,
    required this.capacidadeCarga,
    required this.urlImagem,
  });

  final int idEmbarcacao;
  final String nomeE;
  final String tipo;
  final String descricao;
  final double capacidadeCarga;
  final String urlImagem;

  factory Embarcacao.fromJson(Map<String, dynamic> json) {
    return Embarcacao(
      idEmbarcacao: (json['idEmbarcacao'] ?? json['id_embarcacao']) as int,
      nomeE: (json['nome_E'] ?? json['nome_e']) as String,
      tipo: json['tipo'] as String,
      descricao: json['descricao'] as String,
      capacidadeCarga: (json['capacidade_carga'] as num).toDouble(),
      urlImagem: (json['urlImagem'] ?? json['url_imagem']) as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idEmbarcacao': idEmbarcacao,
      'nome_E': nomeE,
      'tipo': tipo,
      'descricao': descricao,
      'capacidade_carga': capacidadeCarga,
      'urlImagem': urlImagem,
    };
  }
}
