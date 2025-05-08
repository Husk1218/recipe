import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe/common/api/fireAuth.dart';
import 'package:recipe/common/model/CreateEvent.dart';

class CreateEvent extends StatefulWidget {
  const CreateEvent({super.key});

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  TextEditingController titleController = TextEditingController();
  TextEditingController dropdownMenuController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController ingredientsController = TextEditingController();
  TextEditingController directionController = TextEditingController();

  bool ifSelectedAssetImage = false;
  String eventId = "";

  File? filePath;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    if (FirebaseAuth.instance.currentUser != null) {
      User? user = FirebaseAuth.instance.currentUser;
      var userInfo = await FireAuth.fetchUserInfo(user!.uid);
      setState(() {
        createEventModel.avatar = userInfo["image"] ?? "";
        createEventModel.userName = userInfo["name"] ?? "";
        createEventModel.email = userInfo["email"] ?? "";
        createEventModel.phoneNumber = userInfo["phoneNumber"] ?? "";
      });
    }
  }

  CreateEventModel createEventModel = CreateEventModel(
    title: "",
    category: "",
    createDate: 0,
    description: "",
    image: "",
    avatar: "",
    userName: "",
    email: '',
    phoneNumber: '',
    eventId: '',
    userId: '',
    ingredients: '',
    collections: [],
    direction: "",
  );

  Future createPost(File xfile) async {
    if (titleController.text.trim().isNotEmpty &&
        descriptionController.text.trim().isNotEmpty &&
        ingredientsController.text.trim().isNotEmpty &&
        directionController.text.trim().isNotEmpty &&
        createEventModel.category.isNotEmpty) {
      if (FirebaseAuth.instance.currentUser != null) {
        CollectionReference events =
            FirebaseFirestore.instance.collection('events');
        EasyLoading.show(status: 'loading...');
        User? user = FirebaseAuth.instance.currentUser;
        final ref = FirebaseStorage.instance
            .ref()
            .child('event_image')
            .child('${user!.uid}.jpg');
        await ref.putFile(File(xfile.path));
        final url = await ref.getDownloadURL();
        setState(() {
          createEventModel.title = titleController.text.trim();
          createEventModel.description = descriptionController.text.trim();
          createEventModel.image = url;
          createEventModel.eventId = events.doc().id;
          createEventModel.userId = user.uid;
          createEventModel.createDate = DateTime.now().millisecondsSinceEpoch;
          createEventModel.direction = directionController.text.trim();
          
        });

        await events
            .doc(createEventModel.eventId)
            .set(createEventModel.toJson())
            .then(
          (value) {
            print("User detail create success");
          },
        ).catchError(
          (error) {
            print("Failed to create user detail$error");
          },
        );
        EasyLoading.showToast("Create success");
        Navigator.of(context).pop();
      }
    } else {
      EasyLoading.showToast("Incomplete data");
    }
  }

  Future getImage() async {
    var image = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 50);
    print(filePath);
    setState(() {
      filePath = File(image!.path);
    });
    print(filePath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          child: SingleChildScrollView(
            child: Column(
              children: [
                //Event Title
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Event Title',
                      style: TextStyle(
                        color: Color(0xFF282828),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1,
                            strokeAlign: BorderSide.strokeAlignCenter,
                            color: Color(0xFFDDDDDD),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: TextField(
                        controller: titleController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 8),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 12),
                // Category
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Category',
                      style: TextStyle(
                        color: Color(0xFF282828),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 52,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10), 
                        border: Border.all(
                          color: const Color(0xFFDDDDDD),
                        ),
                      ),
                      child: DropdownMenu(
                        controller: dropdownMenuController,
                        onSelected: (value) {
                          print(value);
                          setState(() {
                            createEventModel.category = value;
                          });
                        },
                        width: MediaQuery.of(context).size.width - 56,
                        textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        inputDecorationTheme: const InputDecorationTheme(
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.only(bottom: 10, left: 8)),
                        dropdownMenuEntries: const <DropdownMenuEntry>[
                          DropdownMenuEntry(value: "Chinese", label: "Chinese"),
                          DropdownMenuEntry(
                              value: "American", label: "American"),
                          DropdownMenuEntry(value: "Mexican", label: "Mexican"),
                          DropdownMenuEntry(value: "French", label: "French"),
                          DropdownMenuEntry(value: "Indian", label: "Indian"),
                          DropdownMenuEntry(value: "African", label: "African"),
                          DropdownMenuEntry(value: "Other", label: "Other"),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                //Event Description
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'description',
                      style: TextStyle(
                        color: Color(0xFF282828),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            width: 1,
                            strokeAlign: BorderSide.strokeAlignCenter,
                            color: Color(0xFFDDDDDD),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: TextFormField(
                        controller: descriptionController,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 8),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ingredients',
                      style: TextStyle(
                        color: Color(0xFF282828),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            width: 1,
                            strokeAlign: BorderSide.strokeAlignCenter,
                            color: Color(0xFFDDDDDD),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: TextFormField(
                        controller: ingredientsController,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 8),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 12),
                //Event Photo
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Photo',
                      style: TextStyle(
                        color: Color(0xFF282828),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () async {
                        getImage();
                      },
                      child: Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 199,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                  width: 1,
                                  strokeAlign: BorderSide.strokeAlignCenter,
                                  color: Color(0xFFDDDDDD),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Icon(Icons.add_circle, size: 70),
                          ),
                          filePath == null
                              ? Container()
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    filePath!,
                                    width: double.infinity,
                                    height: 199,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ],
                      ),
                    )
                  ],
                ),

                //Event Direction
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'direction',
                      style: TextStyle(
                        color: Color(0xFF282828),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            width: 1,
                            strokeAlign: BorderSide.strokeAlignCenter,
                            color: Color(0xFFDDDDDD),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: TextFormField(
                        controller: directionController,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 8),
                        ),
                      ),
                    )
                  ],
                ), 
                const SizedBox(height: 12),     
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: const Text(
        'Create Event',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color(0xFF282828),
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      leading: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Container(
          width: 44,
          child: const Icon(
            Icons.arrow_back_sharp,
            color: Colors.black,
          ),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () async {
            if (filePath == null) {
              return EasyLoading.showToast("Please upload photo");
            } else {
              createPost(filePath!);
            }
          },
          child: Container(
            margin: const EdgeInsets.only(right: 16),
            child: Image.asset(
              "assets/create_post.png",
              width: 63,
              height: 28,
            ),
          ),
        ),
      ],
    );
  }
}
