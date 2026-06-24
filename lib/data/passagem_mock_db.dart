import 'package:porto_certo/models/passagem.dart';

class PassagemMockDB {
  const PassagemMockDB();

  static final List<Passagem> passagensRegistradas = [];

  static void registrarPassagem(Passagem novaPassagem) {
    passagensRegistradas.add(novaPassagem);
  }
}
