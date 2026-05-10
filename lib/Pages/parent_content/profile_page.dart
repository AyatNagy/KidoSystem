// ignore_for_file: deprecated_member_use
/*import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kido/Widgets/responsive_provider.dart';
import 'package:kido/constants.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? parentName = 'Parent';
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      parentName = prefs.getString('parent_name') ?? 'Parent';
      final imagePath = prefs.getString('parent_image_path');
      if (imagePath != null && imagePath.isNotEmpty) {
        _imageFile = File(imagePath);
      }
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('parent_image_path', pickedFile.path);

      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _showFullImage() {
    if (_imageFile == null) return;
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.file(_imageFile!, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final config = ResponsiveProvider.of(context);

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(config.localWidth * 0.06),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: _imageFile != null ? _showFullImage : null,
                    child: Container(
                      height: config.localHeight * 0.15,
                      width: config.localHeight * 0.15,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                        image: _imageFile != null
                            ? DecorationImage(
                          image: FileImage(_imageFile!),
                          fit: BoxFit.cover,
                        )
                            : null,
                      ),
                      child: _imageFile == null
                          ? Icon(
                        Icons.person,
                        size: config.localHeight * 0.07,
                        color: AppColors.kidoBlue,
                      )
                          : null,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: () => _showImageSourceSheet(context, config),
                      child: Container(
                        padding: EdgeInsets.all(config.localWidth * 0.02),
                        decoration: const BoxDecoration(
                          color: AppColors.kidoOrange,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: config.body,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: config.localHeight * 0.02),
            Text(
              parentName!,
              style: TextStyle(
                fontSize: config.headline,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            SizedBox(height: config.localHeight * 0.04),
            _buildProfileTile(
              config,
              CupertinoIcons.person_fill,
              "Edit Profile",
              "Update your personal info",
              AppColors.kidoBlue,
              onTap: () {},
            ),
            _buildProfileTile(
              config,
              CupertinoIcons.globe,
              "Language",
              "English / العربية",
              Colors.blueAccent,
              onTap: () {},
            ),
            _buildProfileTile(
              config,
              CupertinoIcons.lock_shield,
              "Privacy & Security",
              "Manage your data",
              Colors.greenAccent,
              onTap: () {},
            ),
            SizedBox(height: config.localHeight * 0.04),
            ElevatedButton(
              onPressed: () => _showLogoutDialog(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                elevation: 0,
                side: const BorderSide(color: Colors.redAccent, width: 1.5),
                minimumSize: Size(double.infinity, config.localHeight * 0.06),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: Text(
                "LOG OUT",
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: config.body,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showImageSourceSheet(BuildContext context, dynamic config) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_imageFile != null)
                ListTile(
                  leading: const Icon(Icons.image, color: AppColors.kidoBlue),
                  title: const Text("Show profile photo"),
                  onTap: () {
                    Navigator.pop(context);
                    _showFullImage();
                  },
                ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: AppColors.kidoOrange),
                title: const Text("Take a photo"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.blueAccent),
                title: const Text("Choose from gallery"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Confirmation"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              if (!context.mounted) return;
              Navigator.pushNamedAndRemoveUntil(context, '/welcome', (route) => false);
            },
            child: const Text("Log out", style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTile(
      dynamic config,
      IconData icon,
      String title,
      String subtitle,
      Color color, {
        required VoidCallback onTap,
      }) {
    return Container(
      margin: EdgeInsets.only(bottom: config.localHeight * 0.02),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(horizontal: config.localWidth * 0.04),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: config.headline),
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: config.body),
        ),
        subtitle: Text(subtitle, style: TextStyle(fontSize: config.body * 0.8)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      ),
    );
  }
}*/
