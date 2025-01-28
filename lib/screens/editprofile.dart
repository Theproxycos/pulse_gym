import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore.dart';

class EditProfile extends StatefulWidget {
  final String userId;

  EditProfile({required this.userId});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    
    // Printando o userId para teste
    print('User ID: ${widget.userId}');
    
    _loadUserData();
  }

  void _loadUserData() async {
    final userData = await _firestoreService.getUserData(widget.userId);
    if (userData != null) {
      setState(() {
        _usernameController.text = userData['username'] ?? '';
        _emailController.text = userData['email'] ?? '';
        _phoneController.text = userData['phone_number'] ?? '';
        _addressController.text = userData['address'] ?? '';
      });
    }
  }

  void _saveChanges() async {
    await _firestoreService.updateUserData(widget.userId, {
      'username': _usernameController.text,
      'email': _emailController.text,
      'phone_number': _phoneController.text,
      'address': _addressController.text,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Perfil atualizado com sucesso!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Edit Profile', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              TextField(controller: _usernameController, decoration: InputDecoration(labelText: 'Username', border: OutlineInputBorder())),
              SizedBox(height: 20),
              TextField(controller: _emailController, decoration: InputDecoration(labelText: 'Email', border: OutlineInputBorder())),
              SizedBox(height: 20),
              TextField(controller: _phoneController, keyboardType: TextInputType.phone, decoration: InputDecoration(labelText: 'Phone Number', border: OutlineInputBorder())),
              SizedBox(height: 20),
              TextField(controller: _addressController, decoration: InputDecoration(labelText: 'Address', border: OutlineInputBorder())),
              SizedBox(height: 30),
              Center(
                child: OutlinedButton(
                  onPressed: _saveChanges,
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    side: BorderSide(color: Colors.orange, width: 2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text('Save', style: TextStyle(fontSize: 16, color: Colors.orange, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
