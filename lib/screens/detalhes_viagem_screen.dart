import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:porto_certo/models/parada.dart';
import 'package:porto_certo/models/viagem.dart';
import 'package:porto_certo/screens/compra_passagem_screen.dart';

class DetalhesViagemScreen extends StatefulWidget {
  const DetalhesViagemScreen({required this.viagem, super.key});

  final Viagem viagem;

  @override
  State<DetalhesViagemScreen> createState() => _DetalhesViagemScreenState();
}

class _DetalhesViagemScreenState extends State<DetalhesViagemScreen> {
  static const Color _navyBlue = Color(0xFF0D47A1);

  final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: r'R$',
  );

  late Parada _portoEmbarque;
  late Parada _portoDesembarque;

  @override
  void initState() {
    super.initState();
    _portoEmbarque = widget.viagem.paradas.first;
    _portoDesembarque = widget.viagem.paradas.last;
  }

  double get _valorPassagem {
    return _portoDesembarque.precoAcumulado - _portoEmbarque.precoAcumulado;
  }

  List<Parada> get _opcoesDesembarque {
    return widget.viagem.paradas
        .where((parada) => parada.ordem > _portoEmbarque.ordem)
        .toList();
  }

  void _alterarEmbarque(Parada? parada) {
    if (parada == null) {
      return;
    }

    setState(() {
      _portoEmbarque = parada;
      if (_portoDesembarque.ordem <= _portoEmbarque.ordem) {
        _portoDesembarque = _opcoesDesembarque.first;
      }
    });
  }

  void _alterarDesembarque(Parada? parada) {
    if (parada == null) {
      return;
    }

    setState(() => _portoDesembarque = parada);
  }

  @override
  Widget build(BuildContext context) {
    final viagem = widget.viagem;
    final embarcacao = viagem.embarcacao;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(title: const Text('Detalhes da viagem')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 220),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  viagem.nomeRota,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: _navyBlue,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Selecione o porto de embarque e desembarque para calcular o valor do trecho.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.grey[700]),
                ),
                const SizedBox(height: 20),
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: Image.network(
                    embarcacao.urlImagem,
                    height: 260,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const SizedBox(
                        height: 260,
                        child: Center(
                          child: Icon(Icons.directions_boat, size: 100),
                        ),
                      );
                    },
                  ),
                ),
                Card(
                  margin: EdgeInsets.zero,
                  elevation: 0,
                  color: Colors.white,
                  shape: const RoundedRectangleBorder(
                    side: BorderSide(color: Color(0xFFEEEEEE)),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(16),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          embarcacao.nomeE,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: _navyBlue,
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                        const SizedBox(height: 8),
                        _buildInfoLine(
                          icon: Icons.directions_boat,
                          label: 'Tipo',
                          value: embarcacao.tipo,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          embarcacao.descricao,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(color: Colors.grey[700], height: 1.45),
                        ),
                        const SizedBox(height: 12),
                        _buildInfoLine(
                          icon: Icons.inventory_2,
                          label: 'Capacidade de carga',
                          value:
                              '${embarcacao.capacidadeCarga.toStringAsFixed(1)} toneladas',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Card(
                  margin: EdgeInsets.zero,
                  elevation: 0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Informações da viagem',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: _navyBlue,
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                        const SizedBox(height: 10),
                        _buildInfoLine(
                          icon: Icons.verified,
                          label: 'Status',
                          value: viagem.statusViagem,
                        ),
                        const SizedBox(height: 20),
                        _buildTimeline(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 14),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Align(
            alignment: Alignment.center,
            heightFactor: 1,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= 720;

                  final selectors = Row(
                    children: [
                      Expanded(child: _buildEmbarqueDropdown()),
                      const SizedBox(width: 12),
                      Expanded(child: _buildDesembarqueDropdown()),
                    ],
                  );
                  final purchase = Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Apenas ${widget.viagem.vagasDisponiveis} vagas',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: Colors.grey[700]),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _currencyFormat.format(_valorPassagem),
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(
                                    color: _navyBlue,
                                    fontWeight: FontWeight.w900,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 18),
                      SizedBox(
                        width: 240,
                        child: ElevatedButton(
                          onPressed: () {
                            context.push(
                              '/checkout',
                              extra: CompraPassagemArgs(
                                viagem: widget.viagem,
                                portoEmbarque: _portoEmbarque,
                                portoDesembarque: _portoDesembarque,
                                valorPassagem: _valorPassagem,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _navyBlue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Comprar Passagem',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );

                  if (isWide) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        selectors,
                        const SizedBox(height: 10),
                        purchase,
                      ],
                    );
                  }

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildEmbarqueDropdown(),
                      const SizedBox(height: 8),
                      _buildDesembarqueDropdown(),
                      const SizedBox(height: 10),
                      purchase,
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmbarqueDropdown() {
    final opcoes = widget.viagem.paradas.take(widget.viagem.paradas.length - 1);

    return DropdownButtonFormField<Parada>(
      key: ValueKey('embarque-${_portoEmbarque.ordem}'),
      initialValue: _portoEmbarque,
      isExpanded: true,
      decoration: const InputDecoration(labelText: 'Embarque'),
      items: opcoes.map((parada) {
        return DropdownMenuItem<Parada>(
          value: parada,
          child: Text(parada.nomePorto),
        );
      }).toList(),
      onChanged: _alterarEmbarque,
    );
  }

  Widget _buildDesembarqueDropdown() {
    return DropdownButtonFormField<Parada>(
      key: ValueKey(
        'desembarque-${_portoEmbarque.ordem}-${_portoDesembarque.ordem}',
      ),
      initialValue: _portoDesembarque,
      isExpanded: true,
      decoration: const InputDecoration(labelText: 'Desembarque'),
      items: _opcoesDesembarque.map((parada) {
        return DropdownMenuItem<Parada>(
          value: parada,
          child: Text(parada.nomePorto),
        );
      }).toList(),
      onChanged: _alterarDesembarque,
    );
  }

  Widget _buildTimeline() {
    return Column(
      children: widget.viagem.paradas.map((parada) {
        final isFirst = parada == widget.viagem.paradas.first;
        final isLast = parada == widget.viagem.paradas.last;
        final isSelected =
            parada == _portoEmbarque || parada == _portoDesembarque;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 28,
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        width: 2,
                        color: isFirst
                            ? Colors.transparent
                            : _navyBlue.withValues(alpha: 0.25),
                      ),
                    ),
                    Container(
                      width: 13,
                      height: 13,
                      decoration: BoxDecoration(
                        color: isSelected ? _navyBlue : Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: _navyBlue, width: 2),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: 2,
                        color: isLast
                            ? Colors.transparent
                            : _navyBlue.withValues(alpha: 0.25),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${parada.ordem}. ${parada.nomePorto}',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: isSelected ? _navyBlue : Colors.grey[900],
                              fontWeight: isSelected
                                  ? FontWeight.w900
                                  : FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Chegada: ${parada.horarioChegada}  |  Saída: ${parada.horarioSaida}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                        'Preço acumulado: ${_currencyFormat.format(parada.precoAcumulado)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildInfoLine({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: _navyBlue.withValues(alpha: 0.78)),
        const SizedBox(width: 10),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: Colors.grey[800]),
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
