// ignore_for_file: prefer_initializing_formals

import 'package:flutter/foundation.dart';
import 'package:porto_certo/data/passageiro_mock_db.dart';
import 'package:porto_certo/models/passageiro.dart';
import 'package:porto_certo/services/api_service.dart';

class AuthNotifier extends ChangeNotifier {
  AuthNotifier({
    PassageiroMockDB? passageiroDB,
    ApiService? apiService,
    this.authenticationDelay = const Duration(milliseconds: 450),
  }) : _passageiroDB = passageiroDB ?? PassageiroMockDB(),
       _apiService = apiService;

  final PassageiroMockDB _passageiroDB;
  final ApiService? _apiService;
  final Duration authenticationDelay;

  bool _isLoggedIn = false;
  Passageiro? _passageiroLogado;

  bool get isLoggedIn => _isLoggedIn;
  Passageiro? get passageiroLogado => _passageiroLogado;

  Future<bool> cadastrar({
    required String nome,
    required String email,
    required String telefone,
    required String cpf,
    required String senha,
  }) async {
    if (authenticationDelay > Duration.zero) {
      await Future<void>.delayed(authenticationDelay);
    }

    final passageiro = await _cadastrarViaApiOuMock(
      nome: nome,
      email: email,
      telefone: telefone,
      cpf: cpf,
      senha: senha,
    );

    return passageiro != null;
  }

  Future<bool> login(String email, String senha) async {
    if (authenticationDelay > Duration.zero) {
      await Future<void>.delayed(authenticationDelay);
    }

    final passageiro = await _loginViaApiOuMock(email, senha);
    final credenciaisValidas = passageiro != null;

    if (!credenciaisValidas) {
      _isLoggedIn = false;
      _passageiroLogado = null;
      notifyListeners();
      return false;
    }

    _isLoggedIn = true;
    _passageiroLogado = passageiro;
    notifyListeners();
    return true;
  }

  Future<bool> atualizarPerfil({
    required String nome,
    required String email,
    required String telefone,
    required String senha,
  }) async {
    final passageiro = _passageiroLogado;
    if (passageiro == null) {
      return false;
    }

    final atualizado = await _atualizarPerfilViaApiOuMock(
      passageiro: passageiro,
      nome: nome,
      email: email,
      telefone: telefone,
      senha: senha,
    );
    if (atualizado == null) {
      return false;
    }

    _passageiroLogado = atualizado;
    notifyListeners();
    return true;
  }

  Future<Passageiro?> _loginViaApiOuMock(String email, String senha) async {
    final apiService = _apiService;
    if (apiService != null) {
      try {
        return await apiService.login(email: email, senha: senha);
      } catch (_) {
        // Mantem o app utilizavel durante desenvolvimento caso a API esteja off.
      }
    }

    final passageiro = _passageiroDB.buscarPorEmail(email);
    if (passageiro == null || passageiro.senha != senha) {
      return null;
    }
    return passageiro;
  }

  Future<Passageiro?> _cadastrarViaApiOuMock({
    required String nome,
    required String email,
    required String telefone,
    required String cpf,
    required String senha,
  }) async {
    final apiService = _apiService;
    if (apiService != null) {
      try {
        return await apiService.cadastrar(
          nome: nome,
          email: email,
          telefone: telefone,
          cpf: cpf,
          senha: senha,
        );
      } catch (_) {
        // Mantem compatibilidade com os mocks locais.
      }
    }

    return _passageiroDB.cadastrar(
      nome: nome,
      email: email,
      telefone: telefone,
      cpf: cpf,
      senha: senha,
    );
  }

  Future<Passageiro?> _atualizarPerfilViaApiOuMock({
    required Passageiro passageiro,
    required String nome,
    required String email,
    required String telefone,
    required String senha,
  }) async {
    final apiService = _apiService;
    if (apiService != null) {
      try {
        return await apiService.atualizarPassageiro(
          passageiro: passageiro,
          nome: nome,
          email: email,
          telefone: telefone,
          senha: senha,
        );
      } catch (_) {
        // Mantem compatibilidade com os mocks locais.
      }
    }

    final passageiroAtualizado = passageiro.copyWith(
      nome: nome.trim(),
      email: email.trim().toLowerCase(),
      telefone: telefone.trim(),
      senha: senha,
    );
    return _passageiroDB.atualizar(passageiroAtualizado);
  }

  void logout() {
    _isLoggedIn = false;
    _passageiroLogado = null;
    notifyListeners();
  }
}
