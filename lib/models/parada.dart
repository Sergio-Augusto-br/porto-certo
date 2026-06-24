class Parada {
  const Parada({
    required this.idParada,
    required this.nomePorto,
    required this.ordem,
    required this.horarioChegada,
    required this.horarioSaida,
    required this.precoAcumulado,
  });

  final String idParada;
  final String nomePorto;
  final int ordem;
  final String horarioChegada;
  final String horarioSaida;
  final double precoAcumulado;

  factory Parada.fromJson(Map<String, dynamic> json) {
    return Parada(
      idParada: (json['idParada'] ?? json['id_parada']).toString(),
      nomePorto: (json['nomePorto'] ?? json['nome_porto']) as String,
      ordem: json['ordem'] as int,
      horarioChegada:
          (json['horarioChegada'] ?? json['horario_chegada']) as String,
      horarioSaida: (json['horarioSaida'] ?? json['horario_saida']) as String,
      precoAcumulado:
          ((json['precoAcumulado'] ?? json['preco_acumulado']) as num)
              .toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idParada': idParada,
      'nomePorto': nomePorto,
      'ordem': ordem,
      'horarioChegada': horarioChegada,
      'horarioSaida': horarioSaida,
      'precoAcumulado': precoAcumulado,
    };
  }
}
