class Cliente {
  int? id;
  String nome;
  String cpf;
  String telefone;
  String email;
  String endereco;

  Cliente({
    this.id,
    this.nome = '',
    this.cpf = '',
    this.telefone = '',
    this.email = '',
    this.endereco = '',
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'nome': nome,
    'cpf': cpf,
    'telefone': telefone,
    'email': email,
    'endereco': endereco,
  };

  static Cliente fromMap(Map<String, dynamic> map) => Cliente(
    id: map['id'] as int?,
    nome: map['nome'] ?? '',
    cpf: map['cpf'] ?? '',
    telefone: map['telefone'] ?? '',
    email: map['email'] ?? '',
    endereco: map['endereco'] ?? '',
  );
}
