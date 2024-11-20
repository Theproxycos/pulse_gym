import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: LoginPage(),
  ));
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Ação ao voltar
          },
        ),
        centerTitle: true, // Centraliza o título
        title: const Text(
          'Log in',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            // Campo Username
            const TextField(
              decoration: InputDecoration(
                labelText: 'Username',
                prefixIcon: Icon(Icons.person_outline,
                    color: Colors.orange), // Ícone com borda fina
                border: UnderlineInputBorder(), // Apenas a linha inferior
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.orange),
                ),
              ),
            ),
            const SizedBox(height: 15),
            // Campo Password
            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock_outline,
                    color: Colors.orange), // Ícone com borda fina
                border: UnderlineInputBorder(), // Apenas a linha inferior
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.orange),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // Checkbox com borda fina e elegante
                    Checkbox(
                      value: false,
                      onChanged: (value) {},
                      side: const BorderSide(
                          color: Colors.orange,
                          width: 1.5), // Borda laranja fina
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            4), // Bordas levemente arredondadas
                      ),
                    ),
                    const Text('Remember me'),
                  ],
                ),
                // Esquecer senha
                TextButton(
                  onPressed: () {
                    // Ação ao esquecer senha
                  },
                  child: const Text(
                    'Forgot password?',
                    style: TextStyle(color: Colors.orange),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Botão de login
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Ação ao logar
                  Navigator.pushNamed(context, "/homepage");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                ),
                child: const Text('Log in'),
              ),
            ),
            const SizedBox(height: 20),
            // Botão para registro
            Center(
              child: TextButton(
                onPressed: () {
                  // Navegar para tela de registro
                },
                child: RichText(
                  text: const TextSpan(
                    text: "Don't have an account? ",
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: "Register!",
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
