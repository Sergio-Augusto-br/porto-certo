import 'package:intl/intl.dart';
import 'package:porto_certo/models/embarcacao.dart';
import 'package:porto_certo/models/parada.dart';
import 'package:porto_certo/models/viagem.dart';

class ViagemMockDB {
  const ViagemMockDB();

  // Fonte temporaria para a vitrine. Trocar por chamadas de API mantendo
  // os mesmos modelos reduz o impacto na camada de UI.
  static const List<Embarcacao> embarcacoes = [
    Embarcacao(
      idEmbarcacao: 1,
      nomeE: 'Expresso Rio Negro',
      tipo: 'Lancha Rápida',
      descricao:
          'Embarcação ágil para deslocamentos regionais com navegação diurna.',
      capacidadeCarga: 1.8,
      urlImagem:
          'https://placehold.co/900x420/0D47A1/FFFFFF/png?text=Lancha+Rapida',
    ),
    Embarcacao(
      idEmbarcacao: 2,
      nomeE: 'Princesa do Solimões',
      tipo: 'Navio Motor',
      descricao:
          'Navio regional preparado para viagens longas pelos rios amazônicos.',
      capacidadeCarga: 7.5,
      urlImagem:
          'https://placehold.co/900x420/0D47A1/FFFFFF/png?text=Navio+Motor',
    ),
    Embarcacao(
      idEmbarcacao: 3,
      nomeE: 'Ajato Amazonas',
      tipo: 'Ajato',
      descricao:
          'Ajato de médio porte voltado para rotas com alta demanda de passageiros.',
      capacidadeCarga: 2.4,
      urlImagem: 'https://placehold.co/900x420/0D47A1/FFFFFF/png?text=Ajato',
    ),
    Embarcacao(
      idEmbarcacao: 4,
      nomeE: 'Comandante Parintins',
      tipo: 'Barco Regional',
      descricao:
          'Barco regional com operação regular entre cidades do Médio Amazonas.',
      capacidadeCarga: 5.2,
      urlImagem:
          'https://placehold.co/900x420/0D47A1/FFFFFF/png?text=Barco+Regional',
    ),
  ];

