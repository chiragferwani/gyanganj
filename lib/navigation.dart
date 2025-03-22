import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gyanganj/home.dart';
import 'package:gyanganj/interests.dart';
import 'package:gyanganj/profile_page.dart';
import 'package:gyanganj/saved_articles.dart';
import 'package:gyanganj/search.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:gyanganj/explore.dart';

class Navigation extends StatelessWidget {
  const Navigation({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    return Scaffold(
        // appBar: AppBar(
        //   title: const Text('ProfitPulse', 
        //   style: TextStyle(
        //     fontFamily: 'BoldFont', 
        //     fontSize: 24,
        //     color: Colors.white),),
        //   leading: Icon(Ionicons.cloud_done_outline, color: Colors.white,),
        //   backgroundColor: Color.fromARGB(255, 142, 63, 255),
        //   centerTitle: true,
        //   actions: [
        //     IconButton(
        //       onPressed: () => Navigator.push(
        //         context, 
        //         MaterialPageRoute(builder: (context) => ProjectDetails())
        //       ),
        //       icon: const Icon(Ionicons.settings_outline, color: Colors.white,),
        //     ),
        //   ],
        // ),
      //   appBar: PreferredSize(
      //   preferredSize: Size.fromHeight(160), // Adjusted for larger AppBar
      //   child: Container(
      //     decoration: BoxDecoration(
      //       color: Color.fromARGB(255, 142, 63, 255),
      //       borderRadius: BorderRadius.only(
      //         bottomLeft: Radius.circular(20),
      //         bottomRight: Radius.circular(20),
      //       ),
      //     ),
      //     child: SafeArea(
      //       child: Padding(
      //         padding: const EdgeInsets.symmetric(horizontal: 20),
      //         child: 
              
      //         Column(
                
      //           crossAxisAlignment: CrossAxisAlignment.start,
                
      //           children: [
      //             SizedBox(height: 20,),
      //             Row(
      //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //               children: [
      //                 Row(
      //                   children: [
      //                     // Image before "Welcome Chirag Ferwani"
      //                     CircleAvatar(
      //                       radius: 24,
      //                       backgroundImage: AssetImage('assets/images/profile.png'), // Replace with your image
      //                     ),
      //                     SizedBox(width: 10),
      //                     Column(
      //                       crossAxisAlignment: CrossAxisAlignment.start,
      //                       children: [
      //                         Text(
      //                           'Greetings',
      //                           style: TextStyle(color: Colors.white, fontSize: 16),
      //                         ),
      //                         SizedBox(height: 3),
      //                         Text(
      //                           'Chirag Ferwani',
      //                           style: TextStyle(
      //                             color: Colors.white,
      //                             fontSize: 22,
      //                             fontWeight: FontWeight.bold,
      //                           ),
      //                         ),
      //                       ],
      //                     ),
      //                   ],
      //                 ),
      //                 // Save Icon
      //                 IconButton(
      //                   onPressed: () {
      //                     // Action for Save Icon
      //                   },
      //                   icon: Icon(CupertinoIcons.bookmark, color: Colors.white, size: 28),
      //                 ),
      //               ],
      //             ),
      //             SizedBox(height: 10),
      //             // Welcome to UrbanRoots Section with city icon
      //             Container(
      //               width: double.infinity,
      //               child: ElevatedButton.icon(
      //                 onPressed: () {},
      //                 style: ElevatedButton.styleFrom(
      //                   backgroundColor: Colors.white,
      //                   shape: RoundedRectangleBorder(
      //                     borderRadius: BorderRadius.circular(20),
      //                   ),
      //                 ),
      //                 icon: Icon(Icons.location_city, color: const Color.fromARGB(255, 0, 0, 0)),
      //                 label: Padding(
      //                   padding: const EdgeInsets.symmetric(horizontal: 10),
      //                   child: Text(
      //                     'Welcome to UrbanRoots',
      //                     style: TextStyle(color: Colors.black, fontSize: 18, fontFamily: 'BoldFont'),
      //                   ),
      //                 ),
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
        bottomNavigationBar: Obx(
        () => CurvedNavigationBar(
          backgroundColor: Colors.white,
          color: Colors.black,
          buttonBackgroundColor: Colors.grey.shade800,
          height: 60,
          index: controller.selectedIndex.value,
          onTap: (index) => controller.selectedIndex.value = index,
          items: const [
            Icon(Ionicons.home_outline, color: Colors.white),
            Icon(Ionicons.search, color: Colors.white),
            Icon(Ionicons.globe_outline, color: Colors.white),
            Icon(Ionicons.bookmark_outline, color: Colors.white),
            Icon(Ionicons.person_outline, color: Colors.white),
          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  final screens = [
    HomeScreen(),
    SearchPage(),
    ExploreScreen(),
    SavedArticlesScreen(),
    ProfilePage(),
    // ScoutScreen(),
    // BookingScreen(),
    // GroupsScreen(),
    // const ProfilePage(),
  ];
}