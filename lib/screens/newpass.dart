import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Newpass(),
  ));
}

class Newpass extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Volta para a tela anterior
          },
        ),
        centerTitle: true,
        title: Text(
          'Forgot password',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        // Centraliza o conteúdo verticalmente
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Ajusta o tamanho para centralizar
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Campo de email
              TextField(
                decoration: InputDecoration(
                  labelText: 'Enter your email',
                  prefixIcon: Icon(Icons.email_outlined,
                      color: Colors.orange), // Ícone de e-mail
                  border: UnderlineInputBorder(),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                ),
              ),
              SizedBox(height: 30),
              // Botão de reset password
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "");
                    // Ação ao clicar em resetar senha
                    // falta adicionar o caminho para onde vai o reset password
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue,
                  ),
                  child: Text('Reset password'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
