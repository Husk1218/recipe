import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:recipe/common/Global/global.dart';
import 'package:recipe/common/model/CreateEvent.dart';

class Detail extends StatefulWidget {
  final CreateEventModel detailData;
  const Detail({super.key, required this.detailData});

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  bool isCollection = false;

  @override
  void initState() {
    super.initState();
    getCollectionStatus();
  }

  getCollectionStatus() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }
    try {
      EasyLoading.show(status: 'loading...');
      DocumentSnapshot documentSnapshot = await firestore
          .collection('events')
          .doc(widget.detailData.eventId)
          .get();
      if (documentSnapshot.exists) {
        Map<String, dynamic> userData =
            documentSnapshot.data() as Map<String, dynamic>;
        List<dynamic> lists = userData["collections"];
        lists.contains(user.uid);
        print(lists.contains(user.uid) ? "Favorited" : "Not Favorited");
        if (lists.contains(user.uid)) {
          setState(() {
            isCollection = true;
          });
        } else {
          setState(() {
            isCollection = false;
          });
        }
        EasyLoading.dismiss();
      } else {
        EasyLoading.dismiss();
        print('No such collections!');
        setState(() {
          isCollection = false;
        });
      }
    } catch (e) {
      EasyLoading.dismiss();
      print(e);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  AppBar appBar() {
    return AppBar(
      title: const Text(
        'Detail',
        style: TextStyle(
            color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      actions: [
        InkWell(
          onTap: () async {
            User? user = FirebaseAuth.instance.currentUser;
            if (user == null) {
              EasyLoading.showToast("Please login!");
            } else {
              if (isCollection) {
                CollectionReference events =
                    FirebaseFirestore.instance.collection('events');
                widget.detailData.collections.remove(user.uid);
                await events
                    .doc(widget.detailData.eventId)
                    .set(widget.detailData.toJson())
                    .then((value) {
                  EasyLoading.showToast("Cancel successful!");
                  getCollectionStatus();
                });
              } else {
                CollectionReference events =
                    FirebaseFirestore.instance.collection('events');
                widget.detailData.collections.add(user.uid);
                await events
                    .doc(widget.detailData.eventId)
                    .set(widget.detailData.toJson())
                    .then((value) {
                  EasyLoading.showToast("Collection successful!");
                  getCollectionStatus();
                });
              }
            }
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Icon(
              Icons.collections_bookmark_outlined,
              color: isCollection ? Colors.orange : Colors.black,
            ),
          ),
        )
      ],
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
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network(
                    widget.detailData.avatar,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 110,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.detailData.title,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        TimeUtils.formatTimeWeekly(
                            widget.detailData.createDate),
                        style: const TextStyle(
                          color: Color(0xFF595959),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.detailData.description,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey[800]),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.detailData.ingredients,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange[800]),
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: widget.detailData.image,
                          width: double.infinity,
                          height: 140,
                          fit: BoxFit.cover,
                        ),
                      ),
                       Text(
                        widget.detailData.direction,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey[800]),
                      ),
                      const SizedBox(height: 6),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
