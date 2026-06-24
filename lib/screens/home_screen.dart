import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:porto_certo/data/viagem_mock_db.dart';
import 'package:porto_certo/models/passageiro.dart';
import 'package:porto_certo/models/viagem.dart';
import 'package:porto_certo/notifiers/auth_notifier.dart';
import 'package:porto_certo/services/api_service.dart';
import 'package:porto_certo/widgets/viagem_card.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const Color _navyBlue = Color(0xFF0D47A1);
  static const List<String> _cidades = [
    'Manaus',
    'Itacoatiara',
    'Parintins',
    'Juruti',
    'Santarém',
    'Manacapuru',
    'Coari',
    'Tefé',
    'Urucurituba',
  ];

  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _dateFormat = DateFormat('dd/MM/yyyy');
  List<Viagem> _viagens = ViagemMockDB.viagens;
  bool _carregandoViagens = false;

  String? _origem;
  String? _destino;
  DateTime? _dataIda;

  @override
  void initState() {
    super.initState();
    _carregarViagens();
  }

  Future<void> _carregarViagens() async {
    setState(() => _carregandoViagens = true);

    try {
      final viagens = await ApiService().listarViagens();
      if (!mounted) {
        return;
      }
      setState(() => _viagens = viagens);
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() => _viagens = ViagemMockDB.viagens);
    } finally {
      if (mounted) {
        setState(() => _carregandoViagens = false);
      }
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _selecionarDataIda() async {
    final hoje = DateTime.now();
    final dataSelecionada = await showDatePicker(
      context: context,
      initialDate: _dataIda ?? hoje,
      firstDate: DateTime(hoje.year, hoje.month, hoje.day),
      lastDate: DateTime(hoje.year + 2),
      helpText: 'Selecione a data de ida',
      cancelText: 'Cancelar',
      confirmText: 'Selecionar',
    );

    if (dataSelecionada == null || !mounted) {
      return;
    }

    setState(() {
      _dataIda = dataSelecionada;
      _dateController.text = _dateFormat.format(dataSelecionada);
    });
  }

  void _buscarViagens() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    context.go(
      Uri(
        path: '/viagens',
        queryParameters: {
          'origem': _origem,
          'destino': _destino,
          'data': _dateController.text,
        },
      ).toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final passageiro = context.watch<AuthNotifier>().passageiroLogado;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(title: const Text('Viagens fluviais')),
      drawer: _buildDrawer(context, passageiro),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Olá, ${passageiro?.nome ?? 'passageiro'}',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: _navyBlue,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Encontre sua próxima viagem pelos rios do Amazonas.',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 24),
                  Card(
                    elevation: 0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(28),
                      child: Form(
                        key: _formKey,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final isWide = constraints.maxWidth >= 640;
                            final origemField = _buildCidadeDropdown(
                              label: 'Origem',
                              value: _origem,
                              onChanged: (value) {
                                setState(() => _origem = value);
                                if (_destino != null) {
                                  _formKey.currentState?.validate();
                                }
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Selecione a origem';
                                }
                                if (value == _destino) {
                                  return 'Origem e destino devem diferir';
                                }
                                return null;
                              },
                            );
                            final destinoField = _buildCidadeDropdown(
                              label: 'Destino',
                              value: _destino,
                              onChanged: (value) {
                                setState(() => _destino = value);
                                if (_origem != null) {
                                  _formKey.currentState?.validate();
                                }
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Selecione o destino';
                                }
                                if (value == _origem) {
                                  return 'Destino deve diferir da origem';
                                }
                                return null;
                              },
                            );

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'Buscar viagens',
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(
                                        color: _navyBlue,
                                        fontWeight: FontWeight.w800,
                                      ),
                                ),
                                const SizedBox(height: 20),
                                if (isWide)
                                  Row(
                                    children: [
                                      Expanded(child: origemField),
                                      const SizedBox(width: 16),
                                      Expanded(child: destinoField),
                                    ],
                                  )
                                else
                                  Column(
                                    children: [
                                      origemField,
                                      const SizedBox(height: 16),
                                      destinoField,
                                    ],
                                  ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  key: const Key('departure_date_field'),
                                  controller: _dateController,
                                  readOnly: true,
                                  onTap: _selecionarDataIda,
                                  decoration: const InputDecoration(
                                    labelText: 'Data de ida',
                                    hintText: 'DD/MM/AAAA',
                                    prefixIcon: Icon(Icons.calendar_today),
                                  ),
                                  validator: (value) {
                                    if ((value ?? '').isEmpty) {
                                      return 'Selecione a data de ida';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 24),
                                ElevatedButton(
                                  key: const Key('search_trips_button'),
                                  onPressed: _buscarViagens,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _navyBlue,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    textStyle: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text('Buscar Viagens'),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Próximas Saídas',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: _navyBlue,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_carregandoViagens)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else
                    _buildViagensDisponiveis(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, Passageiro? passageiro) {
    final nome = passageiro?.nome ?? 'Passageiro';
    final email = passageiro?.email ?? 'email@exemplo.com';

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: _navyBlue),
            accountName: Text(
              nome,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            accountEmail: Text(email),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                _obterIniciais(nome),
                style: const TextStyle(
                  color: _navyBlue,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Meu Perfil'),
            onTap: () {
              Navigator.of(context).pop();
              context.go('/perfil');
            },
          ),
          ListTile(
            leading: const Icon(Icons.directions_boat),
            title: const Text('Minhas Viagens'),
            onTap: () => _mostrarEmBreve('Em breve: Histórico de passagens'),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configurações'),
            onTap: () => _mostrarEmBreve('Em breve: Configurações'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Sair', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.of(context).pop();
              context.read<AuthNotifier>().logout();
              context.go('/login');
            },
          ),
        ],
      ),
    );
  }

  String _obterIniciais(String nome) {
    final partes = nome
        .trim()
        .split(RegExp(r'\s+'))
        .where((parte) => parte.isNotEmpty)
        .toList();

    if (partes.isEmpty) {
      return 'P';
    }

    final primeira = partes.first.characters.first;
    final ultima = partes.length > 1 ? partes.last.characters.first : '';
    return '$primeira$ultima'.toUpperCase();
  }

  void _mostrarEmBreve(String mensagem) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem), behavior: SnackBarBehavior.floating),
    );
  }

  Widget _buildViagensDisponiveis(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 16.0;
        final maxWidth = constraints.maxWidth;
        final columns = maxWidth >= 960 ? 3 : (maxWidth >= 640 ? 2 : 1);
        final cardWidth = (maxWidth - (spacing * (columns - 1))) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: _viagens.map((viagem) {
            return SizedBox(
              width: cardWidth,
              child: ViagemCard(
                viagem: viagem,
                onVerDetalhes: () => _abrirDetalhesViagem(viagem),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  void _abrirDetalhesViagem(Viagem viagem) {
    context.go('/viagens/${viagem.idViagem}');
  }

  DropdownButtonFormField<String> _buildCidadeDropdown({
    required String label,
    required String? value,
    required ValueChanged<String?> onChanged,
    required FormFieldValidator<String> validator,
  }) {
    return DropdownButtonFormField<String>(
      key: Key('${label.toLowerCase()}_dropdown'),
      initialValue: value,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.location_on),
      ),
      items: _cidades.map((cidade) {
        return DropdownMenuItem<String>(value: cidade, child: Text(cidade));
      }).toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }
}
