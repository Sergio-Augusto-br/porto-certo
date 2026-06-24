import 'package:flutter_test/flutter_test.dart';
import 'package:porto_certo/models/passageiro.dart';

void main() {
  group('Passageiro', () {
    test('cria instancia a partir de JSON', () {
      // Arrange
      final json = {
        'idPassageiro': 10,
        'nome': 'Carla Souza',
        'email': 'carla@email.com',
        'telefone': '(92) 98888-7777',
        'cpf': '111.222.333-44',
        'senha': 'minhaSenha',
      };

      // Act
      final passageiro = Passageiro.fromJson(json);

      // Assert
      expect(passageiro.idPassageiro, 10);
      expect(passageiro.nome, 'Carla Souza');
      expect(passageiro.email, 'carla@email.com');
      expect(passageiro.telefone, '(92) 98888-7777');
      expect(passageiro.cpf, '111.222.333-44');
      expect(passageiro.senha, 'minhaSenha');
    });

    test('converte instancia para JSON', () {
      // Arrange
      const passageiro = Passageiro(
        idPassageiro: 20,
        nome: 'Diego Santos',
        email: 'diego@email.com',
        telefone: '(92) 97777-6666',
        cpf: '555.666.777-88',
        senha: 'portoSeguro',
      );

      // Act
      final json = passageiro.toJson();

      // Assert
      expect(json, {
        'idPassageiro': 20,
        'nome': 'Diego Santos',
        'email': 'diego@email.com',
        'telefone': '(92) 97777-6666',
        'cpf': '555.666.777-88',
        'senha': 'portoSeguro',
      });
    });
  });
}
