import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:navigatio/providers/user_provider.dart';
import 'package:navigatio/resources/firestore_methods.dart';
import 'package:navigatio/screens/camping_gear_screen.dart';
import 'package:navigatio/screens/event_screen.dart';
import 'package:navigatio/screens/main_event_screen.dart';
import 'package:navigatio/utils/colors.dart';
import 'package:navigatio/utils/utils.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';

class AddCampingGearScreen extends StatefulWidget {
  const AddCampingGearScreen({Key? key}) : super(key: key);

  @override
  _AddCampingGearScreenState createState() => _AddCampingGearScreenState();
}

class _AddCampingGearScreenState extends State<AddCampingGearScreen> {
  Uint8List? _file;
  final TextEditingController _discriptionController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  bool _isLoading = false;

  void postImage(
    String uid,
    String username,
    String profImage,
  ) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FirestoreMethods().uploadCampingItem(
        _discriptionController.text,
        _nameController.text,
        _file!,
        uid,
        username,
        profImage,
      );
      if (res == "success") {
        setState(() {
          _isLoading = false;
        });
        showSnackBar("Posted", context);
        clearImage();
      } else {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(res, context);
      }
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text('Add Photo About Camping Gear'),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a Photo'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void clearImage() {
    setState(() {
      _file = null;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MainEventScreen(),
        ),
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    _discriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: clearImage,
        ),
        title: const Text("Add Item "),
        actions: [
          TextButton(
            onPressed: () => postImage(user.uid, user.username, user.photoUrl),
            child: const Text(
              "Post ",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          _isLoading
              ? const LinearProgressIndicator()
              : const Padding(
                  padding: EdgeInsets.only(top: 0),
                ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user.photoUrl),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: Column(
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'Name Of Item',
                        border: InputBorder.none,
                      ),
                    ),
                    TextField(
                      controller: _discriptionController,
                      decoration: InputDecoration(
                        hintText: 'Write about your Event',
                        border: InputBorder.none,
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
              IconButton(
                iconSize: 30,
                onPressed: () => _selectImage(context),
                icon: Icon(Icons.add_a_photo),
              ),
            ],
          ),
          Divider(),
          _file == null
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 200,
                    width: 100,
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                  'https://thumbs.dreamstime.com/b/no-image-available-icon-photo-camera-flat-vector-illustration-132483141.jpg'),
                              fit: BoxFit.fill,
                              alignment: FractionalOffset.topCenter),
                        ),
                      ),
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 200,
                    width: 100,
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: MemoryImage(_file!),
                              fit: BoxFit.fill,
                              alignment: FractionalOffset.topCenter),
                        ),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
