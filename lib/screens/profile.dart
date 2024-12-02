import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Seção de Descrição do Plano
            _buildButton(
              context,
              label: 'Plan Description',
              onPressed: () {
                // Ação para abrir a descrição do plano
              },
            ),

            // Seção de Idioma
            _buildButton(
              context,
              label: 'Idioma: Português',
              onPressed: () {
                // Ação para alterar o idioma
              },
            ),

            // Seção de Tema
            _buildButton(
              context,
              label: 'Tema: Claro',
              onPressed: () {
                // Ação para alterar o tema
              },
            ),

            // Seção de Dúvidas Frequentes
            _buildExpansionButton(
              context,
              label: 'Dúvidas Frequentes',
              children: [
                _buildButton(
                  context,
                  label: 'Pergunta 1: Como usar o app?',
                  onPressed: () {
                    // Ação para mostrar resposta
                  },
                ),
                _buildButton(
                  context,
                  label: 'Pergunta 2: Como mudar as configurações?',
                  onPressed: () {
                    // Ação para mostrar resposta
                  },
                ),
              ],
            ),

            // Seção de Contato
            _buildButton(
              context,
              label: 'Contato: contato@exemplo.com',
              onPressed: () {
                // Ação de contato
              },
            ),

            // Seção de Termos de Uso e Política de Privacidade
            _buildExpansionButton(
              context,
              label: 'Termos de Uso - Política de Privacidade',
              children: [
                _buildButton(
                  context,
                  label: 'Leia os Termos de Uso',
                  onPressed: () {
                    // Ação para abrir os termos de uso
                  },
                ),
                _buildButton(
                  context,
                  label: 'Leia a Política de Privacidade',
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
          padding: EdgeInsets.symmetric(vertical: 14),
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
            padding: EdgeInsets.symmetric(vertical: 14),
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
