import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  Navigator.pushNamed(context, '/homepage');
                }
              },
              child: Row(
                children: [
                  Icon(Icons.arrow_back, color: Colors.black),
                  SizedBox(width: 5),
                  Text(
                    'Voltar',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
            Stack(
              children: [
                Icon(Icons.notifications, color: Colors.black),
                Positioned(
                  right: 0,
                  child: CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 8,
                    child: Text(
                      '2',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Image.asset(
                'lib/assets/logo-nobg.png', // Caminho para o logo
                height: 80, // Altura ajustável
              ),
              SizedBox(height: 30), // Distância entre o logo e as opções
              Card(
                child: ListTile(
                  leading: Icon(Icons.person, size: 40, color: Colors.orange),
                  title: Text('Alterar foto'),
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
                  onTap: () {
                    // Navegar para alteração de foto
                  },
                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(Icons.badge, size: 40, color: Colors.orange),
                  title: Text('Nome, Email, Telefone'),
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
                  onTap: () {
                    Navigator.pushNamed(context, '/editprofile');
                  },
                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(Icons.lock, size: 40, color: Colors.orange),
                  title: Text('Atualizar senha'),
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
                  onTap: () {
                    // Navegar para atualização de senha
                  },
                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(Icons.language, size: 40, color: Colors.orange),
                  title: Text('Alterar idioma'),
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
                  onTap: () {
                    // Navegar para alteração de idioma
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
