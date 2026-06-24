import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:porto_certo/config/api_config.dart';
import 'package:porto_certo/models/passagem.dart';
import 'package:porto_certo/models/passageiro.dart';
import 'package:porto_certo/models/viagem.dart';

class ApiService {
  ApiService({http.Client? client, String? baseUrl})
    : _client = client ?? http.Client(),
      _baseUrl = baseUrl ?? ApiConfig.baseUrl;

  final http.Client _client;
  final String _baseUrl;

  Future<Passageiro?> login({
    required String email,
    required String senha,
  }) async {
    final response = await _post('/auth/login', {
      'email': email,
      'senha': senha,
    });

    if (response.statusCode == 401) {
      return null;
    }

    _ensureSuccess(response);
    final body = _decode(response);
    return Passageiro.fromJson(body['passageiro'] as Map<String, dynamic>);
  }

  Future<Passageiro?> cadastrar({
    required String nome,
    required String email,
    required String telefone,
    required String cpf,
    required String senha,
  }) async {
    final response = await _post('/passageiros', {
      'nome': nome,
      'email': email,
      'telefone': telefone,
      'cpf': cpf,
      'senha': senha,
    });

    if (response.statusCode == 409) {
      return null;
    }

    _ensureSuccess(response);
    return Passageiro.fromJson(_decode(response) as Map<String, dynamic>);
  }

  Future<Passageiro> atualizarPassageiro({
    required Passageiro passageiro,
    required String nome,
    required String email,
    required String telefone,
    required String senha,
  }) async {
    final response = await _put('/passageiros/${passageiro.idPassageiro}', {
      'nome': nome,
      'email': email,
      'telefone': telefone,
      'senha': senha,
    });

    _ensureSuccess(response);
    return Passageiro.fromJson(_decode(response) as Map<String, dynamic>);
  }

  Future<List<Viagem>> listarViagens() async {
    final response = await _client.get(_uri('/viagens'));
    _ensureSuccess(response);
    return (_decode(response) as List<dynamic>)
        .map((item) => Viagem.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Viagem?> buscarViagemPorId(int id) async {
    final response = await _client.get(_uri('/viagens/$id'));
    if (response.statusCode == 404) {
      return null;
    }

    _ensureSuccess(response);
    return Viagem.fromJson(_decode(response) as Map<String, dynamic>);
  }

  Future<List<Viagem>> buscarViagens({
    required String origem,
    required String destino,
    required String dataBusca,
  }) async {
    final response = await _client.get(
      _uri('/viagens/buscar', {
        'origem': origem,
        'destino': destino,
        'data': dataBusca,
      }),
    );

    _ensureSuccess(response);
    return (_decode(response) as List<dynamic>)
        .map((item) => Viagem.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Passagem> registrarPassagem(Passagem passagem) async {
    final response = await _post('/passagens', passagem.toJson());
    _ensureSuccess(response);
    return Passagem.fromJson(_decode(response) as Map<String, dynamic>);
  }

  Uri _uri(String path, [Map<String, String>? queryParameters]) {
    return Uri.parse(
      '$_baseUrl$path',
    ).replace(queryParameters: queryParameters);
  }

  Future<http.Response> _post(String path, Map<String, dynamic> body) {
    return _client.post(
      _uri(path),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
  }

  Future<http.Response> _put(String path, Map<String, dynamic> body) {
    return _client.put(
      _uri(path),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
  }

  dynamic _decode(http.Response response) {
    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  void _ensureSuccess(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Erro na API: ${response.statusCode} ${response.body}');
    }
  }
}
