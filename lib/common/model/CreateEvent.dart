class CreateEventModel {
  String title;
  String category;
  int createDate;
  String description;
  String ingredients;
  String image;
  String avatar;
  String userName;
  String email;
  String phoneNumber;
  String eventId;
  String userId;
  String direction;
  List<dynamic> collections;
  

  CreateEventModel({
    required this.title,
    required this.category,
    required this.createDate,
    required this.description,
    required this.ingredients,
    required this.image,
    required this.avatar,
    required this.userName,
    required this.email,
    required this.phoneNumber,
    required this.eventId,
    required this.userId,
    required this.collections,
    required this.direction,
  });

  Map<String, dynamic> toJson() => {
        "title": title,
        "category": category,
        "createDate": createDate,
        "description": description,
        "ingredients": ingredients,
        "image": image,
        "avatar": avatar,
        "userName": userName,
        "email": email,
        "phoneNumber": phoneNumber,
        "eventId": eventId,
        "userId": userId,
        "collections": collections,
        "direction": direction,
      };
}

var initCreateEventModel = CreateEventModel(
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
