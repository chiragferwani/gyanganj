import 'package:flutter/material.dart';
import 'package:gyanganj/explore.dart';
import 'package:gyanganj/infoscreen.dart';
import 'package:gyanganj/interests.dart';
import 'package:gyanganj/profile_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pull_to_refresh/pull_to_refresh.dart'; // Pull-to-refresh package
import 'package:ionicons/ionicons.dart';

void main() {
  runApp(MaterialApp(
    home: HomeScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List trendingTopics = [];
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    fetchTrendingTopics();
  }

  // ✅ Pehli baar trending topics fetch karega
  Future<void> fetchTrendingTopics() async {
    final response = await http.get(Uri.parse('https://en.wikipedia.org/api/rest_v1/feed/featured/2025/03/22'));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        trendingTopics = data['mostread']['articles'].map((article) => {
          'title': article['title'],
          'description': article['extract'],
          'image': article['thumbnail'] != null ? article['thumbnail']['source'] : null
        }).toList();
      });
    }
    _refreshController.refreshCompleted();
  }

  // ✅ Ab ye sirf shuffle karega jab refresh hoga
  Future<void> shuffleTrendingTopics() async {
    trendingTopics.shuffle();
    setState(() {}); 
    _refreshController.refreshCompleted();
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


      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: shuffleTrendingTopics, // ✅ Refresh pe sirf shuffle karega
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Categories', style: TextStyle(fontSize: 20, fontFamily: 'boldfont')),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => InterestsPage()));
                    },
                    child: Text('Explore', style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'boldfont')),
                  ),
                ],
              ),
                SizedBox(height: 10),
                GridView.count(
                  crossAxisCount: 4,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    _buildCategoryItem(Icons.computer, 'Technology'),
                    _buildCategoryItem(Icons.science, 'Science'),
                    _buildCategoryItem(Icons.palette, 'Art'),
                    _buildCategoryItem(Icons.map, 'Geography'),
                    _buildCategoryItem(Icons.psychology, 'Psychology'),
                    _buildCategoryItem(Icons.public, 'Space'),
                    _buildCategoryItem(Icons.eco, 'Nature'),
                    _buildCategoryItem(Icons.currency_exchange, 'Economics'),
                  ],
                ),
                SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.trending_up, color: Colors.black, size: 24),
                        SizedBox(width: 8),
                        Text('Trending Topics', style: TextStyle(fontFamily: 'boldfont', fontSize: 20)),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) =>ExploreScreen()));
                      },
                      child: Text('Explore', style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'boldfont')),
                    ),
                  ],
                ),

                SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: trendingTopics.length,
                  itemBuilder: (context, index) {
                    return _buildTrendingTile(trendingTopics[index]);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ✅ Category UI 
  Widget _buildCategoryItem(IconData icon, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 30, color: Colors.black),
        SizedBox(height: 5),
        Text(label, style: TextStyle(fontFamily: 'boldfont')),
      ],
    );
  }

  // ✅ Trending topics UI
Widget _buildTrendingTile(dynamic article) {
  return Card(
    color: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    elevation: 4,
    margin: EdgeInsets.symmetric(vertical: 8),
    child: ListTile(
      leading: article['image'] != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(article['image'], width: 60, height: 60, fit: BoxFit.cover),
            )
          : Icon(Ionicons.globe_outline, size: 60),
      title: Text(article['title'], style: TextStyle(fontFamily: 'boldfont')),
      subtitle: Text(article['description'], maxLines: 2, overflow: TextOverflow.ellipsis),
      trailing: Icon(Icons.arrow_forward_ios, size: 18),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticlePage(
              title: article['title'],
              description: article['description'],
              imageUrl: article['image'],
            ),
          ),
        );
      },
    ),
  );
}

}


class ArticlePage extends StatelessWidget {
  final String title;
  final String description;
  final String? imageUrl;

  ArticlePage({required this.title, required this.description, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(title, style: TextStyle(fontFamily: 'boldfont')),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl != null) // Agar image available hai toh dikhao
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(imageUrl!, width: double.infinity, height: 200, fit: BoxFit.cover),
              ),
            SizedBox(height: 10),
            Text(title, style: TextStyle(fontSize: 22, fontFamily: 'boldfont')),
            SizedBox(height: 10),
            Text(description, style: TextStyle(fontSize: 16,), textAlign: TextAlign.justify,),
          ],
        ),
      ),
    );
  }
}