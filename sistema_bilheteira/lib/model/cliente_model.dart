//import 'dart:ffi';

class Cliente {
  int? id;
  final String nome;
  final String email;
  final String telefone;

  Cliente({
    this.id,
    required this.nome,
    required this.email,
    required this.telefone
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': nome,
      'email': email,
      'telefone': telefone
    };
  }

  @override
  String toString() {
    return 'Cliente{id: $id,  name: $nome, email: $email, telefone: $telefone}';
    //
  }
}
