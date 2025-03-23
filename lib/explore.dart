import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ionicons/ionicons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'profile_page.dart';

class ExploreScreen extends StatefulWidget {
  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final FlutterTts flutterTts = FlutterTts();
  static List<Map<String, dynamic>> cachedArticles = [];
  static List<Map<String, dynamic>> trendingArticles = [];
  static List<Map<String, dynamic>> recommendedArticles = [];
  int currentIndex = 0;
  bool isLiked = false;
  bool isLoading = false;
  bool isFetchingMore = false;
  DateTime? articleDisplayTime;

  final List<String> topics = [
    // Updated list of 100 topics
    'Technology', 'Science', 'Art', 'History', 'Health', 'Space', 'Education',
    'Finance', 'Sports', 'Travel', 'Music', 'Photography', 'Food', 'Movies',
    'Gaming', 'Fitness', 'Business', 'Politics', 'Literature', 'Psychology',
    'Philosophy', 'Biology', 'Chemistry', 'Physics', 'Mathematics', 'Medicine',
    'Astronomy', 'Environment', 'Climate Change', 'Engineering', 'AI',
    'Machine Learning', 'Blockchain', 'Cybersecurity', 'Economics', 'Geography',
    'Sociology', 'Anthropology', 'Linguistics', 'Astronautics', 'Neuroscience',
    'Genetics', 'Architecture', 'Robotics', 'Ecology', 'Agriculture', 'Space Exploration',
    'Quantum Mechanics', 'Nanotechnology', 'Astrobiology', 'Meteorology',
    'Archaeology', 'Botany', 'Zoology', 'Geology', 'Paleontology', 'Anatomy',
    'Physiology', 'Pathology', 'Pharmacology', 'Microbiology', 'Virology',
    'Immunology', 'Endocrinology', 'Nutrition', 'Biochemistry', 'Cytology',
    'Histology', 'Parasitology', 'Mycology', 'Entomology', 'Marine Biology',
    'Ethology', 'Evolutionary Biology', 'Genomics', 'Proteomics', 'Bioinformatics',
    'Forensic Science', 'Toxicology', 'Epidemiology', 'Public Health', 'Nursing',
    'Dentistry', 'Pharmacy', 'Veterinary Medicine', 'Optometry', 'Audiology',
    'Speech-Language Pathology', 'Occupational Therapy', 'Physical Therapy',
    'Radiology', 'Oncology', 'Cardiology', 'Gastroenterology', 'Pulmonology',
    'Nephrology', 'Rheumatology', 'Dermatology', 'Ophthalmology', 'Pediatrics',
    'Geriatrics', 'Obstetrics', 'Gynecology', 'Urology', 'Hematology',
    'Neurology', 'Psychiatry', 'Surgery', 'Orthopedics', 'Anesthesiology',
    'Emergency Medicine', 'Critical Care Medicine', 'Pain Management',
    'Aerospace Engineering', 'Civil Engineering', 'Electrical Engineering',
    'Mechanical Engineering', 'Chemical Engineering', 'Materials Science',
    'Industrial Engineering', 'Environmental Engineering', 'Biomedical Engineering',
    'Software Engineering', 'Data Science', 'Statistics', 'Operations Research',
    'Logistics', 'Supply Chain Management', 'Human Resources', 'Marketing',
    'Entrepreneurship', 'Innovation', 'Corporate Finance', 'Investment Banking',
    'Venture Capital', 'Private Equity', 'Hedge Funds', 'Mutual Funds',
    'Real Estate', 'Insurance', 'Actuarial Science', 'Risk Management',
    'International Trade', 'E-commerce', 'Digital Marketing', 'Social Media Marketing',
    'Content Marketing', 'SEO', 'Public Relations', 'Corporate Communications',
    'Journalism', 'Broadcasting', 'Film Studies', 'Media Studies', 'Advertising',
    'Graphic Design', 'Industrial Design', 'Fashion Design', 'Interior Design',
    'Urban Planning', 'Landscape Architecture', 'Cultural Studies', 'Forestry'
  ];

  @override
  void initState() {
    super.initState();
    if (cachedArticles.isEmpty) {
      fetchArticles();
    } else {
      setState(() {
        isLoading = false;
      });
    }
    loadEngagementData();
  }

