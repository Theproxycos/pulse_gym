import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/firestore.dart'; // For Firestore service
import 'package:email_validator/email_validator.dart'; // For email format validation

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordconfirmController =
      TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String _selectedCountry = '';
  String _gender = '';
  final TextEditingController _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.primaryColor),
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
            _buildTextField('Username',
                controller: _usernameController, isRequired: true),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    'Phone number',
                    isRequired: true,
                    keyboardType: TextInputType.phone,
                    controller: _phoneController,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildTextField('Email',
                isRequired: true, controller: _emailController),
            const SizedBox(height: 10),
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
            _buildDatePickerField('Date of birth'),
            const SizedBox(height: 10),
            _buildTextField('Password',
                isPassword: true, controller: _passwordController),
            const SizedBox(height: 10),
            _buildTextField('Re-enter Password',
                isPassword: true, controller: _passwordconfirmController),
            const SizedBox(height: 10),
            _buildTextField('Address', controller: _addressController),
            const SizedBox(height: 10),
            _buildDropdown('Country'),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  FirestoreService firestoreService = FirestoreService();

                  // Check if required fields are filled
                  if (_usernameController.text.isEmpty ||
                      _phoneController.text.isEmpty ||
                      _emailController.text.isEmpty ||
                      _gender.isEmpty ||
                      _dateController.text.isEmpty ||
                      _passwordController.text.isEmpty ||
                      _passwordconfirmController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Please fill in all required fields')),
                    );
                    return;
                  }

                  // Check if email format is valid
                  if (!EmailValidator.validate(_emailController.text)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Invalid email format')),
                    );
                    return;
                  }
                  // Check if username already exists
                  bool usernameExists = await firestoreService
                      .doesUsernameExist(_usernameController.text);
                  if (usernameExists) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Username already taken')),
                    );
                    return; // Prevent registration if username exists
                  }

                  // Check if date of birth is valid
                  DateTime? dateOfBirth = DateFormat('dd/MM/yyyy')
                      .parse(_dateController.text, true);
                  if (dateOfBirth.isAfter(DateTime.now())) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Invalid date of birth')),
                    );
                    return; // Prevent registration if date of birth is in the future
                  }

                  // Check if password and re-entered password match
                  if (_passwordController.text !=
                      _passwordconfirmController.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Passwords do not match')),
                    );
                    return;
                  }

                  try {
                    // Check if email exists in Firestore
                    bool emailExists = await firestoreService
                        .emailExists(_emailController.text);

                    if (emailExists) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Email already exists')),
                      );
                      return;
                    }

                    // Register user if email doesn't exist
                    await firestoreService.registerUser(
                      username: _usernameController.text,
                      phoneNumber: _phoneController.text,
                      email: _emailController.text,
                      gender: _gender,
                      dateOfBirth: _dateController.text,
                      password: _passwordController.text,
                      address: _addressController.text,
                      country: _selectedCountry,
                    );

                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('User registered successfully!')),
                    );

                    // Redirect to login page
                    Navigator.of(context).pushReplacementNamed('/login');
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  backgroundColor: Colors.orange,
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

  Widget _buildTextField(
    String label, {
    bool isPassword = false,
    bool isRequired = false,
    TextInputType keyboardType = TextInputType.text,
    required TextEditingController controller,
  }) {
    bool _isObscured = true;
    String? _errorText;

    String? _validatePassword(String value) {
      if (value.isEmpty) return 'The password is mandatory';
      if (value.length < 8)
        return 'The password must be at least 8 characters long';
      if (!RegExp(r'[A-Z]').hasMatch(value))
        return 'The password must contain at least one capital letter';
      if (!RegExp(r'[0-9]').hasMatch(value))
        return 'The password must contain at least one number';
      return null;
    }

    return StatefulBuilder(
      builder: (context, setState) {
        return TextField(
          controller: controller,
          obscureText: isPassword && _isObscured,
          keyboardType: keyboardType,
          onChanged: (value) {
            setState(() {
              _errorText = isPassword ? _validatePassword(value) : null;
            });
          },
          decoration: InputDecoration(
            labelText: label + (isRequired ? ' *' : ''),
            labelStyle: const TextStyle(fontSize: 14),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            border: const UnderlineInputBorder(),
            errorText: _errorText,
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                        _isObscured ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _isObscured = !_isObscured;
                      });
                    },
                  )
                : null,
          ),
        );
      },
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
      onChanged: (value) {
        setState(() {
          _selectedCountry = value!;
        });
      },
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
