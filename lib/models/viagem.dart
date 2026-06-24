import 'package:intl/intl.dart';
import 'package:porto_certo/models/embarcacao.dart';
import 'package:porto_certo/models/parada.dart';

class Viagem {
  const Viagem({
    required this.idViagem,
    required this.nomeRota,
    required this.paradas,
    required this.statusViagem,
    required this.vagasDisponiveis,
    required this.embarcacao,
  });

  final int idViagem;
  final String nomeRota;
  final List<Parada> paradas;
  final String statusViagem;
  final int vagasDisponiveis;
  final Embarcacao embarcacao;

  static final DateFormat _dateTimeFormat = DateFormat('dd/MM/yyyy HH:mm');

  String get origem => paradas.first.nomePorto;
  String get destino => paradas.last.nomePorto;
  DateTime get dtHoraSaida =>
      _dateTimeFormat.parseStrict(paradas.first.horarioSaida);
  DateTime get dtChegada =>
      _dateTimeFormat.parseStrict(paradas.last.horarioChegada);
  double get valor =>
      paradas.last.precoAcumulado - paradas.first.precoAcumulado;

  factory Viagem.fromJson(Map<String, dynamic> json) {
    return Viagem(
      idViagem: (json['idViagem'] ?? json['id_viagem']) as int,
      nomeRota: (json['nomeRota'] ?? json['nome_rota']) as String,
      paradas: (json['paradas'] as List<dynamic>)
          .map((parada) => Parada.fromJson(parada as Map<String, dynamic>))
          .toList(),
      statusViagem: (json['statusViagem'] ?? json['status_viagem']) as String,
      vagasDisponiveis:
          (json['vagas_disponiveis'] ?? json['vaga_disponivel']) as int,
      embarcacao: Embarcacao.fromJson(
        json['embarcacao'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idViagem': idViagem,
      'nomeRota': nomeRota,
      'paradas': paradas.map((parada) => parada.toJson()).toList(),
      'status_viagem': statusViagem,
      'vagas_disponiveis': vagasDisponiveis,
      'embarcacao': embarcacao.toJson(),
    };
  }
}
