import 'package:flutter/material.dart';
import 'package:gyanganj/infoscreen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ionicons/ionicons.dart';
import 'package:gyanganj/profile_page.dart';
import 'package:lottie/lottie.dart';
import 'article_page.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  List<dynamic> searchResults = [];
  List<dynamic> trendingTopics = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchTrendingTopics();
  }

  // 🔥 Fetch Trending Wikipedia Topics
  Future<void> fetchTrendingTopics() async {
    final response = await http.get(Uri.parse(
        'https://en.wikipedia.org/api/rest_v1/feed/featured/2024/03/19'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        trendingTopics = (data['mostread']['articles'] as List)
            .map((article) => {
                  'title': article['title'],
                  'description': article['extract'] ?? "No description."
                })
            .toList();
      });
    }
  }

  // 🔍 Wikipedia Search API
  Future<void> searchWikipedia(String query) async {
  if (query.isEmpty) return;
  setState(() => isLoading = true);

  final response = await http.get(Uri.parse(
      'https://en.wikipedia.org/w/api.php?action=query&format=json&prop=extracts&exintro=true&explaintext=true&generator=search&gsrsearch=$query&gsrlimit=10'));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);

    // 🛑 Fix: Null check added
    if (data.containsKey('query') && data['query'].containsKey('pages')) {
      setState(() {
        searchResults = data['query']['pages'].values.toList();
      });
    } else {
      setState(() {
        searchResults = []; // Handle empty response safely
      });
    }
  } else {
    setState(() {
      searchResults = [];
    });
  }
  
  setState(() => isLoading = false);
}

// 🔄 Refresh Button (Shuffles Trending Topics)
void refreshTrendingTopics() {
  setState(() {
    trendingTopics.shuffle();
  });
}


  @override
  Widget build(BuildContext context) {
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
      body: Column(
        children: [
          Padding(
  padding: EdgeInsets.all(10),
  child: Row(
    children: [
      Expanded(
        child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search topics...",
                  hintStyle: TextStyle(fontFamily: 'boldfont'),
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty // 🔹 Check if text exists
                      ? IconButton(
                          icon: Icon(Ionicons.close_circle_outline), // ❌ Clear button
                          onPressed: () {
                            _searchController.clear(); // ✅ Clears text
                            searchWikipedia(""); // ✅ Resets search results
                          },
                        )
                      : null, // Hide when empty
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.black, width: 1),
                  ),
                ),
                onChanged: (value) => searchWikipedia(value),
              ),
            ),
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: refreshTrendingTopics,
            ),
          ],
        ),
      ),

          Expanded(
            child: isLoading
                ? Center(child: 
                    Center(
                      child: Column(
                                    children: [
                      SizedBox(height: 250,),
                      // Lottie.asset('assets/images/worldtry.json'),
                      
                                        ],
                                      ),
                    ),
                
              

                )
                : searchResults.isNotEmpty
                    ? ListView.builder(
                        itemCount: searchResults.length,
                        itemBuilder: (context, index) {
                          final article = searchResults[index];
                          return _buildTile(article['title'],
                              article['extract'] ?? "No description available.");
                        },
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              "Trending Topics",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'boldfont'),
                            ),
                          ),
                          Expanded(
                            child: trendingTopics.isNotEmpty
                                ? ListView.builder(
                                    itemCount: trendingTopics.length,
                                    itemBuilder: (context, index) {
                                      return _buildTile(
                                          trendingTopics[index]['title'],
                                          trendingTopics[index]
                                              ['description']);
                                    },
                                  )
                                : Center(
                                    child:  Column(
                                        children: [
                                              Lottie.asset('assets/images/worldtry.json'),
                                              
                                            ],
                                          ),
                                  ),
                          ),
                        ],
                      ),
          ),
        ],
      ),
    );
  }

  // 📌 UI Component - Tiles for Trending Topics & Search Results
  Widget _buildTile(String title, String description) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      child: ListTile(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'boldfont')),
        subtitle: Text(description,
            maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: 'boldfont'),),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ArticlePage(title: title)),
          );
        },
      ),
    );
  }
}
