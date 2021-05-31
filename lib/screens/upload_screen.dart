import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mlproject/screens/result_screen.dart';

class UploadScreen extends StatefulWidget {
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  bool isLoading = false;

  void showDialogBox() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("Choose an option"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _pickImage();
                },
                child: Text("Pick Image"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _clickImage();
                },
                child: Text("Click Image"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel"),
              ),
            ],
          );
        });
  }

  Future _pickImage() async {
    final picker = ImagePicker();
    try {
      PickedFile? pickedImage = await picker.getImage(
        source: ImageSource.gallery,
      );
      if (pickedImage != null) {
        File image = File(pickedImage.path);
        final filePath = image.path;
        setState(() {
          isLoading = true;
        });
        uploadFile(filePath, image);
      }
    } catch (e) {
      print(e);
    }
  }

  Future _clickImage() async {
    final picker = ImagePicker();
    try {
      PickedFile? pickedImage = await picker.getImage(
        source: ImageSource.camera,
      );
      if (pickedImage != null) {
        File image = File(pickedImage.path);
        final filePath = image.path;
        setState(() {
          isLoading = true;
        });
        uploadFile(filePath, image);
      }
    } catch (e) {
      print(e);
    }
  }

  uploadFile(String destination, File file) async {
    String? uploadedImage;
    try {
      final ref = FirebaseStorage.instance.ref(destination);
      final uploadTask = ref.putFile(file);
      final location = (await uploadTask.whenComplete(() async {
        try {
          uploadedImage = await ref.getDownloadURL();
        } catch (onError) {
          print("Error");
        } finally {
          setState(() {
            isLoading = false;
          });
        }
      }));

      if (uploadedImage != null) {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return ResultScreen(
            imageUrl: uploadedImage.toString(),
          );
        }));
      }
    } on FirebaseException catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              if (isLoading == false) {
                showDialogBox();
              } else {
                return null;
              }
            },
            child: isLoading
                ? CircularProgressIndicator(
                    color: Colors.white,
                  )
                : Text("Upload Image"),
          ),
        ),
      ),
    );
  }
}
