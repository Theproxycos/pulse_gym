import 'package:flutter/material.dart';

class Editprofile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   title: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     children: [
      //       GestureDetector(
      //         onTap: () {
      //           if (Navigator.canPop(context)) {
      //             Navigator.pop(context);
      //           } else {
      //             Navigator.pushNamed(context, '/homepage');
      //           }
      //         },
      //         child: Row(
      //           children: [
      //             Icon(Icons.arrow_back, color: Colors.black),
      //             SizedBox(width: 5),
      //             Text(
      //               'Back',
      //               style: TextStyle(color: Colors.black),
      //             ),
      //           ],
      //         ),
      //       ),
      //       SizedBox(
      //           width:
      //               24), // Placeholder para alinhar com o ícone de notificação, se necessário
      //     ],
      //   ),
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      // ),
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
              Text(
                'Edit Profile',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Surname',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 30),
              Center(
                child: OutlinedButton(
                  onPressed: () {
                    // Lógica para salvar as alterações
                  },
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    side: BorderSide(color: Colors.orange, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
