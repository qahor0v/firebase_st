class Post {
  late String userId;
  late String name;
  late String title;
  late String img_url;

  Post(
      {required this.userId,
      required this.name,
      required this.title,
      required this.img_url});

  Post.fromJson(Map<String, dynamic> map)
      : userId = map['userId'],
        name = map['name'],
        title = map['title'],
        img_url = map['img_url'];

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'name': name,
        'title': title,
        'img_url': img_url,
      };
}
