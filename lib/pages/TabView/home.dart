import 'package:flutter/material.dart';
import 'package:recipe/pages/TabView/collection.dart';
import 'package:recipe/pages/TabView/event.dart';
import 'package:recipe/pages/TabView/profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    EventPage(),
    const Collection(),
    ProfilePage(),
  ];

  @override
  bool get wantKeepAlive => true;

  void onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  AppBar appBar() {
    return AppBar(
      title: const Text(
        'Events',
        style: TextStyle(
            color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      leading: GestureDetector(
        onTap: () {},
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: const Icon(
            Icons.menu,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  BottomNavigationBar navigationBar() {
    return BottomNavigationBar(
      type:
          BottomNavigationBarType.fixed, // This ensures all tabs are displayed.
      currentIndex: _currentIndex, // this will be set when a new tab is tapped
      onTap: onTap,
      selectedItemColor: Colors.orange[900],
      unselectedItemColor: Colors.grey[400],
      selectedFontSize: 12,
      iconSize: 24,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Event'),
        BottomNavigationBarItem(
            icon: Icon(Icons.collections_bookmark), label: 'Collection'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: IndexedStack(
        
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: navigationBar(),
    );
  }
}
