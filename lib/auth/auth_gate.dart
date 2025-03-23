// AUTH GATE - This will continuously listen for auth state changes
//Unauthenticated -> Login page
//Authenticated -> Home page

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gyanganj/navigation.dart';
import 'package:gyanganj/login_page.dart';
import 'package:gyanganj/profile_page.dart';
import 'package:gyanganj/interests.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      //listen to auth state changes
      stream: Supabase.instance.client.auth.onAuthStateChange, 
      builder: (context, snapshot){
        //loading..
        if (snapshot.connectionState == ConnectionState.waiting){
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            )
          );
        }

        //check if there is a valid session currently
        final session = snapshot.hasData ? snapshot.data!.session : null;

        if (session != null){
          return InterestsPage();
        } else {
          return LoginPage();
        }
      },
      );
  }
}