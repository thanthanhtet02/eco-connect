import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import '../features_as_tabs/news_feed_tab.dart';
import '../features_as_tabs/popular_tab.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _tabController; //assign for later use of tab Controller

  @override
  void initState() {
    //one time set up
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
    ); //initialize and sync the tab for transitions
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose(); //dispose to free up space
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: RichText(
          text: const TextSpan(
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            children: [
              TextSpan(text: 'Eco', style: TextStyle(color: Color(0xFF57DE45))),
              TextSpan(text: 'Connect', style: TextStyle(color: Colors.black)),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.black, size: 38),
            onPressed: () => Navigator.pushNamed(context, '/search'),
          ),
          IconButton(
            icon: Icon(Icons.settings, color: Colors.black, size: 38),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.green,
          unselectedLabelColor: Colors.black,
          indicatorColor: Colors.green,
          labelStyle: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold, 
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
          tabs: const [Tab(text: 'NewsFeed'), Tab(text: 'Popular')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [NewsFeedTab(), PopularTab()],
      ),

      bottomNavigationBar: BottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              // currentt home page
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/create');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/profile');
              break;
          }
        },
      ),
    );
  }
}
