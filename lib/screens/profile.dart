import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert'; // Para codificação Base64
import '../services/firestore.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import 'login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image/image.dart'
    as img; // Pacote para redimensionamento da imagem

class ProfilePage extends StatefulWidget {
  final String userId;

  const ProfilePage({super.key, required this.userId});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirestoreService _firestoreService = FirestoreService();
  String? _profileImageBase64;
  bool _isLoading = false; // Para mostrar um indicador de carregamento

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  // Buscar a foto de perfil do Firestore
  void _loadProfileImage() async {
    final userData = await _firestoreService.getUserData(widget.userId);
    if (userData != null && userData['profileImageBase64'] != null) {
      setState(() {
        _profileImageBase64 = userData['profileImageBase64'];
      });
    }
  }

  // Função para selecionar imagem da galeria
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      _convertImageToBase64(imageFile);
    }
  }

  // Converte a imagem para Base64, redimensiona dependendo da orientação e armazena no Firestore
  Future<void> _convertImageToBase64(File imageFile) async {
    try {
      setState(() {
        _isLoading = true; // Mostrar indicador de carregamento
      });

      // Carregar a imagem usando o pacote image
      List<int> imageBytes = await imageFile.readAsBytes();
      img.Image? image = img.decodeImage(Uint8List.fromList(imageBytes));

      if (image != null) {
        img.Image resizedImage;

        // Se a imagem estiver na horizontal (largura maior que altura)
        if (image.width > image.height) {
          // Redimensionar para uma largura fixa de 600px (ajuste conforme necessário) e proporcional à altura
          resizedImage = img.copyResize(image, width: 600);
        } else {
          // Se a imagem estiver na vertical (altura maior que largura)
          // Redimensionar para uma altura fixa de 800px (ajuste conforme necessário) e proporcional à largura
          resizedImage = img.copyResize(image, height: 800);
        }

        // Converter a imagem redimensionada para Base64
        String base64String = base64Encode(img.encodeJpg(resizedImage));

        // Atualizar a imagem em Base64 no Firestore
        await _firestoreService.updateUserData(widget.userId, {
          'profileImageBase64': base64String,
        });

        setState(() {
          _profileImageBase64 = base64String;
          _isLoading = false; // Remover indicador de carregamento
        });

        _showMessage('Profile photo successfully updated!', isSuccess: true);
      } else {
        throw Exception("The image could not be resized.");
      }
    } catch (e) {
      setState(() {
        _isLoading = false; // Remover indicador de carregamento
      });
      print('Error processing the image: $e');
      _showMessage('Error processing the image. Error: $e');
    }
  }

  // Função para mostrar mensagens (sucesso ou erro)
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
        title: const Text('Profile', style: TextStyle(color: Colors.orange)),
      ),
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage, // Ao tocar, abre a galeria
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: _profileImageBase64 != null
                      ? MemoryImage(base64Decode(_profileImageBase64!))
                      : null,
                  child: _profileImageBase64 == null
                      ? const Icon(Icons.camera_alt,
                          size: 40, color: Colors.white)
                      : null,
                ),
              ),
              const SizedBox(height: 10),
              const Text('Change Profile Picture',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              _isLoading
                  ? CircularProgressIndicator() // Exibir o indicador de progresso
                  : Container(), // Caso contrário, não mostrar nada
              const SizedBox(height: 20),
              Card(
                child: ListTile(
                  leading:
                      const Icon(Icons.badge, size: 40, color: Colors.orange),
                  title: const Text('Edit Profile'),
                  trailing:
                      const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                  onTap: () {
                    Navigator.pushNamed(context, '/editprofile',
                        arguments: {'userId': widget.userId});
                  },
                ),
              ),
              Card(
                child: ListTile(
                  leading:
                      const Icon(Icons.lock, size: 40, color: Colors.orange),
                  title: const Text('Change Password'),
                  trailing:
                      const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                  onTap: () {
                    Navigator.pushNamed(context, '/nova_senha',
                        arguments: {'userId': widget.userId});
                  },
                ),
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.currency_exchange,
                      size: 40, color: Colors.orange),
                  title: const Text('Subscription'),
                  trailing:
                      const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                  onTap: () {
                    Navigator.pushNamed(context, '/subscription_page',
                        arguments: {'userId': widget.userId});
                  },
                ),
              ),
              Card(
                child: ListTile(
                  leading:
                      const Icon(Icons.logout, size: 40, color: Colors.orange),
                  title: const Text('Log Out'),
                  trailing:
                      const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.clear(); // Remove a sessão do utilizador
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                      (Route<dynamic> route) => false,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 4,
        currentRoute: 'Profile',
        userId: widget.userId,
      ),
    );
  }
}
