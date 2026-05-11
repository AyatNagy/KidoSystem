// ignore_for_file: deprecated_member_use
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kido/Pages/shared/logo_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kido/Widgets/responsive_provider.dart';
import 'package:kido/constants.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _parentName = 'Parent';
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('parent_image_path');

    setState(() {
      _parentName = prefs.getString('parent_name') ?? 'Parent';
      if (imagePath != null && imagePath.isNotEmpty) {
        _imageFile = File(imagePath);
      }
    });
  }

  Future<void> _handleImageAction(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('parent_image_path', pickedFile.path);
      setState(() => _imageFile = File(pickedFile.path));
    }
  }

  Future<void> _performLogout() async {
    try {
      debugPrint("Logout initiated...");
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_email');
      await prefs.remove('parent_name');
      await prefs.remove('parent_image_path');
      bool success = await prefs.clear();
      debugPrint("Preferences cleared: $success");

      if (!mounted) return;

      Navigator.of(context, rootNavigator: true).pop();
      await Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const Logo(),
        ),
            (Route<dynamic> route) => false,
      );

    } catch (e) {
      debugPrint("Logout Error: $e");
      Navigator.of(context).pushNamedAndRemoveUntil('/welcome', (route) => false);
    }
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
            _buildAvatarSection(config),
            SizedBox(height: config.localHeight * 0.02),
            Text(
              _parentName,
              style: TextStyle(
                fontSize: config.headline,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            SizedBox(height: config.localHeight * 0.04),
            _ProfileTile(
              icon: CupertinoIcons.person_fill,
              title: "Edit Profile",
              subtitle: "Update your personal info",
              color: AppColors.kidoBlue,
              onTap: () {},
              config: config,
            ),
            _ProfileTile(
              icon: CupertinoIcons.globe,
              title: "Language",
              subtitle: "English / العربية",
              color: Colors.blueAccent,
              onTap: () {},
              config: config,
            ),
            _ProfileTile(
              icon: CupertinoIcons.lock_shield,
              title: "Privacy & Security",
              subtitle: "Manage your data",
              color: Colors.greenAccent,
              onTap: () {},
              config: config,
            ),

            SizedBox(height: config.localHeight * 0.04),
            _buildLogoutButton(config),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarSection(dynamic config) {
    return Center(
      child: Stack(
        children: [
          GestureDetector(
            onTap: _imageFile != null ? _showFullImage : null,
            child: CircleAvatar(
              radius: config.localHeight * 0.075,
              backgroundColor: Colors.white,
              backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
              child: _imageFile == null
                  ? Icon(Icons.person, size: config.localHeight * 0.07, color: AppColors.kidoBlue)
                  : null,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: FloatingActionButton.small(
              heroTag: 'camera_btn',
              backgroundColor: AppColors.kidoOrange,
              onPressed: () => _showImageSourceSheet(config),
              child: Icon(Icons.camera_alt, color: Colors.white, size: config.body),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(dynamic config) {
    return OutlinedButton(
      onPressed: () => _showLogoutDialog(),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.redAccent,
        side: const BorderSide(color: Colors.redAccent, width: 1.5),
        minimumSize: Size(double.infinity, config.localHeight * 0.06),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      child: Text(
        "LOG OUT",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: config.body),
      ),
    );
  }

  void _showFullImage() {
    showDialog(
      context: context,
      builder: (_) => GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Dialog(
          backgroundColor: Colors.transparent,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.file(_imageFile!, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }

  void _showImageSourceSheet(dynamic config) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_imageFile != null)
              ListTile(
                leading: const Icon(Icons.fullscreen, color: AppColors.kidoBlue),
                title: const Text("View Photo"),
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
                _handleImageAction(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.blueAccent),
              title: const Text("Choose from gallery"),
              onTap: () {
                Navigator.pop(context);
                _handleImageAction(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Sign Out"),
        content: const Text("Are you sure you want to exit the Kido app?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Stay"),
          ),
          TextButton(
            onPressed: _performLogout,
            child: const Text("Logout", style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;
  final dynamic config;

  const _ProfileTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
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
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
      ),
    );
  }
}