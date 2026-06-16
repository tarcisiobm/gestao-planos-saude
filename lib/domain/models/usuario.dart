class Usuario {
  int? id;
  String nome;
  String email;
  String senha;

  Usuario({this.id, this.nome = '', this.email = '', this.senha = ''});

  Map<String, dynamic> toMap() => {
    'id': id,
    'nome': nome,
    'email': email,
    'senha': senha,
  };

  static Usuario fromMap(Map<String, dynamic> map) => Usuario(
    id: map['id'] as int?,
    nome: map['nome'] ?? '',
    email: map['email'] ?? '',
    senha: map['senha'] ?? '',
  );
}
