import 'package:flutter/material.dart';

class ProjectInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Project Info', style: TextStyle(fontFamily: 'boldfont')),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              'assets/images/logo.png', // Apne project ka logo yaha dal
              height: 200,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'GyanGanj',
            style: TextStyle(fontSize: 24, fontFamily: 'boldfont'),
          ),
          SizedBox(height: 15),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Gyanganj is a scroll-based knowledge platform that transforms Wikipedia content into a concise and engaging format. Users can search for topics, explore trending posts, and personalize their feed by selecting interest categories. The app features smooth vertical scrolling for seamless browsing and a Saved Works section for bookmarking articles.',
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 16, fontFamily: 'boldfont'),
            ),
          ),
          SizedBox(height: 15,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'For a richer experience, Gyanganj includes an audio feature to listen to summaries and a share option to spread knowledge effortlessly. With its intuitive design, Gyanganj makes learning fast, interactive, and accessible for everyone. 🚀',
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 16, fontFamily: 'boldfont'),
            ),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Text(
              'V 1.0.0',
              style: TextStyle(fontSize: 16, fontFamily: 'boldfont'),
            ),
          ),
        ],
      ),
    );
  }
}
