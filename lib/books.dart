import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ionicons/ionicons.dart';
import 'package:gyanganj/navigation.dart';
import 'package:lottie/lottie.dart';

class BooksScreen extends StatefulWidget {
  @override
  _BooksScreenState createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  List<dynamic> books = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchTrendingBooks();
  }

  Future<void> fetchTrendingBooks() async {
    await fetchBooks("trending");
  }

  Future<void> fetchBooks(String query) async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await Dio().get(
        'https://openlibrary.org/search.json?q=$query',
      );
      setState(() {
        books = response.data['docs'];
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching books: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<String> fetchBookSummary(String title) async {
    try {
      final response = await Dio().get(
        'https://en.wikipedia.org/api/rest_v1/page/summary/$title',
      );
      return response.data['extract'] ?? 'No additional information available.';
    } catch (e) {
      return 'No additional information available.';
    }
  }

  void navigateToBookDetails(BuildContext context, dynamic book) async {
    String summary = await fetchBookSummary(book['title'] ?? "");
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookDetailsScreen(book: book, summary: summary),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Books", style: TextStyle(fontFamily: 'boldfont', color: Colors.white),),
        backgroundColor: Colors.black,
         leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Navigation()));
          },
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search Books",
                hintStyle: TextStyle(fontFamily: 'boldfont', color: Colors.black),
                prefixIcon: Icon(Ionicons.search),
                suffixIcon: searchController.text.isNotEmpty
                          ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: IconButton(
                                icon: Icon(Ionicons.close),
                                onPressed: () {
                                  searchController.clear();
                                },
                              ),
                          )
                          : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  fetchBooks(value);
                }
              },
            ),
          ),
        ),
      ),
      body: isLoading
          ? Center(
            child: Column(
                children: [
                      SizedBox(height: 50,),
                      Lottie.asset('assets/images/worldtry.json'),
                      
                    ],
                  ),
            )
          : ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return Card(
                  color: Colors.white,
                  margin: EdgeInsets.all(10),
                  elevation: 5,
                  child: ListTile(
                    leading: CachedNetworkImage(
                      imageUrl: book['cover_i'] != null
                          ? 'https://covers.openlibrary.org/b/id/${book['cover_i']}-M.jpg'
                          : '',
                      width: 50,
                      height: 80,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Image.asset(
                          'assets/images/googleplay.png',
                          width: 50,
                          height: 80),
                      errorWidget: (context, url, error) => Image.asset(
                          'assets/images/googleplay.png',
                          width: 50,
                          height: 80),
                    ),
                    title: Text(
                      book['title'] ?? 'No Title',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'boldfont'),
                    ),
                    subtitle: Text(
                      book['author_name'] != null
                          ? book['author_name'].join(", ")
                          : 'Unknown Author',
                          style: TextStyle(fontFamily: 'boldfont'),
                    ),
                    onTap: () => navigateToBookDetails(context, book),
                  ),
                );
              },
            ),
    );
  }
}

class BookDetailsScreen extends StatelessWidget {
  final dynamic book;
  final String summary;

  BookDetailsScreen({required this.book, required this.summary});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(book['title'] ?? 'Book Details', style: TextStyle(fontFamily: 'boldfont'),),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(Icons.share),
              onPressed: () {
                Share.share('${book['title']} by ${book['author_name']?.join(", ") ?? "Unknown"}');
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CachedNetworkImage(
                  imageUrl: book['cover_i'] != null
                      ? 'https://covers.openlibrary.org/b/id/${book['cover_i']}-L.jpg'
                      : '',
                  width: 150,
                  height: 200,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Image.asset(
                      'assets/images/googleplay.png',
                      width: 150,
                      height: 200),
                  errorWidget: (context, url, error) => Image.asset(
                      'assets/images/googleplay.png',
                      width: 150,
                      height: 200),
                ),
              ),
              
              SizedBox(height: 15),
              Text(
                book['author_name'] != null
                    ? "Author: " + book['author_name'].join(", ")
                    : 'Unknown Author',
                style: TextStyle(fontSize: 16, color: Colors.grey[700], fontFamily: 'boldfont'),
              ),
              SizedBox(height: 15),
              Text(
                "Summary: $summary",
                style: TextStyle(fontSize: 16, fontFamily: 'boldfont'),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
