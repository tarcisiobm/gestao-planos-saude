class Cliente {
  int? id;
  String nome;
  String cpf;
  String telefone;
  String email;
  String rua;
  String numero;
  String complemento;
  String bairro;
  String cidade;
  String estado;
  String cep;

  Cliente({
    this.id,
    this.nome = '',
    this.cpf = '',
    this.telefone = '',
    this.email = '',
    this.rua = '',
    this.numero = '',
    this.complemento = '',
    this.bairro = '',
    this.cidade = '',
    this.estado = '',
    this.cep = '',
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'nome': nome,
    'cpf': cpf,
    'telefone': telefone,
    'email': email,
    'rua': rua,
    'numero': numero,
    'complemento': complemento,
    'bairro': bairro,
    'cidade': cidade,
    'estado': estado,
    'cep': cep,
  };

  static Cliente fromMap(Map<String, dynamic> map) => Cliente(
    id: map['id'] as int?,
    nome: map['nome'] ?? '',
    cpf: map['cpf'] ?? '',
    telefone: map['telefone'] ?? '',
    email: map['email'] ?? '',
    rua: map['rua'] ?? '',
    numero: map['numero'] ?? '',
    complemento: map['complemento'] ?? '',
    bairro: map['bairro'] ?? '',
    cidade: map['cidade'] ?? '',
    estado: map['estado'] ?? '',
    cep: map['cep'] ?? '',
  );
}