  static final List<Viagem> viagens = [
    Viagem(
      idViagem: 1,
      nomeRota: 'Linha Manaus - Juruti',
      statusViagem: 'Confirmada',
      vagasDisponiveis: 28,
      embarcacao: embarcacoes[1],
      paradas: [
        Parada(
          idParada: 'P1-1',
          nomePorto: 'Manaus',
          ordem: 1,
          horarioChegada: '02/07/2026 06:30',
          horarioSaida: '02/07/2026 07:00',
          precoAcumulado: 0,
        ),
        Parada(
          idParada: 'P1-2',
          nomePorto: 'Itacoatiara',
          ordem: 2,
          horarioChegada: '02/07/2026 12:10',
          horarioSaida: '02/07/2026 12:40',
          precoAcumulado: 85,
        ),
        Parada(
          idParada: 'P1-3',
          nomePorto: 'Parintins',
          ordem: 3,
          horarioChegada: '02/07/2026 21:20',
          horarioSaida: '02/07/2026 22:00',
          precoAcumulado: 220,
        ),
        Parada(
          idParada: 'P1-4',
          nomePorto: 'Juruti',
          ordem: 4,
          horarioChegada: '03/07/2026 05:45',
          horarioSaida: '03/07/2026 06:10',
          precoAcumulado: 310,
        ),
      ],
    ),
    Viagem(
      idViagem: 2,
      nomeRota: 'Linha Itacoatiara - Santarém',
      statusViagem: 'Embarque Próximo',
      vagasDisponiveis: 42,
      embarcacao: embarcacoes[3],
      paradas: [
        Parada(
          idParada: 'P2-1',
          nomePorto: 'Itacoatiara',
          ordem: 1,
          horarioChegada: '03/07/2026 05:40',
          horarioSaida: '03/07/2026 06:00',
          precoAcumulado: 0,
        ),
        Parada(
          idParada: 'P2-2',
          nomePorto: 'Parintins',
          ordem: 2,
          horarioChegada: '03/07/2026 15:30',
          horarioSaida: '03/07/2026 16:10',
          precoAcumulado: 135.50,
        ),
        Parada(
          idParada: 'P2-3',
          nomePorto: 'Juruti',
          ordem: 3,
          horarioChegada: '03/07/2026 23:40',
          horarioSaida: '04/07/2026 00:20',
          precoAcumulado: 225,
        ),
        Parada(
          idParada: 'P2-4',
          nomePorto: 'Santarém',
          ordem: 4,
          horarioChegada: '04/07/2026 09:30',
          horarioSaida: '04/07/2026 10:00',
          precoAcumulado: 340,
        ),
      ],
    ),
    Viagem(
      idViagem: 3,
      nomeRota: 'Linha Manaus - Tefé',
      statusViagem: 'Confirmada',
      vagasDisponiveis: 17,
      embarcacao: embarcacoes[1],
      paradas: [
        Parada(
          idParada: 'P3-1',
          nomePorto: 'Manaus',
          ordem: 1,
          horarioChegada: '04/07/2026 17:20',
          horarioSaida: '04/07/2026 18:00',
          precoAcumulado: 0,
        ),
        Parada(
          idParada: 'P3-2',
          nomePorto: 'Manacapuru',
          ordem: 2,
          horarioChegada: '04/07/2026 23:30',
          horarioSaida: '05/07/2026 00:10',
          precoAcumulado: 95,
        ),
        Parada(
          idParada: 'P3-3',
          nomePorto: 'Coari',
          ordem: 3,
          horarioChegada: '05/07/2026 07:40',
          horarioSaida: '05/07/2026 08:20',
          precoAcumulado: 180,
        ),
        Parada(
          idParada: 'P3-4',
          nomePorto: 'Tefé',
          ordem: 4,
          horarioChegada: '05/07/2026 11:20',
          horarioSaida: '05/07/2026 11:50',
          precoAcumulado: 230,
        ),
      ],
    ),
    Viagem(
      idViagem: 4,
      nomeRota: 'Linha Manaus - Parintins Expressa',
      statusViagem: 'Confirmada',
      vagasDisponiveis: 9,
      embarcacao: embarcacoes[2],
      paradas: [
        Parada(
          idParada: 'P4-1',
          nomePorto: 'Manaus',
          ordem: 1,
          horarioChegada: '05/07/2026 07:45',
          horarioSaida: '05/07/2026 08:15',
          precoAcumulado: 0,
        ),
        Parada(
          idParada: 'P4-2',
          nomePorto: 'Itacoatiara',
          ordem: 2,
          horarioChegada: '05/07/2026 12:40',
          horarioSaida: '05/07/2026 13:00',
          precoAcumulado: 80,
        ),
        Parada(
          idParada: 'P4-3',
          nomePorto: 'Urucurituba',
          ordem: 3,
          horarioChegada: '05/07/2026 15:30',
          horarioSaida: '05/07/2026 15:50',
          precoAcumulado: 115,
        ),
        Parada(
          idParada: 'P4-4',
          nomePorto: 'Parintins',
          ordem: 4,
          horarioChegada: '05/07/2026 17:45',
          horarioSaida: '05/07/2026 18:10',
          precoAcumulado: 160,
        ),
      ],
    ),
    Viagem(
      idViagem: 5,
      nomeRota: 'Linha Tefé - Manaus',
      statusViagem: 'Confirmada',
      vagasDisponiveis: 31,
      embarcacao: embarcacoes[1],
      paradas: [
        Parada(
          idParada: 'P5-1',
          nomePorto: 'Tefé',
          ordem: 1,
          horarioChegada: '07/07/2026 17:00',
          horarioSaida: '07/07/2026 17:30',
          precoAcumulado: 0,
        ),
        Parada(
          idParada: 'P5-2',
          nomePorto: 'Coari',
          ordem: 2,
          horarioChegada: '08/07/2026 00:10',
          horarioSaida: '08/07/2026 00:50',
          precoAcumulado: 55,
        ),
        Parada(
          idParada: 'P5-3',
          nomePorto: 'Manacapuru',
          ordem: 3,
          horarioChegada: '08/07/2026 07:20',
          horarioSaida: '08/07/2026 07:50',
          precoAcumulado: 145,
        ),
        Parada(
          idParada: 'P5-4',
          nomePorto: 'Manaus',
          ordem: 4,
          horarioChegada: '08/07/2026 10:50',
          horarioSaida: '08/07/2026 11:20',
          precoAcumulado: 225,
        ),
      ],
    ),
    Viagem(
      idViagem: 6,
      nomeRota: 'Linha Parintins - Manaus',
      statusViagem: 'Embarque Próximo',
      vagasDisponiveis: 24,
      embarcacao: embarcacoes[0],
      paradas: [
        Parada(
          idParada: 'P6-1',
          nomePorto: 'Parintins',
          ordem: 1,
          horarioChegada: '08/07/2026 05:15',
          horarioSaida: '08/07/2026 05:45',
          precoAcumulado: 0,
        ),
        Parada(
          idParada: 'P6-2',
          nomePorto: 'Urucurituba',
          ordem: 2,
          horarioChegada: '08/07/2026 08:10',
          horarioSaida: '08/07/2026 08:30',
          precoAcumulado: 42,
        ),
        Parada(
          idParada: 'P6-3',
          nomePorto: 'Itacoatiara',
          ordem: 3,
          horarioChegada: '08/07/2026 14:55',
          horarioSaida: '08/07/2026 15:25',
          precoAcumulado: 128.90,
        ),
        Parada(
          idParada: 'P6-4',
          nomePorto: 'Manaus',
          ordem: 4,
          horarioChegada: '08/07/2026 20:10',
          horarioSaida: '08/07/2026 20:30',
          precoAcumulado: 210,
        ),
      ],
    ),
  ];

