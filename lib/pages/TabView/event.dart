import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recipe/common/Global/global.dart';
import 'package:recipe/common/api/fireAuth.dart';
import 'package:recipe/common/model/CreateEvent.dart';
import 'package:recipe/pages/TabView/create_event.dart';
import 'package:recipe/pages/TabView/detail.dart';
import 'package:recipe/pages/login/login_view.dart';

class EventPage extends StatefulWidget {
  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController searchController = TextEditingController();

  int selectedIndex = 0;
  String categoryStr = "All";
  String userName = "";
  String keyword = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      key: _scaffoldKey,
      body: eventPageBody(),
      drawer: Drawer(
        child: ListView(
          reverse: true,
          children: [
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sign Out'),
              onTap: () async {
                FireAuth.signOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => LoginView(),
                    ),
                    (route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: const Text(
        'Event',
        style: TextStyle(
            color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      leading: GestureDetector(
        onTap: () {
          _scaffoldKey.currentState?.openDrawer();
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: const Icon(
            Icons.menu,
            color: Colors.black,
          ),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => const CreateEvent(),
              ),
            );
          },
          child: const SizedBox(
            width: 44,
            child: Icon(
              Icons.add_circle_sharp,
              color: Colors.black,
            ),
          ),
        )
      ],
    );
  }

  SingleChildScrollView eventPageBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(50)),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      const Icon(Icons.search, size: 22),
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          decoration: const InputDecoration(
                            hintText: "Please insert recipe title",
                            hintStyle: TextStyle(fontSize: 18),
                            border: InputBorder.none,
                          ),
                          onSubmitted: (value) {
                            setState(() {
                              keyword = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),
                SizedBox(
                  height: 28,
                  child: category(),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: StreamBuilder(
            stream: keyword.trim().isEmpty
             ? categoryStr == "All"
            ? FirebaseFirestore.instance
            .collection('events')
            .snapshots()
        : FirebaseFirestore.instance
            .collection('events')
            .where('category', isEqualTo: categoryStr)
            .snapshots()
    : FirebaseFirestore.instance
        .collection('events')
        .orderBy("title")
        .startAt([keyword]).endAt([keyword + '\uf8ff'])
        .snapshots(),
  builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
      return Center(child: Text('Error: ${snapshot.error}'));
    } else if (snapshot.data!.docs.isEmpty) {
      return Container(
          margin: const EdgeInsets.only(top: 100),
          child: const Text('No data'));
    } else {
      final data = snapshot.data!.docs;
      return SizedBox(
        height: MediaQuery.of(ctx).size.height * 0.7,
        child: ListView.builder(
          itemCount: data.length,
          itemBuilder: (BuildContext context, index) {
            Widget eventCard = EventCard(
              eventData: CreateEventModel(
                title: data[index]["title"],
                category: data[index]["category"],
                createDate: data[index]["createDate"],
                description: data[index]["description"],
                image: data[index]["image"],
                avatar: data[index]["avatar"],
                userName: data[index]["userName"],
                email: data[index]["email"],
                phoneNumber: data[index]["phoneNumber"],
                eventId: data[index]["eventId"],
                userId: data[index]["userId"],
                ingredients: data[index]["ingredients"],
                collections: data[index]["collections"],
                direction: data[index]["direction"],
              ),
            );
            return eventCard;
          },
        ),
      );
    }
  },
)
,
          ),
        ],
      ),
    );
  }

  ListView category() {
    List<Category> categories = [
      Category(icon: Icons.all_inclusive, title: 'All'),
      Category(icon: Icons.restaurant, title: 'Chinese'),
      Category(icon: Icons.restaurant, title: 'American'),
      Category(icon: Icons.restaurant, title: 'Mexican'),
      Category(icon: Icons.restaurant, title: 'French'),
      Category(icon: Icons.restaurant, title: 'Indian'),
      Category(icon: Icons.restaurant, title: 'African'),
      Category(icon: Icons.restaurant, title: 'Other')
    ];
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final cat = categories[index];
        return Row(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                  categoryStr = cat.title;
                  keyword = "";
                  searchController.text = "";
                });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                      width: 1,
                      color:
                          selectedIndex == index ? Colors.orange : Colors.grey),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      cat.icon,
                      size: 20,
                      color: Colors.orange[900],
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      cat.title,
                      style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.normal),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
          ],
        );
      },
    );
  }
}

class Category {
  final IconData icon;
  final String title;
  final Color iconColor;

  Category(
      {required this.icon,
      required this.title,
      this.iconColor = Colors.orange});
}

class EventCard extends StatefulWidget {
  final CreateEventModel eventData;
  EventCard({required this.eventData});

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) =>
                Detail(detailData: widget.eventData),
          ),
        );
      },
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 82,
                height: 82,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: widget.eventData.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      TimeUtils.formatTimeWeekly(widget.eventData.createDate),
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey[800]),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      widget.eventData.title,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      widget.eventData.description,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey[800]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      widget.eventData.direction,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey[800]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
