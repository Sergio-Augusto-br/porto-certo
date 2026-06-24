class Passageiro {
  const Passageiro({
    required this.idPassageiro,
    required this.nome,
    required this.email,
    required this.telefone,
    required this.cpf,
    required this.senha,
  });

  final int idPassageiro;
  final String nome;
  final String email;
  final String telefone;
  final String cpf;
  final String senha;

  Passageiro copyWith({
    String? nome,
    String? email,
    String? telefone,
    String? cpf,
    String? senha,
  }) {
    return Passageiro(
      idPassageiro: idPassageiro,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      telefone: telefone ?? this.telefone,
      cpf: cpf ?? this.cpf,
      senha: senha ?? this.senha,
    );
  }

  factory Passageiro.fromJson(Map<String, dynamic> json) {
    return Passageiro(
      idPassageiro: (json['idPassageiro'] ?? json['id_passageiro']) as int,
      nome: json['nome'] as String,
      email: json['email'] as String,
      telefone: json['telefone'] as String,
      cpf: json['cpf'] as String,
      senha: (json['senha'] ?? '') as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idPassageiro': idPassageiro,
      'nome': nome,
      'email': email,
      'telefone': telefone,
      'cpf': cpf,
      'senha': senha,
    };
  }
}
