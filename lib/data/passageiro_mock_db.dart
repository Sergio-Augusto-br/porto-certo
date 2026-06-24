import 'package:porto_certo/models/passageiro.dart';

class PassageiroMockDB {
  PassageiroMockDB({List<Passageiro>? passageiros})
    : tabelaPassageiros = List<Passageiro>.of(
        passageiros ?? _passageirosIniciais,
      );

  final List<Passageiro> tabelaPassageiros;

  Passageiro? buscarPorEmail(String email) {
    final emailNormalizado = email.trim().toLowerCase();

    for (final passageiro in tabelaPassageiros) {
      if (passageiro.email.toLowerCase() == emailNormalizado) {
        return passageiro;
      }
    }

    return null;
  }

  bool emailJaCadastrado(String email) {
    return buscarPorEmail(email) != null;
  }

  bool cpfJaCadastrado(String cpf) {
    final cpfNormalizado = cpf.trim();

    for (final passageiro in tabelaPassageiros) {
      if (passageiro.cpf == cpfNormalizado) {
        return true;
      }
    }

    return false;
  }

  Passageiro? cadastrar({
    required String nome,
    required String email,
    required String telefone,
    required String cpf,
    required String senha,
  }) {
    if (emailJaCadastrado(email) || cpfJaCadastrado(cpf)) {
      return null;
    }

    final passageiro = Passageiro(
      idPassageiro: _proximoId(),
      nome: nome.trim(),
      email: email.trim().toLowerCase(),
      telefone: telefone.trim(),
      cpf: cpf.trim(),
      senha: senha,
    );

    tabelaPassageiros.add(passageiro);
    return passageiro;
  }

  Passageiro? atualizar(Passageiro passageiroAtualizado) {
    final index = tabelaPassageiros.indexWhere(
      (passageiro) =>
          passageiro.idPassageiro == passageiroAtualizado.idPassageiro,
    );

    if (index == -1) {
      return null;
    }

    tabelaPassageiros[index] = passageiroAtualizado;
    return passageiroAtualizado;
  }

  int _proximoId() {
    if (tabelaPassageiros.isEmpty) {
      return 1;
    }

    var maiorId = tabelaPassageiros.first.idPassageiro;
    for (final passageiro in tabelaPassageiros) {
      if (passageiro.idPassageiro > maiorId) {
        maiorId = passageiro.idPassageiro;
      }
    }

    return maiorId + 1;
  }

  static const List<Passageiro> _passageirosIniciais = [
    Passageiro(
      idPassageiro: 1,
      nome: 'Ana Beatriz Costa',
      email: 'ana.costa@email.com',
      telefone: '(92) 99999-1001',
      cpf: '123.456.789-10',
      senha: 'senha123',
    ),
    Passageiro(
      idPassageiro: 2,
      nome: 'Marcos Lima',
      email: 'marcos.lima@email.com',
      telefone: '(92) 99999-2002',
      cpf: '987.654.321-00',
      senha: 'porto456',
    ),
  ];
}
