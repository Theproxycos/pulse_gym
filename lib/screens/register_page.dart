import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Para formatar a data

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Variável para armazenar o valor selecionado (Male ou Female)
  String _gender = '';

  // Controlador para o campo de texto da data de nascimento
  final TextEditingController _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pushReplacementNamed('/login'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Register',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            // Username Field
            _buildTextField('Username', isRequired: true),
            const SizedBox(height: 10),
            // Country and Phone Number Row
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    'Phone number',
                    isRequired: true,
                    keyboardType: TextInputType.phone,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Email Field
            _buildTextField('Email', isRequired: true),
            const SizedBox(height: 10),
            // Gender Selection
            Row(
              children: [
                const Text(
                  'Gender',
                  style: TextStyle(fontSize: 14),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          contentPadding: const EdgeInsets.only(left: 5.0),
                          title: const Text('Male',
                              style: TextStyle(fontSize: 14)),
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
                          contentPadding: const EdgeInsets.only(left: 5.0),
                          title: const Text('Female',
                              style: TextStyle(fontSize: 14)),
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
            const SizedBox(height: 10),
            // Date of Birth Field
            _buildDatePickerField('Date of birth'),
            const SizedBox(height: 10),
            // Password and Re-enter Password Fields
            _buildTextField('Password', isPassword: true),
            const SizedBox(height: 10),
            _buildTextField('Re-enter Password', isPassword: true),
            const SizedBox(height: 10),
            // Address Field
            _buildTextField('Address'),
            const SizedBox(height: 10),
            // Location Dropdown
            _buildDropdown('Country'),
            const SizedBox(height: 20),
            // Register Button
            Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
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
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label + (isRequired ? ' *' : ''),
        labelStyle: const TextStyle(fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        border: const UnderlineInputBorder(),
      ),
    );
  }

  Widget _buildDropdown(String label, {bool isRequired = false}) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label + (isRequired ? ' *' : ''),
        labelStyle: const TextStyle(fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        border: const UnderlineInputBorder(),
      ),
      iconEnabledColor: Colors.orange,
      items: const [
        DropdownMenuItem(value: 'Albania', child: Text('Albania')),
        DropdownMenuItem(value: 'Andorra', child: Text('Andorra')),
        DropdownMenuItem(value: 'Armenia', child: Text('Armenia')),
        DropdownMenuItem(value: 'Austria', child: Text('Austria')),
        DropdownMenuItem(value: 'Azerbaijan', child: Text('Azerbaijan')),
        DropdownMenuItem(value: 'Belarus', child: Text('Belarus')),
        DropdownMenuItem(value: 'Belgium', child: Text('Belgium')),
        DropdownMenuItem(
            value: 'Bosnia and Herzegovina',
            child: Text('Bosnia and Herzegovina')),
        DropdownMenuItem(value: 'Bulgaria', child: Text('Bulgaria')),
        DropdownMenuItem(value: 'Croatia', child: Text('Croatia')),
        DropdownMenuItem(value: 'Cyprus', child: Text('Cyprus')),
        DropdownMenuItem(
            value: 'Czech Republic', child: Text('Czech Republic')),
        DropdownMenuItem(value: 'Denmark', child: Text('Denmark')),
        DropdownMenuItem(value: 'Estonia', child: Text('Estonia')),
        DropdownMenuItem(value: 'Finland', child: Text('Finland')),
        DropdownMenuItem(value: 'France', child: Text('France')),
        DropdownMenuItem(value: 'Georgia', child: Text('Georgia')),
        DropdownMenuItem(value: 'Germany', child: Text('Germany')),
        DropdownMenuItem(value: 'Greece', child: Text('Greece')),
        DropdownMenuItem(value: 'Hungary', child: Text('Hungary')),
        DropdownMenuItem(value: 'Iceland', child: Text('Iceland')),
        DropdownMenuItem(value: 'Ireland', child: Text('Ireland')),
        DropdownMenuItem(value: 'Italy', child: Text('Italy')),
        DropdownMenuItem(value: 'Kazakhstan', child: Text('Kazakhstan')),
        DropdownMenuItem(value: 'Kosovo', child: Text('Kosovo')),
        DropdownMenuItem(value: 'Latvia', child: Text('Latvia')),
        DropdownMenuItem(value: 'Liechtenstein', child: Text('Liechtenstein')),
        DropdownMenuItem(value: 'Lithuania', child: Text('Lithuania')),
        DropdownMenuItem(value: 'Luxembourg', child: Text('Luxembourg')),
        DropdownMenuItem(value: 'Malta', child: Text('Malta')),
        DropdownMenuItem(value: 'Moldova', child: Text('Moldova')),
        DropdownMenuItem(value: 'Monaco', child: Text('Monaco')),
        DropdownMenuItem(value: 'Montenegro', child: Text('Montenegro')),
        DropdownMenuItem(value: 'Netherlands', child: Text('Netherlands')),
        DropdownMenuItem(
            value: 'North Macedonia', child: Text('North Macedonia')),
        DropdownMenuItem(value: 'Norway', child: Text('Norway')),
        DropdownMenuItem(value: 'Poland', child: Text('Poland')),
        DropdownMenuItem(value: 'Portugal', child: Text('Portugal')),
        DropdownMenuItem(value: 'Romania', child: Text('Romania')),
        DropdownMenuItem(value: 'Russia', child: Text('Russia')),
        DropdownMenuItem(value: 'San Marino', child: Text('San Marino')),
        DropdownMenuItem(value: 'Serbia', child: Text('Serbia')),
        DropdownMenuItem(value: 'Slovakia', child: Text('Slovakia')),
        DropdownMenuItem(value: 'Slovenia', child: Text('Slovenia')),
        DropdownMenuItem(value: 'Spain', child: Text('Spain')),
        DropdownMenuItem(value: 'Sweden', child: Text('Sweden')),
        DropdownMenuItem(value: 'Switzerland', child: Text('Switzerland')),
        DropdownMenuItem(value: 'Turkey', child: Text('Turkey')),
        DropdownMenuItem(value: 'Ukraine', child: Text('Ukraine')),
        DropdownMenuItem(
            value: 'United Kingdom', child: Text('United Kingdom')),
        DropdownMenuItem(value: 'Vatican City', child: Text('Vatican City')),
      ],
      onChanged: (value) {},
    );
  }

  Widget _buildDatePickerField(String label) {
    return TextField(
      controller: _dateController,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        border: const OutlineInputBorder(),
        suffixIcon: const Icon(
          Icons.calendar_today,
          color: Colors.orange,
        ),
      ),
      onTap: () async {
        DateTime? selectedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
        );

        if (selectedDate != null) {
          String formattedDate = DateFormat('dd/MM/yyyy').format(selectedDate);
          setState(() {
            _dateController.text = formattedDate;
          });
        }
      },
    );
  }
}
