import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class NewPostScreen extends StatefulWidget {
  const NewPostScreen({Key? key}) : super(key: key);

  @override
  State<NewPostScreen> createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  final List<String> typeOptions = ['Restaurant', 'Museum', 'Wonder'];
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  String? description;
  String? recommendation;
  File? _selectedImage;
  String? _selectedType;

  Future<XFile?> _getImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    return image;
  }

  Future<void> _createPost(String name, String location, String imageUrl,
      String type, String description, String recommendation) async {
    try {
      CollectionReference posts =
          FirebaseFirestore.instance.collection('posts');
      await posts.add({
        'name': name,
        'location': location,
        'imageUrl': imageUrl,
        'type': type,
        'description': description,
        'recommendation': recommendation,
      });
      print('Post created successfully!');
    } catch (e) {
      print('Error creating post: $e');
      // Handle the error and show an error message to the user
    }
  }

  Future<String> _uploadImageToFirebaseStorage(File image) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference reference = storage.ref().child('images/$fileName');
      UploadTask uploadTask = reference.putFile(image);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image to Firebase Storage: $e');
      throw Exception('Failed to upload image.');
    }
  }

  void _resetFields() {
    setState(() {
      _selectedType = null;
      description = null;
      recommendation = null;
      _selectedImage = null;
    });
    _nameController.clear();
    _locationController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.2),
              ),
              child: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Text(
                  '<',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              padding: EdgeInsets.all(10.0),
            ),
          ),
        ),
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            children: [
              SizedBox(height: 20.0),
              Center(
                child: Text(
                  'New Post',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 40.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'Enter name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Location',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    controller: _locationController,
                    decoration: InputDecoration(
                      hintText: 'Enter location',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Image',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  GestureDetector(
                    onTap: () async {
                      XFile? image = await _getImageFromGallery();
                      if (image != null) {
                        setState(() {
                          _selectedImage = File(image.path);
                        });
                      }
                    },
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                      child: _selectedImage != null
                          ? Image.file(_selectedImage!)
                          : Center(
                              child: Text(
                                'Tap to select image',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Type',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  DropdownButtonFormField<String>(
                    value: _selectedType,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedType = newValue;
                      });
                    },
                    items: typeOptions
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    onChanged: (value) {
                      description = value;
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter description',
                      border: OutlineInputBorder(),
                    ),
                    minLines: 3,
                    maxLines: 5,
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recommendation',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    onChanged: (value) {
                      recommendation = value;
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter recommendation',
                      border: OutlineInputBorder(),
                    ),
                    minLines: 3,
                    maxLines: 5,
                  ),
                ],
              ),
              SizedBox(height: 40.0),
              ElevatedButton(
                onPressed: () async {
                  if (_nameController.text.isEmpty ||
                      _locationController.text.isEmpty ||
                      _selectedImage == null ||
                      _selectedType == null ||
                      description == null ||
                      recommendation == null) {
                    // Display an error message to the user if any field is empty
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Error'),
                          content: Text('Please fill in all fields.'),
                          actions: [
                            TextButton(
                              child: Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                    return;
                  }

                  String name = _nameController.text;
                  String location = _locationController.text;
                  String imageUrl =
                      await _uploadImageToFirebaseStorage(_selectedImage!);
                  String type = _selectedType!;
                  _createPost(name, location, imageUrl, type, description!,
                      recommendation!);
                  _resetFields();
                },
                child: Text('Post'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




/*
class _MyAppState extends State<MyApp> {
  final List<String> typeOptions = ['Restaurant', 'Museum', 'Wonder'];
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  String? description;
  String? recommendation;
  File? _selectedImage;
  String? _selectedType;

  Future<XFile?> _getImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    return image;
  }

  void _createPost(String name, String location, String imageUrl, String type,
      String description, String recommendation) async {
    try {
      CollectionReference posts =
          FirebaseFirestore.instance.collection('posts');
      await posts.add({
        'name': name,
        'location': location,
        'imageUrl': imageUrl,
        'type': type,
        'description': description,
        'recommendation': recommendation,
      });
      print('Post created successfully!');
    } catch (e) {
      print('Error creating post: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.2),
              ),
              child: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Text(
                  '<',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              padding: EdgeInsets.all(10.0),
            ),
          ),
        ),
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            children: [
              SizedBox(height: 20.0),
              Center(
                child: Text(
                  'New Post',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 40.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    controller: _nameController,
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Location',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    controller: _locationController,
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Image',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  GestureDetector(
                    onTap: () async {
                      XFile? image = await _getImageFromGallery();
                      setState(() {
                        _selectedImage = File(image!.path);
                      });
                    },
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                      child: _selectedImage != null
                          ? Image.file(_selectedImage!)
                          : Center(
                              child: Text(
                                'Tap to select image',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Type',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  DropdownButtonFormField<String>(
                    items: typeOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedType = newValue;
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedType,
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      description = value;
                    },
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recommendation',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      recommendation = value;
                    },
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      String name = _nameController.text;
                      String location = _locationController.text;
                      String imageUrl =
                          _selectedImage != null ? _selectedImage!.path : '';
                      String type = _selectedType ?? '';
                      String description = this.description ?? '';
                      String recommendation = this.recommendation ?? '';

                      _createPost(name, location, imageUrl, type, description,
                          recommendation);
                    },
                    child: ElevatedButton.icon(
                      onPressed: () {
                        String name = _nameController.text;
                        String location = _locationController.text;
                        String imageUrl =
                            _selectedImage != null ? _selectedImage!.path : '';
                        String type = _selectedType ?? '';
                        String description = this.description ?? '';
                        String recommendation = this.recommendation ?? '';

                        _createPost(name, location, imageUrl, type, description,
                            recommendation);
                      },
                      icon: Icon(Icons.add),
                      label: Text('Create'),
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}*/
