import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:porto_certo/data/viagem_mock_db.dart';
import 'package:porto_certo/models/viagem.dart';
import 'package:porto_certo/services/api_service.dart';
import 'package:porto_certo/widgets/viagem_card.dart';

class ResultadosBuscaScreen extends StatefulWidget {
  const ResultadosBuscaScreen({
    required this.origem,
    required this.destino,
    required this.dataBusca,
    super.key,
  });

  final String origem;
  final String destino;
  final String dataBusca;

  @override
  State<ResultadosBuscaScreen> createState() => _ResultadosBuscaScreenState();
}

class _ResultadosBuscaScreenState extends State<ResultadosBuscaScreen> {
  static const Color _navyBlue = Color(0xFF0D47A1);

  List<Viagem> _resultados = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _buscarResultados();
  }

  Future<void> _buscarResultados() async {
    if (widget.origem.isEmpty ||
        widget.destino.isEmpty ||
        widget.dataBusca.isEmpty) {
      setState(() => _carregando = false);
      return;
    }

    try {
      final resultados = await ApiService().buscarViagens(
        origem: widget.origem,
        destino: widget.destino,
        dataBusca: widget.dataBusca,
      );
      if (!mounted) {
        return;
      }
      setState(() => _resultados = resultados);
    } catch (_) {
      try {
        _resultados = ViagemMockDB.buscar(
          widget.origem,
          widget.destino,
          widget.dataBusca,
        );
      } on FormatException {
        _resultados = [];
      }
    } finally {
      if (mounted) {
        setState(() => _carregando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final resumo =
        'Resultados para: ${widget.origem} \u2192 ${widget.destino} em ${widget.dataBusca}';

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Resultados da busca'),
        backgroundColor: _navyBlue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  resumo,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: _navyBlue,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: _carregando
                      ? const Center(child: CircularProgressIndicator())
                      : _resultados.isEmpty
                      ? _buildEmptyState(context)
                      : ListView.builder(
                          itemCount: _resultados.length,
                          itemBuilder: (context, index) {
                            final viagem = _resultados[index];

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: ViagemCard(
                                viagem: viagem,
                                onVerDetalhes: () {
                                  context.go('/viagens/${viagem.idViagem}');
                                },
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off, size: 72, color: Colors.grey[500]),
          const SizedBox(height: 16),
          Text(
            'Nenhuma viagem encontrada para esta rota e data.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey[700],
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
