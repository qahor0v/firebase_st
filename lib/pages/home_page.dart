import 'dart:io';
import 'package:firebase_st/services/RTDB_service.dart';
import 'package:firebase_st/services/auth_service.dart';
import 'package:firebase_st/services/preference_service.dart';
import 'package:flutter/material.dart';
import '../model/post_model.dart';
import 'add_post_page.dart';

class HomePage extends StatefulWidget {
  static const String id = 'home_page';

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  List<Post> item = [];

  @override
  void initState() {
    super.initState();

    _apiGetPosts();
  }

  _apiGetPosts() async {
    String? userId = await Preference.getUserId();
    RTDB.getPosts(userId!).then((posts) => {
          setState(() {
            item.addAll(posts);
          }),
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home page'),
        actions: [
          IconButton(
            onPressed: () {
              AuthService.signOut(context);
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: ListView.builder(
          itemCount: item.length,
          itemBuilder: (ctx, i) {
            return itemOfList(item[i]);
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          Navigator.pushReplacementNamed(context, AddPostPage.id);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget itemOfList(Post post) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 80,
            width: 80,
            // ignore: unnecessary_null_comparison
            child: post.img_url != null
                ? Image.network(
                    post.img_url,
                    fit: BoxFit.cover,
                  )
                : const Icon(
                    Icons.image,
                    size: 50,
                  ),
          ),
          Text(
            post.name,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            post.title,
            style: const TextStyle(
              fontSize: 17,
            ),
          ),
        ],
      ),
    );
  }
}