  static Embarcacao? buscarEmbarcacaoPorId(int id) {
    for (final embarcacao in embarcacoes) {
      if (embarcacao.idEmbarcacao == id) {
        return embarcacao;
      }
    }

    return null;
  }

  static Viagem? buscarViagemPorId(int id) {
    for (final viagem in viagens) {
      if (viagem.idViagem == id) {
        return viagem;
      }
    }

    return null;
  }

  static List<Viagem> buscar(String origem, String destino, String dataBusca) {
    final formatoData = DateFormat('dd/MM/yyyy');
    final formatoDataHora = DateFormat('dd/MM/yyyy HH:mm');
    final dataSelecionada = formatoData.parseStrict(dataBusca);

    return viagens.where((viagem) {
      final paradaOrigem = _buscarParadaPorPorto(viagem, origem);
      final paradaDestino = _buscarParadaPorPorto(viagem, destino);

      if (paradaOrigem == null || paradaDestino == null) {
        return false;
      }

      if (paradaDestino.ordem <= paradaOrigem.ordem) {
        return false;
      }

      final dataSaida = formatoDataHora.parseStrict(paradaOrigem.horarioSaida);

      // A busca por data considera apenas dia, mes e ano. O horario da saida
      // e ignorado para que viagens no mesmo dia, em horarios diferentes,
      // sejam retornadas para a mesma pesquisa do usuario.
      final mesmaData =
          dataSaida.year == dataSelecionada.year &&
          dataSaida.month == dataSelecionada.month &&
          dataSaida.day == dataSelecionada.day;

      return mesmaData;
    }).toList();
  }

  static Parada? _buscarParadaPorPorto(Viagem viagem, String nomePorto) {
    for (final parada in viagem.paradas) {
      if (parada.nomePorto == nomePorto) {
        return parada;
      }
    }

    return null;
  }
}
