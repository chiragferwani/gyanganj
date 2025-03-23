import 'package:flutter/material.dart';
import 'package:gyanganj/infoscreen.dart';
import 'package:lottie/lottie.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ionicons/ionicons.dart';
import 'profile_page.dart';

class SavedArticlesScreen extends StatefulWidget {
  @override
  _SavedArticlesScreenState createState() => _SavedArticlesScreenState();
}

class _SavedArticlesScreenState extends State<SavedArticlesScreen> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> savedArticles = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSavedArticles();
  }

  Future<void> fetchSavedArticles() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    final response = await supabase.from('saved_works').select('*').eq('user_id', userId);
    setState(() {
      savedArticles = List<Map<String, dynamic>>.from(response);
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
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
       body: isLoading
          ? Center(child: 
           Center(
            child: Column(
                children: [
                      SizedBox(height: 50,),
                      Lottie.asset('assets/images/worldtry.json'),
                      
                    ],
                  ),
          ),
          )
          : savedArticles.isEmpty
              ? Center(child: Text("No saved articles yet."))
              : ListView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: savedArticles.length,
                  itemBuilder: (context, index) {
                    final article = savedArticles[index];
                    return Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 4,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(12),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: article['thumbnail'] != null
                              ? Image.network(article['thumbnail'], width: 60, height: 80, fit: BoxFit.cover)
                              : Container(
                                  width: 60,
                                  height: 60,
                                  color: Colors.grey[300],
                                  child: Icon(Icons.image_not_supported, size: 40),
                                ),
                        ),
                        title: Text(
                          article['title'],
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'boldfont'),
                        ),
                        subtitle: Text(
                          article['content'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 14),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios, size: 18, color: Colors.black),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ArticleDetailScreen(article: article),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}


class ArticleDetailScreen extends StatelessWidget {
  final Map<String, dynamic> article;

  ArticleDetailScreen({required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text(article['title'] ?? 'Article', style: TextStyle(fontFamily: 'boldfont'),)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article['thumbnail'] != null)
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(article['thumbnail'], fit: BoxFit.cover),
                ),
              ),
            SizedBox(height: 16),
            Text(
              article['title'] ?? 'No Title',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'boldfont'),
            ),
            SizedBox(height: 10),
            Text(
              article['content'] ?? 'No Content Available',
              style: TextStyle(fontSize: 16, height: 1.5, fontFamily: 'boldfont'), textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}