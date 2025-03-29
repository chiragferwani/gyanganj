import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:share_plus/share_plus.dart';
import 'package:gyanganj/navigation.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottie/lottie.dart';

class WikipediaNewsScreen extends StatefulWidget {
  @override
  _WikipediaNewsScreenState createState() => _WikipediaNewsScreenState();
}

class _WikipediaNewsScreenState extends State<WikipediaNewsScreen> {
  List newsArticles = [];
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  
  @override
  void initState() {
    super.initState();
    fetchTrendingNews();
  }

  Future<void> fetchTrendingNews([String query = '']) async {
    setState(() {
      isLoading = true;
    });
    
    String url = query.isEmpty
        ? 'https://en.wikipedia.org/api/rest_v1/feed/featured/2024/03/27' // Trending news
        : 'https://en.wikipedia.org/w/api.php?action=query&format=json&prop=extracts|pageimages&exintro&explaintext&piprop=thumbnail&pithumbsize=200&generator=search&gsrsearch=$query';
    
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        List articles = [];
        
        if (query.isEmpty) {
          // Fetching trending articles
          data['mostread']['articles'].forEach((article) {
            articles.add({
              'title': article['title'],
              'extract': article['extract'] ?? '',
              'image': article['thumbnail']?['source'] ?? '',
              'url': 'https://en.wikipedia.org/wiki/${article['title'].replaceAll(' ', '_')}'
            });
          });
        } else {
          // Fetching searched articles
          if (data['query'] != null && data['query']['pages'] != null) {
            data['query']['pages'].forEach((key, article) {
              articles.add({
                'title': article['title'],
                'extract': article['extract'] ?? '',
                'image': article['thumbnail']?['source'] ?? '',
                'url': 'https://en.wikipedia.org/wiki/${article['title'].replaceAll(' ', '_')}'
              });
            });
          }
        }

        setState(() {
          newsArticles = articles;
        });
      }
    } catch (e) {
      print("Error fetching news: $e");
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
       appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Navigation()));
          },
        ),
        title: Text("News", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontFamily: 'boldfont')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search Wiki News',
                hintStyle: TextStyle(fontFamily: 'boldfont'),
                prefixIcon: Icon(Ionicons.search),
                suffixIcon: searchController.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(Ionicons.close),
                              onPressed: () {
                                searchController.clear();
                              },
                            )
                          : null,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onSubmitted: (query) {
                fetchTrendingNews(query);
              },
            ),
            SizedBox(height: 10),
            Expanded(
              child: isLoading
                  ? Center(
                    child: Column(
                children: [
                      SizedBox(height: 50,),
                      Lottie.asset('assets/images/worldtry.json'),
                      
                    ],
                  ),
                  )
                  : newsArticles.isEmpty
                      ? Center(child: Text('No news found', style: TextStyle(fontFamily: 'boldfont')))
                      : ListView.builder(
  itemCount: newsArticles.length,
  itemBuilder: (context, index) {
    var article = newsArticles[index];
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        leading: article['image'].isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  article['image'],
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              )
            : Image.asset(
                'assets/images/wikipedia_logo.png',
                width: 50,
                height: 50,
              ),
        title: Text(
          article['title'],
          style: TextStyle(
            fontFamily: 'boldfont',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          article['extract'],
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontFamily: 'boldfont', fontSize: 14),
        ),
        trailing: IconButton(
          icon: Icon(Ionicons.share_social_outline),
          onPressed: () => Share.share(article['url']),
          color: Colors.black,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewsDetailScreen(article: article),
            ),
          );
        },
      ),
    );
  },
)

            ),
          ],
        ),
      ),
    );
  }
}

class NewsDetailScreen extends StatelessWidget {
  final Map<String, dynamic> article;
  NewsDetailScreen({required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(article['title'], style: TextStyle(fontFamily: 'boldfont')),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              article['image'].isNotEmpty
                  ? Image.network(article['image'], width: double.infinity, height: 250, fit: BoxFit.cover)
                  : Image.asset('assets/wikipedia_logo.png', width: double.infinity, height: 200),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(article['extract'], style: TextStyle(fontSize: 15, fontFamily: 'boldfont'), textAlign: TextAlign.justify,),
              ),
              SizedBox(height: 10),
             Center(
               child: ElevatedButton.icon(
                     onPressed: () => Share.share(article['url']),
                      icon: Icon(Ionicons.share_social, color: Colors.black), // Search Icon
                      label: Text(
                        "Share",
                        style: TextStyle(
                          fontFamily: 'boldfont', // Replace 'boldfont' with your actual font
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // Text color
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, // White background
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // Rounded corners
                          side: BorderSide(color: Colors.black, width: 2), // Black Border
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18), // Button padding
                        elevation: 3, // Light shadow effect
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
