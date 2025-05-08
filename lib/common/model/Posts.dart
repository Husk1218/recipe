class PostModelInfo {
  String avatar;
  String content;
  int createTime;
  String image;
  String name;
  String uid;

  PostModelInfo({
    required this.avatar,
    required this.content,
    required this.createTime,
    required this.image,
    required this.name,
    required this.uid,
  });

  Map<String, dynamic> toJson() => {
        "avatar": avatar,
        "content": content,
        "createTime": createTime,
        "image": image,
        "name": name,
        "uid": uid,
      };
}
