import 'package:flutter/material.dart';
import '../screens/subscription_page.dart';
import 'login.dart';

class SettingsPage extends StatelessWidget {
  final String userId; // Add userId parameter

  const SettingsPage(
      {super.key, required this.userId}); // Receive userId in constructor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(color: Colors.orange)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Seção de Descrição do Plano
            _buildButton(
              context,
              label: 'Subscription Plan',
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SubscriptionPage(
                        userId: userId), // Pass the userId to SubscriptionPage
                  ),
                );
                if (result != null) {}
              },
            ),

            // // Seção de Idioma
            // _buildButton(
            //   context,
            //   label: 'Language',
            //   onPressed: () {
            //     // Ação para alterar o idioma
            //   },
            // ),

            // Seção de Tema
            _buildButton(
              context,
              label: 'Theme',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Choose the theme:',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        const Color.fromARGB(255, 95, 129, 189),
                                  ),
                            ),
                            SizedBox(height: 20),
                            ListTile(
                              tileColor: Colors.blue[50],
                              title: Text(
                                'Light',
                                style: TextStyle(fontSize: 16),
                              ),
                              onTap: () {
                                // Ação para alterar para tema Claro
                                Navigator.pop(context); // Fecha a janela
                              },
                            ),
                            ListTile(
                              tileColor: Colors.blue[50],
                              title: Text(
                                'Dark',
                                style: TextStyle(fontSize: 16),
                              ),
                              onTap: () {
                                // Ação para alterar para tema Escuro
                                Navigator.pop(context); // Fecha a janela
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),

            // Seção de Dúvidas Frequentes
            _buildButton(
              context,
              label: 'FAQs',
              onPressed: () {
                // Ação para alterar o tema
              },
            ),

            // Seção de Contato
            _buildButton(
              context,
              label: 'Contact us',
              onPressed: () {
                // Ação de contato
              },
            ),

            // Seção de Termos de Uso e Política de Privacidade
            _buildExpansionButton(
              context,
              label: 'Terms of Use - Privacy Policy',
              children: [
                _buildButton(
                  context,
                  label: 'Read the Terms of Use',
                  onPressed: () {
                    // Ação para abrir os termos de uso
                  },
                ),
                _buildButton(
                  context,
                  label: 'Read the Privacy Policy',
                  onPressed: () {
                    // Ação para abrir a política de privacidade
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Função para criar botões simples
  Widget _buildButton(BuildContext context,
      {required String label, required VoidCallback onPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(label),
      ),
    );
  }

  // Função para criar botões que podem expandir
  Widget _buildExpansionButton(BuildContext context,
      {required String label, required List<Widget> children}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ExpansionTile(
        title: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Text(label),
        ),
        children: children,
      ),
    );
  }
}
