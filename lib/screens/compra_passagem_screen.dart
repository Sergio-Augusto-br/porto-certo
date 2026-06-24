import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:porto_certo/data/passagem_mock_db.dart';
import 'package:porto_certo/models/parada.dart';
import 'package:porto_certo/models/passagem.dart';
import 'package:porto_certo/models/viagem.dart';
import 'package:porto_certo/notifiers/auth_notifier.dart';
import 'package:porto_certo/services/api_service.dart';
import 'package:provider/provider.dart';

class CompraPassagemArgs {
  const CompraPassagemArgs({
    required this.viagem,
    required this.portoEmbarque,
    required this.portoDesembarque,
    required this.valorPassagem,
  });

  final Viagem viagem;
  final Parada portoEmbarque;
  final Parada portoDesembarque;
  final double valorPassagem;
}

class CompraPassagemScreen extends StatefulWidget {
  const CompraPassagemScreen({required this.args, super.key});

  final CompraPassagemArgs args;

  @override
  State<CompraPassagemScreen> createState() => _CompraPassagemScreenState();
}

class _CompraPassagemScreenState extends State<CompraPassagemScreen> {
  static const Color _navyBlue = Color(0xFF0D47A1);

  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _cpfController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _emailController = TextEditingController();

  final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: r'R$',
  );

  @override
  void initState() {
    super.initState();

    final passageiro = context.read<AuthNotifier>().passageiroLogado;
    _nomeController.text = passageiro?.nome ?? '';
    _cpfController.text = passageiro?.cpf ?? '';
    _telefoneController.text = passageiro?.telefone ?? '';
    _emailController.text = passageiro?.email ?? '';
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _cpfController.dispose();
    _telefoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _confirmarCompra() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    final passageiro = context.read<AuthNotifier>().passageiroLogado;
    if (passageiro == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Faça login novamente para concluir a compra.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final passagem = Passagem(
      idPassagem: DateTime.now().microsecondsSinceEpoch.toString(),
      idViagem: widget.args.viagem.idViagem.toString(),
      idPassageiro: passageiro.idPassageiro.toString(),
      idPortoEmbarque: widget.args.portoEmbarque.idParada,
      idPortoDesembarque: widget.args.portoDesembarque.idParada,
      valorTotal: widget.args.valorPassagem,
    );

    try {
      await ApiService().registrarPassagem(passagem);
    } catch (_) {
      PassagemMockDB.registrarPassagem(passagem);
    }

    if (!mounted) {
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 56),
              SizedBox(height: 12),
              Text('Compra confirmada'),
            ],
          ),
          content: const Text(
            'Obrigado pela compra. Seu bilhete foi gerado com sucesso.',
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.go('/home');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _navyBlue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Concluir'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = widget.args;
    final viagem = args.viagem;
    final embarcacao = viagem.embarcacao;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(title: const Text('Revisão e Pagamento')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildSectionTitle(context, 'Resumo da Viagem'),
                  const SizedBox(height: 10),
                  _buildTripSummaryCard(context, viagem, embarcacao.nomeE),
                  const SizedBox(height: 22),
                  _buildSectionTitle(context, 'Dados do Passageiro'),
                  const SizedBox(height: 10),
                  _buildPassengerFormCard(),
                  const SizedBox(height: 22),
                  _buildFinancialSummaryCard(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTripSummaryCard(
    BuildContext context,
    Viagem viagem,
    String nomeEmbarcacao,
  ) {
    return Card(
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
              nomeEmbarcacao,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: _navyBlue,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              viagem.nomeRota,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: Colors.grey[700]),
            ),
            const SizedBox(height: 18),
            _buildSummaryLine(
              icon: Icons.sailing,
              label: 'Origem',
              value:
                  '${widget.args.portoEmbarque.nomePorto} - ${widget.args.portoEmbarque.horarioSaida}',
            ),
            const SizedBox(height: 12),
            _buildSummaryLine(
              icon: Icons.flag,
              label: 'Destino',
              value:
                  '${widget.args.portoDesembarque.nomePorto} - ${widget.args.portoDesembarque.horarioChegada}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPassengerFormCard() {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Nome completo',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if ((value ?? '').trim().isEmpty) {
                    return 'Informe o nome do passageiro';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cpfController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'CPF',
                  prefixIcon: Icon(Icons.badge),
                ),
                validator: (value) {
                  if ((value ?? '').trim().isEmpty) {
                    return 'Informe o CPF do passageiro';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _telefoneController,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Telefone',
                  prefixIcon: Icon(Icons.phone),
                ),
                validator: (value) {
                  if ((value ?? '').trim().isEmpty) {
                    return 'Informe o telefone';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) {
                  final email = (value ?? '').trim();
                  if (email.isEmpty) {
                    return 'Informe o email';
                  }
                  if (!email.contains('@')) {
                    return 'Informe um email valido';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFinancialSummaryCard(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Valor Total',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  _currencyFormat.format(widget.args.valorPassagem),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: _navyBlue,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _confirmarCompra,
              style: ElevatedButton.styleFrom(
                backgroundColor: _navyBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
              ),
              child: const Text('Confirmar Compra Simulada'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        color: _navyBlue,
        fontWeight: FontWeight.w900,
      ),
    );
  }

  Widget _buildSummaryLine({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: _navyBlue, size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: Colors.grey[800]),
              children: [
                TextSpan(
                  text: '$label: ',
                  style: const TextStyle(fontWeight: FontWeight.w900),
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
