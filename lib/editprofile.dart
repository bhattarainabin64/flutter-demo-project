import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tech/FirebaseService.dart';
import 'package:tech/userModel.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final User? user = FirebaseAuth.instance.currentUser;
  final FirebaseAuthService _authService = FirebaseAuthService();
  UserModel? userModel;
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // store pic image from gallery or camera
  File? _profileImage;

  // create object of image picker class
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    if (user != null) {
      UserModel? userDetail = await _authService.getUserDetails(user!.uid);
      setState(() {
        userModel = userDetail;
        _fullNameController.text = userDetail!.fullName;
        _phoneController.text = userDetail.phone;
      });
    }
  }

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Pick from Gallery'),
            onTap: () async {
              final XFile? pickedFile =
                  await _picker.pickImage(source: ImageSource.gallery);
              if (pickedFile != null) {
                setState(() {
                  _profileImage = File(pickedFile.path);
                });
              }
              Navigator.pushNamed(context, "/profile");
            },
          ), 
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Pick from Camera'),
            onTap: () async {
              final XFile? pickedFile =
                  await _picker.pickImage(source: ImageSource.camera);
              if (pickedFile != null) {
                setState(() {
                  _profileImage = File(pickedFile.path);
                });
              }
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _updateProfile() async {
    if (user != null) {
      String? profileImageUrl;
      if (_profileImage != null) {
        profileImageUrl = await _authService.uploadProfileImage(
            user!.uid, XFile(_profileImage!.path));
      }

      UserModel updatedUser = UserModel(
        uid: user!.uid,
        fullName: _fullNameController.text,
        email: user!.email!,
        phone: _phoneController.text,
        pic: profileImageUrl ?? userModel!.pic,
        createdAt: userModel!.createdAt,
      );

      await _authService.updateUserDetails(updatedUser);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: userModel == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                          radius: 50,
                          backgroundImage: _profileImage != null
                              ? FileImage(_profileImage!)
                              : NetworkImage(userModel!.pic ??
                                  'https://thumbs.dreamstime.com/b/business'),
                          child: Icon(
                            Icons.camera_alt,
                            size: 50,
                            color: Colors.grey.shade800,
                          )),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _fullNameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _updateProfile,
                    child: const Text('Save Changes'),
                  ),
                ],
              ),
            ),
    );
  }
}
