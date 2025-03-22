import 'package:flutter/material.dart';
import 'package:gyanganj/navigation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

class InterestsPage extends StatefulWidget {
  @override
  _InterestsPageState createState() => _InterestsPageState();
}

class _InterestsPageState extends State<InterestsPage> {
  final supabase = Supabase.instance.client;
  
  // Selected Interests Store Karne Ke Liye
  List<String> selectedInterests = [];

  // Categories List
  final List<String> categories = [
  'Technology', 'Science', 'Art', 'History', 'Health', 'Space', 'Education',
  'Finance', 'Sports', 'Travel', 'Music', 'Photography', 'Food', 'Movies',
  'Gaming', 'Fitness', 'Business', 'Politics', 'Literature', 'Psychology',
  'Coding', 'AI & Machine Learning', 'Philosophy', 'Entrepreneurship',
  'Environment', 'Self-Improvement', 'Fashion', 'Cars', 'Astrology',
  'Mythology', 'Cryptocurrency', 'Stocks & Trading', 'Startups',
  'Biology', 'Physics', 'Chemistry', 'Mathematics', 'Space Exploration', 
  'Robotics', 'Cybersecurity', 'Blockchain', 'Networking', 'Quantum Computing',
  'Economics', 'Marketing', 'Social Media', 'UX/UI Design', 'Web Development',
  'Mobile Development', 'AI Ethics', 'Neuroscience', 'Medicine', 'Climate Change',
  'Wildlife', 'Architecture', 'Storytelling', 'Meditation', 'Adventure Sports'
];



  // Interest Toggle Function
  void toggleInterest(String interest) {
    setState(() {
      if (selectedInterests.contains(interest)) {
        selectedInterests.remove(interest);
      } else {
        selectedInterests.add(interest);
      }
    });
  }

  // Interests Save Karne Ka Function
  Future<void> saveInterests() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    try {
      // Old interests delete karo
      await supabase.from('user_interests').delete().eq('user_id', userId);

      // Naye interests insert karo
      if (selectedInterests.isNotEmpty) {
        final List<Map<String, dynamic>> dataToInsert = selectedInterests.map((interest) => {
          'user_id': userId,
          'interest': interest,
        }).toList();

        await supabase.from('user_interests').upsert(dataToInsert);

        // Flutter Toast for better UI feedback
        Fluttertoast.showToast(
          msg: "✅ Interests Saved Successfully!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          
          fontSize: 16.0,
        );
      }
    } catch (e) {
      print('❌ Exception: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Select Your Interests',
          style: TextStyle(fontFamily: 'boldfont', fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
  padding: const EdgeInsets.all(16.0),
  child: Column(
    children: [
     

      // 🔥 Ye Wrap ke upar Expanded/SizedBox daal diya height constraint ke liye
      Expanded(
        child: SingleChildScrollView(
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: categories.map((category) {
              final isSelected = selectedInterests.contains(category);
              return GestureDetector(
                onTap: () => toggleInterest(category),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.black : Colors.white,
                    borderRadius: BorderRadius.circular(12), // Rounded rectangle
                    border: Border.all(color: Colors.black),
                  ),
                  child: Text(
                    category,
                    style: TextStyle(
                      fontFamily: 'boldfont',
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),

      SizedBox(height: 20),

      SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () async {
          await saveInterests(); // ✅ Pehle interests save honge

          // Fluttertoast.showToast(
          //   msg: "Interests Saved Successfully!",
          //   toastLength: Toast.LENGTH_SHORT,
          //   gravity: ToastGravity.BOTTOM,
          //   backgroundColor: Colors.black,
          //   textColor: Colors.white,
          // );

          // ✅ Interests save hone ke baad next screen pe navigate karna
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Navigation()), // 👈 Yaha NextScreen ka naam apne screen ke according update karna
          );
        },

          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white, // ✅ White background
            foregroundColor: Colors.black, // ✅ Black text
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: Colors.black), // ✅ Button border
            ),
          ),
          child: Text(
            'Save Interests',
            style: TextStyle(fontSize: 18, fontFamily: 'boldfont'),
          ),
        ),
      ),
    ],
  ),
),
    );
  }
}