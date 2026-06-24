import 'package:flutter_test/flutter_test.dart';
import 'package:porto_certo/data/passageiro_mock_db.dart';
import 'package:porto_certo/models/passageiro.dart';

void main() {
  group('PassageiroMockDB', () {
    test('retorna passageiro quando email existe', () {
      // Arrange
      final db = PassageiroMockDB(
        passageiros: const [
          Passageiro(
            idPassageiro: 1,
            nome: 'Ana Costa',
            email: 'ana@email.com',
            telefone: '(92) 99999-0000',
            cpf: '123.456.789-10',
            senha: 'senha123',
          ),
        ],
      );

      // Act
      final passageiro = db.buscarPorEmail('ana@email.com');

      // Assert
      expect(passageiro, isNotNull);
      expect(passageiro?.nome, 'Ana Costa');
    });

    test('normaliza email antes da busca', () {
      // Arrange
      final db = PassageiroMockDB(
        passageiros: const [
          Passageiro(
            idPassageiro: 1,
            nome: 'Marcos Lima',
            email: 'marcos@email.com',
            telefone: '(92) 99999-1111',
            cpf: '987.654.321-00',
            senha: 'porto456',
          ),
        ],
      );

      // Act
      final passageiro = db.buscarPorEmail('  MARCOS@EMAIL.COM  ');

      // Assert
      expect(passageiro, isNotNull);
      expect(passageiro?.idPassageiro, 1);
    });

    test('retorna null quando email nao existe', () {
      // Arrange
      final db = PassageiroMockDB(passageiros: const []);

      // Act
      final passageiro = db.buscarPorEmail('nao-existe@email.com');

      // Assert
      expect(passageiro, isNull);
    });
  });
}
