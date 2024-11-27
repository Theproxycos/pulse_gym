import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Variável para armazenar o valor selecionado (Male ou Female)
  String _gender = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pushReplacementNamed('/login'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Register',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            // Username Field
            _buildTextField('Username', isRequired: true),
            SizedBox(height: 10),
            // Country and Phone Number Row
            Row(
              children: [
                Expanded(child: _buildDropdown('Country', isRequired: true)),
                SizedBox(width: 10),
                Expanded(
                  child: _buildTextField(
                    'Phone number',
                    isRequired: true,
                    keyboardType:
                        TextInputType.phone, // Garantir teclado numérico
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            // Email Field
            _buildTextField('Email', isRequired: true),
            SizedBox(height: 10),
            // Gender Selection
            Row(
              children: [
                Text(
                  'Gender',
                  style: TextStyle(fontSize: 14),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          contentPadding: EdgeInsets.only(
                              left: 5.0), // Menos espaço à esquerda
                          title: Text('Male', style: TextStyle(fontSize: 14)),
                          leading: Radio(
                            value: 'Male',
                            groupValue: _gender,
                            onChanged: (value) {
                              setState(() {
                                _gender = value!;
                              });
                            },
                            activeColor: Colors.orange,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          contentPadding: EdgeInsets.only(
                              left: 5.0), // Menos espaço à esquerda
                          title: Text('Female', style: TextStyle(fontSize: 14)),
                          leading: Radio(
                            value: 'Female',
                            groupValue: _gender,
                            onChanged: (value) {
                              setState(() {
                                _gender = value!;
                              });
                            },
                            activeColor: Colors.orange,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 10),
            // Date of Birth Field
            _buildDatePickerField('Date of birth'),
            SizedBox(height: 10),
            // Password and Re-enter Password Fields
            _buildTextField('Password', isPassword: true),
            SizedBox(height: 10),
            _buildTextField('Re-enter Password', isPassword: true),
            SizedBox(height: 10),
            // Address Field
            _buildTextField('Address'),
            SizedBox(height: 10),
            // Location Dropdown
            _buildDropdown('Location'),
            SizedBox(height: 20),
            // Register Button
            Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Register',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label,
      {bool isPassword = false,
      bool isRequired = false,
      TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      obscureText: isPassword,
      keyboardType:
          keyboardType, // Aqui está o parâmetro para definir o tipo de teclado
      decoration: InputDecoration(
        labelText: label + (isRequired ? ' *' : ''),
        labelStyle: TextStyle(fontSize: 14), // Reduzir tamanho da fonte
        contentPadding: EdgeInsets.symmetric(
            vertical: 8, horizontal: 10), // Reduzir padding
        border: UnderlineInputBorder(),
      ),
    );
  }

  Widget _buildDropdown(String label, {bool isRequired = false}) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label + (isRequired ? ' *' : ''),
        labelStyle: TextStyle(fontSize: 14), // Reduzir tamanho da fonte
        contentPadding: EdgeInsets.symmetric(
            vertical: 8, horizontal: 10), // Reduzir padding
        border: UnderlineInputBorder(),
      ),
      iconEnabledColor:
          Colors.orange, // Define a cor da seta (ícone) para laranja
      items: [
        DropdownMenuItem(child: Text('Option 1'), value: 'Option 1'),
        DropdownMenuItem(child: Text('Option 2'), value: 'Option 2'),
      ],
      onChanged: (value) {},
    );
  }

  Widget _buildDatePickerField(String label) {
    return TextField(
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: 14), // Reduzir tamanho da fonte
        contentPadding: EdgeInsets.symmetric(
            vertical: 6, horizontal: 10), // Reduzir padding
        border: OutlineInputBorder(),
        suffixIcon: Icon(
          Icons.calendar_today,
          color: Colors.orange,
        ),
      ),
      onTap: () {
        // Implementar funcionalidade do seletor de data
      },
    );
  }
}
