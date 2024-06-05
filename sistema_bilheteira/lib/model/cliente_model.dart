
//import 'dart:ffi';

class Cliente {
  final int? id;
  final String nome;
  final String email;
  //final String telefone;



  Cliente(
    // 
    // required this.telefone
    {
     this.id,
    required this.nome,
    required this.email,
   }
  );

    Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': nome,
      'email': email,
     // 'telefone': telefone
    };
  }

   @override
  String toString() {
    return 'Cliente{id: $id,  name: $nome, email: $email}';
    //
  }
}










