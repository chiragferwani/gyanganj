import 'package:flutter/material.dart';
import 'package:gyanganj/books.dart';
import 'package:gyanganj/infoscreen.dart';
import 'package:gyanganj/login_page.dart';
import 'package:gyanganj/news.dart';
import 'package:gyanganj/quotes.dart';
import 'package:gyanganj/research.dart';
import 'package:gyanganj/stack.dart';
import 'package:ionicons/ionicons.dart';
import 'package:gyanganj/navigation.dart';
import 'package:gyanganj/auth/auth_service.dart';
import 'package:gyanganj/navigation.dart';



class NavBar extends StatelessWidget {
   final authService = AuthService();
  String name = "Chirag Ferwani"; // Placeholder for name
  String phoneNumber = "+918767386340"; // Placeholder for phone number

  void logout() async {
    await authService.signOut();
   
  }
  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final currentEmail = authService.getCurrentUserEmail();
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        // Remove padding
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              'Project - GyanGanj', 
              style: TextStyle(fontFamily: 'boldfont'),
            ),
            
            accountEmail: Text(currentEmail.toString(),
            style: TextStyle(fontFamily: 'boldfont'),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: ClipOval(
                
               child: Image.asset(
                'assets/images/appfront.png',  // 👈 Local Asset Path
                fit: BoxFit.cover,
                width: 90,
                height: 90,
              ),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.black,
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage('assets/images/background.jpg')
                      ),
            ),
          ),
          ListTile(
            leading: Icon(Ionicons.school, color: Color.fromARGB(255, 0, 0, 0),),
            title: Text('Research', style: TextStyle(fontFamily: 'boldfont', color: Colors.black),),
            onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> ResearchScreen())),
          ),
          ListTile(
            leading: Icon(Ionicons.planet, color: Color.fromARGB(255, 0, 0, 0),),
            title: Text('News', style: TextStyle(fontFamily: 'boldfont', color: Colors.black),),
            onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> WikipediaNewsScreen())),
          ),
         
         
          Divider(),
          ListTile(
            leading: Icon(Ionicons.exit, color: Color.fromARGB(255, 0, 0, 0),),
            title: Text('Exit', style: TextStyle(fontFamily: 'boldfont', color: Colors.black),),
            onTap: () => logout(),
          ),
          SizedBox(height: 100,),
          ListTile(
            leading: Icon(Ionicons.code_download, color: Color.fromARGB(255, 0, 0, 0),),
            title: Text('v0.0.3', style: TextStyle(fontFamily: 'boldfont', color: Colors.black),),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
