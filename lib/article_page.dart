import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:lottie/lottie.dart';

class ArticlePage extends StatefulWidget {
  final String title; // Jo title search page se aayega

  ArticlePage({required this.title});

  @override
  _ArticlePageState createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  Map<String, dynamic>? articleData;

  @override
  void initState() {
    super.initState();
    fetchArticle();
  }

  Future<void> fetchArticle() async {
    final response = await http.get(Uri.parse(
        'https://en.wikipedia.org/api/rest_v1/page/summary/${widget.title}'));
    
    if (response.statusCode == 200) {
      setState(() {
        articleData = json.decode(response.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(articleData?['title'] ?? "Loading...", style: TextStyle(fontFamily: 'boldfont'),),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: articleData == null
          ? Center(child: 
          Column(
                children: [
                      SizedBox(height: 50,),
                      Lottie.asset('assets/images/worldtry.json'),
                      
                    ],
                  ),
          ) // Jab tak data load nahi hota
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (articleData!['thumbnail'] != null) // Agar image available hai
                      Center(
                        child: Image.network(
                          articleData!['thumbnail']['source'],
                          height: 250,
                        ),
                      ),
                    SizedBox(height: 10),
                    Text(
                      articleData!['title'],
                      style: TextStyle(
                          fontSize: 22, 
                          fontFamily: 'boldfont',
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      articleData!['extract'] ?? "No description available.",
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
