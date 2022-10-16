import 'dart:developer';
import 'dart:io';
import 'package:firebase_st/model/post_model.dart';
import 'package:firebase_st/pages/home_page.dart';
import 'package:firebase_st/services/RTDB_service.dart';
import 'package:firebase_st/services/preference_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/store_service.dart';

class AddPostPage extends StatefulWidget {
  static const String id = "add_post_page";

  const AddPostPage({Key? key}) : super(key: key);

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  bool isLoading = false;
  File? _image;
  final picker = ImagePicker();

  var nameController = TextEditingController();
  var title = TextEditingController();

  Future _getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        log("Image no selected!!!");
      }
    });
  }

  _addPost() async {
    String name1 = nameController.text.toString();
    String _title = title.text.toString();
    if (name1.isNotEmpty && _title.isNotEmpty) {
      uploadImage(name1, _title);
    }
  }

  void uploadImage(String name, String titlee) {
    setState(() {
      isLoading = true;
    });

    StoreService.uploadImage(_image!).then((imgUrl) => {
          _addToRealtimeDatabase(name: name, surname: titlee, imgUrl: imgUrl!),
        });
  }

  _addToRealtimeDatabase(
      {required String name,
      required String surname,
      required String imgUrl}) async {
    String? userId = await Preference.getUserId();
    Post post1 =
        Post(userId: userId!, name: name, title: surname, img_url: imgUrl);

    RTDB.addPost(post1).then((value) => {
          setState(() {
            isLoading = false;
          }),
          Navigator.pushReplacementNamed(context, HomePage.id),
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("Add post"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      _getImage();
                    },
                    child: SizedBox(
                      height: 100,
                      width: 100,
                      child: _image != null
                          ? Image.file(
                              _image!,
                              fit: BoxFit.cover,
                            )
                          : const Icon(
                              Icons.image,
                              size: 50,
                            ),
                    ),
                  ),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      hintText: 'Name',
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextField(
                    controller: title,
                    decoration: const InputDecoration(
                      hintText: 'Surname',
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                      width: double.infinity,
                      height: 45,
                      color: Colors.green,
                      child: TextButton(
                        onPressed: () {
                          _addPost();
                        },
                        child: const Text(
                          "Add",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      )),
                ],
              ),
            ),
          ),
          isLoading
              ? Container(
                  color: Colors.black26,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
