import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:share_plus/share_plus.dart';
import 'package:lottie/lottie.dart';
import 'package:ionicons/ionicons.dart';
import 'package:gyanganj/navigation.dart';
import 'package:html_unescape/html_unescape.dart';

class StackExchangeScreen extends StatefulWidget {
  @override
  _StackExchangeScreenState createState() => _StackExchangeScreenState();
}

class _StackExchangeScreenState extends State<StackExchangeScreen> {
  List<dynamic> posts = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchTrendingQuestions();
  }

  Future<void> fetchTrendingQuestions() async {
    await fetchQuestions("");
  }

  Future<void> fetchQuestions(String query) async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await Dio().get(
        'https://hn.algolia.com/api/v1/search?query=$query',
      );

      List<dynamic> filteredPosts = response.data['hits'].where((post) {
        return post['points'] != null &&
            post['num_comments'] != null &&
            post['num_comments'] > 0;
      }).toList();

      setState(() {
        posts = filteredPosts;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch questions. Please try again.")),
      );
    }
  }

  void navigateToQuestionDetails(BuildContext context, dynamic post) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuestionDetailsScreen(post: post),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Ping", style: TextStyle(fontFamily: 'boldfont', color: Colors.white)),
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
                hintText: "Search posts",
                hintStyle: TextStyle(fontFamily: 'boldfont'),
                prefixIcon: Icon(Ionicons.search, color: Colors.black),
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
                fetchQuestions(value);
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
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  elevation: 5,
                  child: ListTile(
                    tileColor: Colors.white,
                    leading: Icon(Ionicons.cafe_outline, color: Colors.black),
                    title: Text(
                      post['title'] ?? 'No Title',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'boldfont'),
                    ),
                    subtitle: Text(
                      "Score: ${post['points']} | Comments: ${post['num_comments']}",
                      style: TextStyle(
                          color: Colors.grey[700], fontFamily: 'boldfont'),
                    ),
                    onTap: () => navigateToQuestionDetails(context, post),
                  ),
                );
              },
            ),
    );
  }
}

class QuestionDetailsScreen extends StatefulWidget {
  final dynamic post;

  QuestionDetailsScreen({required this.post});

  @override
  _QuestionDetailsScreenState createState() => _QuestionDetailsScreenState();
}

class _QuestionDetailsScreenState extends State<QuestionDetailsScreen> {
  List<dynamic> comments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchComments();
  }

  Future<void> fetchComments() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await Dio().get(
        'https://hn.algolia.com/api/v1/items/${widget.post['objectID']}',
      );

      setState(() {
        comments = response.data['children'];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch comments. Please try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(widget.post['title'] ?? 'Post Details',
            style: TextStyle(fontFamily: 'boldfont')),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(Ionicons.share_social),
              onPressed: () {
                String shareText =
                    "${widget.post['title']}\n\nScore: ${widget.post['points']}\nComments: ${widget.post['num_comments']}\n${widget.post['url']}";
                Share.share(shareText);
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.post['title'] ?? 'No Title',
              style: TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'boldfont'),
            ),
            SizedBox(height: 10),
            Text(
              "Score: ${widget.post['points']} | Comments: ${widget.post['num_comments']}",
              style: TextStyle(fontSize: 16, color: Colors.grey[700], fontFamily: 'boldfont'),
            ),
            SizedBox(height: 15),
            Text(
              "Top Comments:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'boldfont'),
            ),
            SizedBox(height: 10),
            isLoading
                ? Center(
                  child: Column(
                children: [
                      SizedBox(height: 50,),
                      Lottie.asset('assets/images/worldtry.json'),
                      
                    ],
                  ),
                )
                : Expanded(
                    child: ListView.builder(
                      
                      shrinkWrap: true,
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final comment = comments[index];
                        return Card(
                          margin: EdgeInsets.only(bottom: 10),
                          elevation: 4,
                          child: ListTile(
                            tileColor: Colors.white,
                            leading: Icon(Ionicons.chatbubble_ellipses, color: Colors.black),
                            title: Text(
                              comment['text'] != null ? HtmlUnescape().convert(comment['text']!.replaceAll(RegExp(r'<[^>]*>'), '')) : "No Comment",

                              style: TextStyle(fontSize: 16, fontFamily: 'boldfont'),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
