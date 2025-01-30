import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore.dart';

class NovaSenha extends StatefulWidget {
  // Remoção do parâmetro userId aqui, pois ele será recebido via argumentos
  NovaSenha({Key? key}) : super(key: key);

  @override
  _NovaSenhaState createState() => _NovaSenhaState();
}

class _NovaSenhaState extends State<NovaSenha> {
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController _novaSenhaController = TextEditingController();
  final TextEditingController _confirmeSenhaController =
      TextEditingController();
  bool _novaSenhaVisivel = false;
  bool _confirmeSenhaVisivel = false;
  String? _senhaAtual;

  late String userId; // Variável para armazenar o userId

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Recupera o userId passado via argumentos
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && args.containsKey('userId')) {
      userId = args['userId'];
      print("UserId recebido: $userId");
      _loadCurrentPassword(); // Carrega a senha atual após pegar o userId
    }
  }

  void _loadCurrentPassword() async {
    final userData = await _firestoreService.getUserData(userId);
    if (userData != null) {
      setState(() {
        _senhaAtual = userData['password'] ?? '';
      });
      print('Senha atual: $_senhaAtual'); // Para depuração
    }
  }

  void _updatePassword() async {
    String novaSenha = _novaSenhaController.text;
    String confirmeSenha = _confirmeSenhaController.text;

    if (novaSenha.isEmpty || confirmeSenha.isEmpty) {
      _showMessage('Os campos de senha não podem estar vazios.');
      return;
    }

    if (novaSenha != confirmeSenha) {
      _showMessage('As senhas não coincidem.');
      return;
    }

    // Atualizar a senha no Firestore
    await _firestoreService.updateUserData(userId, {
      'password': novaSenha,
    });

    _showMessage('Senha alterada com sucesso!', isSuccess: true);
  }

  void _showMessage(String message, {bool isSuccess = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password',
            style: TextStyle(color: Colors.orange)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushNamed(context, '/homepage');
            }
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            const Text('New Password'),
            const SizedBox(height: 8),
            TextField(
              controller: _novaSenhaController,
              obscureText: !_novaSenhaVisivel,
              decoration: InputDecoration(
                hintText: 'New Password',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _novaSenhaVisivel ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _novaSenhaVisivel = !_novaSenhaVisivel;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Confirm New Password'),
            const SizedBox(height: 8),
            TextField(
              controller: _confirmeSenhaController,
              obscureText: !_confirmeSenhaVisivel,
              decoration: InputDecoration(
                hintText: 'Confirm New Password',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _confirmeSenhaVisivel
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _confirmeSenhaVisivel = !_confirmeSenhaVisivel;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: _updatePassword,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.orange),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 24.0),
                      ),
                      child: const Text(
                        'Change Password',
                        style: TextStyle(
                            color: Colors.orange,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.grey),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 24.0),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
