import 'package:flutter/material.dart';
import 'package:gyanganj/auth/auth_service.dart';
import 'package:gyanganj/register_page.dart';
import 'package:gyanganj/main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  //get auth service
  final authService = AuthService();

  //text controller
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  //login button pressed
  void login() async{
    //prepare data
    final email = _emailController.text;
    final password = _passwordController.text;

    //attempt login..
    try{
      await authService.signInWithEmailPassword(email, password);
    } 
    //catch any errors
    catch (e) {
      if (mounted){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Unable To Login")));
      }
    }
  }
  //Build UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color.fromARGB(255, 255, 255, 255), Color.fromARGB(255, 255, 255, 255)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 100),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      height: 200,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "GyanGanj",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 14, 14, 14),
                        fontFamily: 'boldfont'
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Your Gateway To Infinite Knowledge",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'boldfont',
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 30),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: "Email",
                        
                        labelStyle: const TextStyle(
                          fontFamily: 'boldfont'
                        ),
                        border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.black, width: 1),
                    
                    ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: "Password",
                        labelStyle: const TextStyle(
                          fontFamily: 'boldfont'
                        ),
                        border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.black, width: 1),
                    ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      
                      onPressed: login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: BorderSide(color: Colors.black, width: 2.0),
                        padding:
                            const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                      ),
                      child: const Text("SIGN IN",
                          style: TextStyle(
                              fontSize: 18, fontFamily: 'boldfont', color: Colors.black)),
                    ),
                    const SizedBox(height: 20),
                   GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterPage()),
                  ),
                  child: const Text(
                    "Don't have an account? Sign Up",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontFamily: 'boldfont'
                    ),
                  ),
                ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}