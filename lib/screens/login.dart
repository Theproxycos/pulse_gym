import 'package:flutter/material.dart';
import 'package:pulse_gym/screens/register_page.dart';

void main() {
  runApp(MaterialApp(
    home: Login(),
  ));
}

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove a seta de voltar
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  // Imagem do título
                  Image.asset(
                    'lib/assets/logo.png', // Substitua pelo caminho da sua imagem
                    height: 80,
                  ),
                ],
              ),
              const SizedBox(height: 30),
              // Campo Username
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.person_outline, color: Colors.orange),
                  border: UnderlineInputBorder(),
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
                  prefixIcon: Icon(Icons.lock_outline, color: Colors.orange),
                  border: UnderlineInputBorder(),
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
                      // Checkbox estilizado
                      Checkbox(
                        value: false,
                        onChanged: (value) {},
                        side:
                            const BorderSide(color: Colors.orange, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const Text('Remember me'),
                    ],
                  ),
                  // Esquecer senha
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/newpass");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ForgotPasswordPage()),
                      );
                    },
                    child: const Text(
                      'Forgot password?',
                      style: TextStyle(color: Colors.orange),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              // Botão de login
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/homepage');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue,
                  ),
                  child: const Text(
                    'Log in',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Botão para registro
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(color: Colors.black),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => RegisterPage()),
                      );
                    },
                    child: const Text(
                      "Register!",
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: const Text(
          'Forgot password',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Enter your email',
                  prefixIcon: Icon(Icons.email_outlined, color: Colors.orange),
                  border: UnderlineInputBorder(),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Ação ao resetar senha
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue,
                  ),
                  child: const Text('Reset password'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
