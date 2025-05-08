import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recipe/common/Global/global.dart';
import 'package:recipe/common/model/CreateEvent.dart';
import 'package:recipe/pages/TabView/detail.dart';

class Collection extends StatefulWidget {
  const Collection({super.key});

  @override
  _CollectionState createState() => _CollectionState();
}

class _CollectionState extends State<Collection> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  AppBar appBar() {
    return AppBar(
      title: const Text(
        'Collection',
        style: TextStyle(
            color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: _buildPostsTab(),
    );
  }

  Widget _buildPostsTab() {
    User? user = FirebaseAuth.instance.currentUser;
    return user == null
        ? Center()
        : StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('events')
                .where('collections', arrayContains: user!.uid)
                .snapshots(),
            builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final data = snapshot.data!.docs;
                return Container(
                  padding: const EdgeInsets.only(left: 16),
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, index) => Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => Detail(
                                  detailData: CreateEventModel(
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
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Image.network(
                                        data[index]["avatar"],
                                        width: 48,
                                        height: 48,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width -
                                          110,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                data[index]["title"],
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            TimeUtils.formatTimeWeekly(
                                                data[index]["createDate"]),
                                            style: const TextStyle(
                                              color: Color(0xFF595959),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            data[index]["description"],
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.grey[800]),
                                            maxLines: 5,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 12),
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: CachedNetworkImage(
                                              imageUrl: data[index]["image"],
                                              width: double.infinity,
                                              height: 140,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          
                                          Text(
                                            data[index]["direction"],
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.grey[800]),
                                            maxLines: 5,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 12),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        index != data.length - 1
                            ? const Divider()
                            : const SizedBox(),
                      ],
                    ),
                  ),
                );
              }
            },
          );
  }
}
