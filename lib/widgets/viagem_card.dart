import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:porto_certo/models/viagem.dart';

class ViagemCard extends StatelessWidget {
  ViagemCard({required this.viagem, required this.onVerDetalhes, super.key});

  static const Color _navyBlue = Color(0xFF0D47A1);

  final Viagem viagem;
  final VoidCallback onVerDetalhes;
  final DateFormat _dateTimeFormat = DateFormat('dd/MM/yyyy HH:mm');
  final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: r'R$',
  );

  @override
  Widget build(BuildContext context) {
    final embarcacao = viagem.embarcacao;

    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '${viagem.origem} \u2192 ${viagem.destino}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: _navyBlue,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 14),
            _buildCardInfoLine(
              icon: Icons.schedule,
              label: 'Saída',
              value: _dateTimeFormat.format(viagem.dtHoraSaida),
            ),
            const SizedBox(height: 8),
            _buildCardInfoLine(
              icon: Icons.flag,
              label: 'Chegada',
              value: _dateTimeFormat.format(viagem.dtChegada),
            ),
            const SizedBox(height: 14),
            Text(
              _currencyFormat.format(viagem.valor),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: _navyBlue,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 12),
            _buildCardInfoLine(
              icon: Icons.directions_boat,
              label: embarcacao.tipo,
              value: embarcacao.nomeE,
            ),
            const SizedBox(height: 8),
            _buildCardInfoLine(
              icon: Icons.event_seat,
              label: 'Vagas',
              value: '${viagem.vagasDisponiveis} disponíveis',
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: onVerDetalhes,
              style: ElevatedButton.styleFrom(
                backgroundColor: _navyBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Ver Detalhes',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardInfoLine({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: _navyBlue.withValues(alpha: 0.78)),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.grey[800], height: 1.25),
              children: [
                TextSpan(
                  text: '$label: ',
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                TextSpan(text: value),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
