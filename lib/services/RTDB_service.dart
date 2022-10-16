import 'package:firebase_database/firebase_database.dart';
import '../model/post_model.dart';

class RTDB{
  static final _database = FirebaseDatabase.instance.reference();
  static Future addPost(Post post) async {
    _database.child("posts").push().set(post.toJson());
    return _database.onChildAdded;
  }

  static Future<List<Post>> getPosts(String id) async {
    List<Post> items = [];
    Query _query = _database.reference().child("posts").orderByChild("userId").equalTo(id);
    //Query _query = _database.reference().child("posts").orderByChild("userId");
    var snapshot = await _query.once();
    var result = snapshot.value.values as Iterable;

    for(var item in result) {
      items.add(Post.fromJson(Map<String, dynamic>.from(item)));
    }
    return items;
  }
}