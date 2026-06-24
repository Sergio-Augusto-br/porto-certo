class Passagem {
  const Passagem({
    required this.idPassagem,
    required this.idViagem,
    required this.idPassageiro,
    required this.idPortoEmbarque,
    required this.idPortoDesembarque,
    required this.valorTotal,
    this.statusReserva = 'Confirmada',
  });

  final String idPassagem;
  final String idViagem;
  final String idPassageiro;
  final String idPortoEmbarque;
  final String idPortoDesembarque;
  final double valorTotal;
  final String statusReserva;

  factory Passagem.fromJson(Map<String, dynamic> json) {
    return Passagem(
      idPassagem: json['idPassagem'].toString(),
      idViagem: json['idViagem'].toString(),
      idPassageiro: json['idPassageiro'].toString(),
      idPortoEmbarque: json['idPortoEmbarque'].toString(),
      idPortoDesembarque: json['idPortoDesembarque'].toString(),
      valorTotal: (json['valorTotal'] as num).toDouble(),
      statusReserva: json['statusReserva'] as String? ?? 'Confirmada',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idPassagem': idPassagem,
      'idViagem': idViagem,
      'idPassageiro': idPassageiro,
      'idPortoEmbarque': idPortoEmbarque,
      'idPortoDesembarque': idPortoDesembarque,
      'valorTotal': valorTotal,
      'statusReserva': statusReserva,
    };
  }
}
