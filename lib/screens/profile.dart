import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../services/firestore.dart';
import '../widgets/custom_bottom_nav_bar.dart';

class ProfilePage extends StatefulWidget {
  final String userId;

  const ProfilePage({super.key, required this.userId});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirestoreService _firestoreService = FirestoreService();
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  // Buscar a foto de perfil do Firestore
  void _loadProfileImage() async {
    final userData = await _firestoreService.getUserData(widget.userId);
    if (userData != null && userData['profileImageUrl'] != null) {
      setState(() {
        _profileImageUrl = userData['profileImageUrl'];
      });
    }
  }

  // Função para selecionar imagem da galeria
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      _uploadImage(imageFile);
    }
  }

  Future<void> _uploadImage(File imageFile) async {
    try {
      // Definindo o caminho onde a imagem será armazenada no Firebase Storage
      String filePath = 'profile_pictures/${widget.userId}.jpg';

      // Tentando fazer o upload da imagem para o Firebase Storage
      UploadTask uploadTask =
          FirebaseStorage.instance.ref().child(filePath).putFile(imageFile);

      // Aguarda o upload ser concluído e, ao término, obtém a URL do arquivo
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // Atualizar a URL da imagem de perfil no Firestore
      await _firestoreService.updateUserData(widget.userId, {
        'profileImageUrl': downloadUrl,
      });

      setState(() {
        _profileImageUrl = downloadUrl;
      });

      _showMessage('Foto de perfil atualizada com sucesso!', isSuccess: true);
    } catch (e) {
      // Se algum erro ocorrer durante o upload ou a atualização, exibe uma mensagem
      _showMessage('Erro ao enviar a imagem. Tente novamente. Erro: $e');
    }
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
        print("UserId no profile: ${widget.userId}");

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile',style: TextStyle(color: Colors.orange)),
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: _profileImageUrl != null
                      ? NetworkImage(_profileImageUrl!)
                      : null,
                  child: _profileImageUrl == null
                      ? Icon(Icons.camera_alt, size: 40, color: Colors.white)
                      : null,
                ),
              ),
              const SizedBox(height: 10),
              const Text('Change Profile Picture',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              Card(
                child: ListTile(
                  leading:
                      const Icon(Icons.badge, size: 40, color: Colors.orange),
                  title: const Text('Edit Profile'),
                  trailing:
                      const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                  onTap: () {
                    Navigator.pushNamed(context, '/editprofile',
                        arguments: {'userId': widget.userId}
                        );
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
                  leading: const Icon(Icons.language,
                      size: 40, color: Colors.orange),
                  title: const Text('Change Language'),
                  trailing:
                      const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                  onTap: () {
                    // Navegar para a página de idiomas
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
                    Navigator.pushNamed(context, '/subscription_page');
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
