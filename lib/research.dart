import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:gyanganj/navigation.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottie/lottie.dart';

void main() {
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: ResearchScreen()));
}

class ResearchScreen extends StatefulWidget {
  @override
  _ResearchScreenState createState() => _ResearchScreenState();
}

class _ResearchScreenState extends State<ResearchScreen> {
  List<Map<String, dynamic>> researchPapers = [];
  List<Map<String, dynamic>> filteredPapers = [];
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  bool isError = false;
  String errorMessage = "";
  String searchQuery = "AI"; // Default topic

  @override
  void initState() {
    super.initState();
    fetchResearchPapers();
  }

  Future<void> fetchResearchPapers() async {
    setState(() {
      isLoading = true;
      isError = false;
      errorMessage = "";
    });

    final String apiUrl =
        "https://api.semanticscholar.org/graph/v1/paper/search?query=$searchQuery&fields=title,authors,year,abstract,url";

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        List<dynamic> papers = data["data"] ?? [];

        setState(() {
          researchPapers = papers.map((paper) => {
                "title": paper["title"] ?? "No Title",
                "authors": (paper["authors"] as List?)
                        ?.map((a) => a["name"])
                        .join(", ") ??
                    "Unknown",
                "year": (paper["year"]?.toString() ?? "Unknown"),
                "abstract": paper["abstract"] ?? "Abstract not available",
                "url": paper["url"] ?? ""
              }).toList();
          filteredPapers = researchPapers;
        });
      } else {
        throw Exception("API returned status code ${response.statusCode}");
      }
    } catch (e) {
      setState(() {
        isError = true;
        errorMessage = "There are no research papers on this.";
      });
      print("Error: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void searchForPapers() {
    if (searchController.text.isEmpty) {
      setState(() {
        searchQuery = "AI"; // Default search
      });
    } else {
      setState(() {
        searchQuery = searchController.text;
      });
    }
    fetchResearchPapers();
  }

  void sharePaper(String title, String url) {
    Share.share("$title\nRead more: $url");
  }

  void showPaperDetails(BuildContext context, Map<String, dynamic> paper) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          color: Colors.white,
          child: Padding(
            
            padding: EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          paper["title"],
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'boldfont'),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Ionicons.share_social),
                        onPressed: () => sharePaper(paper["title"], paper["url"]),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text("Authors: ${paper["authors"]}", style: TextStyle(fontFamily: 'boldfont'), textAlign: TextAlign.justify,),
                  SizedBox(height: 5),
                  Text("Year: ${paper["year"]}", style: TextStyle(fontFamily: 'boldfont'),),
                  SizedBox(height: 10),
                  Text("Abstract:", style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.justify,),
                  SizedBox(height: 5),
                  Text(paper["abstract"], textAlign: TextAlign.justify,),
                ],
              ),
            ),
          ),
        );
      },
    );
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
        title: Text("Research", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontFamily: 'boldfont')),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: "Search Scholar",
                      labelStyle: TextStyle(fontFamily: 'boldfont'),
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
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: searchForPapers,
                  icon: Icon(Ionicons.school, color: Colors.black), // Search Icon
                  label: Text(
                    "Search",
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

              ],
            ),
          ),
          isLoading
              ? Center(
                child: Column(
                children: [
                      SizedBox(height: 50,),
                      Lottie.asset('assets/images/worldtry.json'),
                      
                    ],
                  ),
                )
              : isError
                  ? Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Icon(Icons.error, color: Colors.red, size: 50),
                            SizedBox(height: 10),
                            Text(errorMessage, textAlign: TextAlign.center),
                            SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: fetchResearchPapers,
                              child: Text("Retry", style: TextStyle(color: Colors.black, fontFamily: 'boldfont')),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: filteredPapers.length,
                        itemBuilder: (context, index) {
                          final paper = filteredPapers[index];
                          return ListTile(
                            title: Text(paper["title"], maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: 'boldfont'),),
                            subtitle: Text(paper["authors"], maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: 'boldfont'), textAlign: TextAlign.justify,),
                            onTap: () => showPaperDetails(context, paper),
                          );
                        },
                      ),
                    ),
        ],
      ),
    );
  }
}
