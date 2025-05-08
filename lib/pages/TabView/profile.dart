import 'dart:io';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe/common/Global/global.dart';
import 'package:recipe/common/api/fireAuth.dart';
import 'package:recipe/common/model/CreateEvent.dart';
import 'package:recipe/common/model/User.dart';
import 'package:recipe/pages/TabView/detail.dart';
import 'package:recipe/pages/login/login_view.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isEditMode = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  UserModelInfo userModelInfo = UserModelInfo(
      name: "",
      email: "",
      school: "",
      phoneNumber: "",
      bio: "",
      userAvatar: "");

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _schoolController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _nickController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData();
    _tabController = TabController(length: 2, vsync: this);
  }

  void loadData() async {
    EasyLoading.show(status: 'loading...');
    if (FirebaseAuth.instance.currentUser != null) {
      User? user = FirebaseAuth.instance.currentUser;
      var userInfo = await FireAuth.fetchUserInfo(user!.uid);
      EasyLoading.dismiss();
      setState(() {
        _nickController.text = userInfo["nickName"] ?? "";
        _phoneController.text = userInfo["phoneNumber"] ?? "";
        _schoolController.text = userInfo["school"] ?? "";
        _bioController.text = userInfo["bio"] ?? "";
        _emailController.text = userInfo['email'] ?? '';
        userModelInfo = UserModelInfo(
            name: userInfo["nickName"] ?? " ",
            email: userInfo['email'] ?? " ",
            school: userInfo["school"] ?? " ",
            phoneNumber: userInfo["phoneNumber"] ?? " ",
            bio: userInfo["bio"] ?? " ",
            userAvatar: userInfo["image"] ?? " ");
      });
    } else {
      EasyLoading.dismiss();
    }
  }

  Future getImage() async {
    var image = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 50);

    if (FirebaseAuth.instance.currentUser != null) {
      User? user = FirebaseAuth.instance.currentUser;
      final ref = FirebaseStorage.instance
          .ref()
          .child('user_image')
          .child('${user!.uid}.jpg');
      EasyLoading.show(status: 'loading...');

      await ref.putFile(File(image!.path));

      final url = await ref.getDownloadURL();
      // final url = "https://picsum.photos/200/300";

      await FireAuth.updateUserInfo(
          user.uid,
          _nickController.text.trim(),
          _phoneController.text.trim(),
          _schoolController.text.trim(),
          _bioController.text.trim(),
          _emailController.text.trim(),
          url);
      loadData();
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _schoolController.dispose();
    _bioController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  AppBar appBar() {
    return AppBar(
      title: const Text(
        'Profile',
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
    );
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return MediaQuery.removePadding(
      removeTop: true,
      context: context,
      child: Scaffold(
        // appBar: appBar(),
        key: _scaffoldKey,
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
        body: user == null
            ? InkWell(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const LoginView(),
                      ),
                      (route) => false);
                },
                child: const Center(
                  child: Text(
                    "please login",
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            : Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 250,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        userModelInfo.userAvatar.trim() != ""
                            ? Stack(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: userModelInfo.userAvatar,
                                    width: MediaQuery.of(context).size.width,
                                    height: 250,
                                    fit: BoxFit.cover,
                                  ),
                                  BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 3.0, sigmaY: 3.0),
                                    child: Container(
                                      width: double.infinity,
                                      height: 250,
                                      color: Colors.black.withOpacity(0.2),
                                    ),
                                  ),
                                ],
                              )
                            : Container(
                                width: double.infinity,
                                height: 250,
                                color: Colors.orange[800],
                              ),
                        Column(
                          children: [
                            SizedBox(
                                height:
                                    MediaQuery.of(context).padding.top + 30),
                            InkWell(
                              onTap: () {
                                getImage();
                              },
                              child: CircleAvatar(
                                radius: 50,
                                backgroundImage:
                                    userModelInfo.userAvatar.trim() != ""
                                        ? NetworkImage(userModelInfo.userAvatar)
                                        : const NetworkImage(
                                            'https://via.placeholder.com/150'),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              userModelInfo.name,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ],
                    ),
                  ),
                  TabBar(
                    controller: _tabController,
                    labelColor: Colors.orange[800],
                    indicatorColor: Colors.orange[800],
                    unselectedLabelColor: Colors.orange[100],
                    labelStyle: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                    unselectedLabelStyle: const TextStyle(fontSize: 16),
                    tabs: const [
                      Tab(text: 'About'),
                      Tab(text: 'Posts'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildAboutTab(),
                        _buildPostsTab(),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildAboutTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Email
          _isEditMode
              ? TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                  keyboardType: TextInputType.emailAddress,
                )
              : _buildDetailRow('Email', userModelInfo.email),
          const SizedBox(height: 10),
          // Nick
          _isEditMode
              ? TextFormField(
                  controller: _nickController,
                  decoration: const InputDecoration(
                    labelText: 'Nick',
                    // ... add other decoration properties ...
                  ),
                )
              : _buildDetailRow('Nick', userModelInfo.name),
          const SizedBox(height: 10),
          // Phone
          _isEditMode
              ? TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone',
                    // ... add other decoration properties ...
                  ),
                  keyboardType: TextInputType.phone,
                )
              : _buildDetailRow('Phone', userModelInfo.phoneNumber),
          const SizedBox(height: 10),
          // School
          _isEditMode
              ? TextFormField(
                  controller: _schoolController,
                  decoration: const InputDecoration(
                    labelText: 'School',
                    // ... add other decoration properties ...
                  ),
                )
              : _buildDetailRow('School', userModelInfo.school),
          const SizedBox(height: 10),
          // Bio
          _isEditMode
              ? TextFormField(
                  controller: _bioController,
                  decoration: const InputDecoration(
                    labelText: 'Bio',
                    // ... add other decoration properties ...
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                )
              : _buildDetailRow('Bio', userModelInfo.bio),
          const SizedBox(height: 20),
          _isEditMode
              ? ElevatedButton(
                  onPressed: () async {
                    // Save the updated info
                    if (FirebaseAuth.instance.currentUser != null) {
                      User? user = FirebaseAuth.instance.currentUser;
                      await FireAuth.updateUserInfo(
                          user!.uid,
                          _nickController.text.trim(),
                          _phoneController.text.trim(),
                          _schoolController.text.trim(),
                          _bioController.text.trim(),
                          _emailController.text.trim(),
                          userModelInfo.userAvatar);
                      setState(() {
                        _isEditMode = false;
                      });
                      loadData();
                    } else {
                      print("No user log in");
                    }
                  },
                  child: const Text('Save Changes'),
                )
              : IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    setState(() {
                      _isEditMode = true;
                    });
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String title, String content) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 2,
              child:
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 3, child: Text(content)),
        ],
      ),
    );
  }

  Widget _buildPostsTab() {
    User? user = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('events')
          .where('userId', isEqualTo: user!.uid)
          .snapshots(),
      builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
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
                      padding: EdgeInsets.symmetric(vertical: 24),
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
                              SizedBox(width: 20),
                              Container(
                                width: MediaQuery.of(context).size.width - 110,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                        InkWell(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return CupertinoAlertDialog(
                                                  title: Text('Delete post?'),
                                                  actions: [
                                                    CupertinoDialogAction(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: const Text(
                                                        'Cancel',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                    CupertinoDialogAction(
                                                      onPressed: () async {
                                                        await data[index]
                                                            .reference
                                                            .delete();
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text(
                                                        'Delete',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .orange[800]),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: const Icon(
                                            Icons.delete_outline_outlined,
                                            color: Color(0xFF595959),
                                          ),
                                        )
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
                                      borderRadius: BorderRadius.circular(10),
                                      child: CachedNetworkImage(
                                        imageUrl: data[index]["image"],
                                        width: double.infinity,
                                        height: 140,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    
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
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  index != data.length - 1 ? const Divider() : const SizedBox(),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
