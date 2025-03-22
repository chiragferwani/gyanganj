import 'package:flutter/material.dart';
import 'package:gyanganj/splash.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

//global object for accessing device screen size
late Size mq;

void main() async{
  await Supabase.initialize(
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1rZGVwa2pqZmNsaWhpc3BkYnZuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDIzNjQ0NDQsImV4cCI6MjA1Nzk0MDQ0NH0.xeVsiLpPqxkMuLNmcW3SlerYAQyn8qFl5zDiWYkn8J8",
    url: "https://mkdepkjjfclihispdbvn.supabase.co"
  );
  runApp(const MyApp());
  
  
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Splash(),
      routes: {
         
        // '/income_tax': (context) => TaxCalculator(),
      },
    );
  }
}