  Future<void> fetchArticles() async {
    if (isLoading || cachedArticles.isNotEmpty) return;
    setState(() => isLoading = true);

    List<Map<String, dynamic>> fetchedArticles = [];
    List<Future<http.Response>> requests = topics.map((topic) {
      final url = 'https://en.wikipedia.org/api/rest_v1/page/summary/$topic';
      return http.get(Uri.parse(url));
    }).toList();

    List<http.Response> responses = await Future.wait(requests);

    for (var response in responses) {
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['title'] != null && data['extract'] != null) {
          fetchedArticles.add({
            'title': data['title'],
            'content': data['extract'],
            'thumbnail': data['thumbnail'] != null
                ? data['thumbnail']['source']
                : 'https://upload.wikimedia.org/wikipedia/commons/6/63/Wikipedia-logo.png',
            'article_id': data['title'].replaceAll(' ', '_'),
          });
        }
      }
    }

    await fetchTrendingArticles();
    await fetchRecommendedArticles();

    if (mounted) {
      setState(() {
        cachedArticles = fetchedArticles;
        isLoading = false;
      });
    }
  }

  Future<void> fetchTrendingArticles() async {
    final url = 'https://wikimedia.org/api/rest_v1/metrics/pageviews/top/en.wikipedia/all-access/last-hour';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final articles = data['items'][0]['articles'];

        List<String> trendingArticleTitles = articles
            .map<String>((article) => article['article'].replaceAll('_', ' '))
            .toList();

        List<Map<String, dynamic>> trending = cachedArticles
            .where((article) => trendingArticleTitles.contains(article['title']))
            .toList();

        if (mounted) {
          setState(() {
            trendingArticles = trending;
          });
        }
      } else {
        print('Failed to fetch trending articles: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching trending articles: $e');
    }
  }

  Future<void> fetchRecommendedArticles() async {
    final prefs = await SharedPreferences.getInstance();
    final engagementData = prefs.getStringList('engagement') ?? [];

    List<String> topicsOfInterest = engagementData
        .map((item) => json.decode(item)['article_id'] as String)
        .toList();

    List<Map<String, dynamic>> recommended = [];

    for (var topic in topicsOfInterest) {
      final url = 'https://en.wikipedia.org/api/rest_v1/page/related/$topic';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['pages'] != null) {
          for (var page in data['pages']) {
            recommended.add({
              'title': page['title'],
              'content': page['extract'],
              'thumbnail': page['thumbnail'] != null
                  ? page['thumbnail']['source']
                  : 'https://upload.wikimedia.org/wikipedia/commons/6/63/Wikipedia-logo.png',
              'article_id': page['title'].replaceAll(' ', '_'),
            });
          }
        }
      }
    }

    if (mounted) {
      setState(() {
        recommendedArticles = recommended;
      });
    }
  }

  void fetchMoreArticles() async {
    if (isFetchingMore) return;
    setState(() => isFetchingMore = true);
    await fetchArticles();
    if (mounted) {
      setState(() => isFetchingMore = false);
    }
  }

  void saveArticle(int index) async {
    final supabase = Supabase.instance.client;
    await supabase.from('saved_works').insert({
      'user_id': supabase.auth.currentUser?.id,
      'article_id': cachedArticles[index]['article_id'],
      'title': cachedArticles[index]['title'],
      'content': cachedArticles[index]['content'],
      'thumbnail': cachedArticles[index]['thumbnail'],
    });

    Fluttertoast.showToast(
      msg: "Article Saved ✅",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      fontSize: 16.0,
    );
  }

  void trackEngagement(int index) async {
    if (articleDisplayTime != null) {
      final engagementTime = DateTime.now().difference(articleDisplayTime!).inSeconds;
      final prefs = await SharedPreferences.getInstance();
      final engagementData = prefs.getStringList('engagement') ?? [];

      engagementData.add(json.encode({
        'article_id': cachedArticles[index]['article_id'],
        'engagement_time': engagementTime,
      }));

      await prefs.setStringList('engagement', engagementData);
    }
    setState(() {
      articleDisplayTime = DateTime.now();
    });
  }

  void loadEngagementData() async {
    final prefs = await SharedPreferences.getInstance();
    final engagementData = prefs.getStringList('engagement') ?? [];

    if (engagementData.isNotEmpty) {
      await fetchRecommendedArticles();
    }
  }

  void toggleLike() {
    setState(() => isLiked = !isLiked);
  }

  void shareArticle(int index) {
    Share.share('${cachedArticles[index]['title']}\n${cachedArticles[index]['content']}');
  }

  void playAudio(String text) async {
    await flutterTts.stop();
    await flutterTts.speak(text);
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
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
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
          ),
        ],
      ),
      body: isLoading && cachedArticles.isEmpty
          ? Center(
              child: Column(
                children: [
                  SizedBox(height: 50),
                  Lottie.asset('assets/images/worldtry.json'),
                ],
              ),
            )
          : Swiper(
              itemCount: cachedArticles.length + recommendedArticles.length,
              loop: true,
              onIndexChanged: (index) {
                setState(() {
                  currentIndex = index;
                  isLiked = false;
                });
                if (index == cachedArticles.length + recommendedArticles.length - 1) {
                  fetchMoreArticles();
                }
                flutterTts.stop();
                trackEngagement(index);
              },
              itemBuilder: (context, index) {
                final article = index < cachedArticles.length
                    ? cachedArticles[index]
                    : recommendedArticles[index - cachedArticles.length];

                return GestureDetector(
                  onDoubleTap: toggleLike,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        image: NetworkImage(article['thumbnail']),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.4),
                          BlendMode.darken,
                        ),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.all(12.0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  article['title'],
                                  style: TextStyle(
                                    fontSize: 27,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'boldfont',
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                Text(
                                  article['content'],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.justify,
                                  maxLines: 15,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(icon: Icon(Ionicons.heart, color: isLiked ? Colors.redAccent : Colors.white), onPressed: toggleLike),
                              IconButton(icon: Icon(Ionicons.share_social, color: Colors.white), onPressed: () => shareArticle(index)),
                              IconButton(icon: Icon(Ionicons.bookmark, color: Colors.white), onPressed: () => saveArticle(index)),
                              IconButton(icon: Icon(Ionicons.mic, color: Colors.white), onPressed: () => playAudio(article['content'])),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              scrollDirection: Axis.vertical,
            ),
    );
  }
}
