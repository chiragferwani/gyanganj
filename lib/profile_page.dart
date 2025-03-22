import 'package:flutter/material.dart';
import 'package:gyanganj/auth/auth_service.dart';
import 'package:gyanganj/infoscreen.dart';
import 'package:gyanganj/login_page.dart';
import 'package:ionicons/ionicons.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final authService = AuthService();
  String name = "Chirag Ferwani"; // Placeholder for name
  String phoneNumber = "+918767386340"; // Placeholder for phone number

  void logout() async {
    await authService.signOut();
    Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()), // 👈 Yaha NextScreen ka naam apne screen ke according update karna
          );
  }

  void showEditNameDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final controller = TextEditingController(text: name);
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Edit Name',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'boldfont'),
          ),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: 'Enter new name',
              labelStyle: TextStyle(fontFamily: 'boldfont'),
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  name = controller.text; // Update name
                });
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Save', style: TextStyle(fontFamily: 'boldfont', fontSize: 18, color: Colors.black),),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Cancel', style: TextStyle(fontFamily: 'boldfont', fontSize: 18, color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

   void showEditPhoneDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final controller = TextEditingController(text: phoneNumber);
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Edit Phone',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'boldfont'),
          ),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: 'Enter new phone',
              labelStyle: TextStyle(fontFamily: 'boldfont'),
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  phoneNumber = controller.text; // Update name
                });
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Save', style: TextStyle(fontFamily: 'boldfont', fontSize: 18, color: Colors.black),),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Cancel', style: TextStyle(fontFamily: 'boldfont', fontSize: 18, color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentEmail = authService.getCurrentUserEmail();

    return Scaffold(
      backgroundColor: Colors.white,
       appBar: AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false, // 🔥 Back arrow hata diya
      title: Row(
        children: [
          Image.asset('assets/images/logo.png', height: 30),
          const SizedBox(width: 10),
          Text('GyanGanj', style: TextStyle(fontFamily: 'boldfont')),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: IconButton(
            icon: Icon(Ionicons.information_circle, size: 30),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProjectInfoScreen()),
              );
            },
          ),
        ),
      ],
    ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(1),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                ),
                Positioned(
                  top: 20,
                  right: 20,
                  child: IconButton(
                    icon: Icon(Ionicons.log_out_outline, color: Colors.white, size: 30),
                    onPressed: logout,
                  ),
                ),
                Positioned(
                  top: 55,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assets/images/profile.jpg'),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Profile',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'boldfont',
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        currentEmail.toString(),
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            _buildProfileOption(context, 'Name: $name', Ionicons.person_outline, showEditNameDialog),
            _buildProfileOption(context, 'Phone: $phoneNumber', Ionicons.call_outline, showEditPhoneDialog),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          leading: Icon(icon, color: Colors.black),
          title: Text(title, style: TextStyle(fontSize: 18, fontFamily: 'boldfont')),
          trailing: Icon(Icons.edit, size: 16, color: Colors.black), // Pen icon for editing
          onTap: onTap,
        ),
      ),
    );
  }
}
