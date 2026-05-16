// ignore_for_file: deprecated_member_use
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kido/Pages/shared/logo_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kido/Widgets/responsive_provider.dart';
import 'package:kido/constants.dart';
import '../../config/cache_helper.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _parentName = 'Parent';
  File? _imageFile;
  Uint8List? _webImageBytes;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _parentName = prefs.getString('parent_name') ?? 'Parent';
    });
    if (!kIsWeb) {
      final imagePath = prefs.getString('parent_image_path');
      if (imagePath != null && imagePath.isNotEmpty) {
        setState(() {
          _imageFile = File(imagePath);
        });
      }
    }
  }

  Future<void> _handleImageAction(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      final prefs = await SharedPreferences.getInstance();

      if (kIsWeb) {
        final Uint8List imageBytes = await pickedFile.readAsBytes();
        setState(() {
          _webImageBytes = imageBytes;
        });
      } else {
        await prefs.setString('parent_image_path', pickedFile.path);
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    }
  }

  Future<void> _performLogout() async {
    if (mounted) Navigator.of(context).pop();

    try {
      await LocalStorage.logout();
      try {
        await GoogleSignIn.instance.signOut();
        await GoogleSignIn.instance.disconnect();
      } catch (_) {}
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('parent_name');
      await prefs.remove('parent_image_path');
      await prefs.remove('username');
      await prefs.remove('email');
      final token = await LocalStorage.getParentToken();
      final loggedIn = await LocalStorage.getLoggedIn();
      debugPrint("POST-LOGOUT: token=$token, loggedIn=$loggedIn");

      if (!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const Logo()),
            (Route<dynamic> route) => false,
      );
    } catch (e) {
      debugPrint("Logout Error: $e");
      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil('/welcome', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = ResponsiveProvider.of(context);

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Container(
                  height: config.localHeight * 0.22,
                  decoration: BoxDecoration(
                    color: AppColors.kidoBlue.withOpacity(0.15),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                ),
                Positioned(
                  top: config.localHeight * 0.08,
                  child: Column(
                    children: [
                      _buildAvatarSection(config),
                      SizedBox(height: config.localHeight * 0.015),
                      Text(
                        _parentName,
                        style: TextStyle(
                          fontSize: config.headline * 1.1,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: config.localHeight * 0.38),
              ],
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: config.localWidth * 0.06),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
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
                  color: AppColors.purpleMain,
                  onTap: () {},
                  config: config,
                ),
                _ProfileTile(
                  icon: CupertinoIcons.lock_shield_fill,
                  title: "Privacy & Security",
                  subtitle: "Manage your data",
                  color: AppColors.textDark,
                  onTap: () {},
                  config: config,
                ),
                SizedBox(height: config.localHeight * 0.05),
                _buildLogoutButton(config),
                SizedBox(height: config.localHeight * 0.04),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarSection(dynamic config) {
    final bool hasImage = kIsWeb ? (_webImageBytes != null) : (_imageFile != null);
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.kidoBlue.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          GestureDetector(
            onTap: hasImage ? _showFullImage : null,
            child: CircleAvatar(
              radius: config.localHeight * 0.065,
              backgroundColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: CircleAvatar(
                  radius: double.infinity,
                  backgroundColor: AppColors.kidoBlue.withOpacity(0.1),
                  backgroundImage: hasImage
                      ? (kIsWeb ? MemoryImage(_webImageBytes!) : FileImage(_imageFile!)) as ImageProvider
                      : null,
                  child: !hasImage
                      ? Icon(CupertinoIcons.person_alt, size: config.localHeight * 0.055, color: AppColors.kidoBlue)
                      : null,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 2,
            right: 2,
            child: Container(
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))
                  ]
              ),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.kidoOrange,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(CupertinoIcons.camera_fill, color: Colors.white, size: 16),
                  onPressed: () => _showImageSourceSheet(config),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(dynamic config) {
    return Container(
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.redAccent.withOpacity(0.15),
              blurRadius: 15,
              offset: const Offset(0, 6),
            )
          ]
      ),
      child: TextButton(
        onPressed: () => _showLogoutDialog(),
        style: TextButton.styleFrom(
          backgroundColor: Colors.red.shade50,
          minimumSize: Size(double.infinity, config.localHeight * 0.065),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: BorderSide(color: Colors.red.shade200, width: 1.5)
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(CupertinoIcons.arrow_right_circle, color: Colors.redAccent, size: 20),
            const SizedBox(width: 8),
            Text(
              "LOG OUT",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: config.body,
                  color: AppColors.kidoRed,
                  letterSpacing: 1.2
              ),
            ),
          ],
        ),
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
            borderRadius: BorderRadius.circular(30),
            child: kIsWeb
                ? Image.memory(_webImageBytes!, fit: BoxFit.contain)
                : Image.file(_imageFile!, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }

  void _showImageSourceSheet(dynamic config) {
    final bool hasImage = kIsWeb ? (_webImageBytes != null) : (_imageFile != null);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
              ),
              const SizedBox(height: 12),
              if (hasImage)
                ListTile(
                  leading: CircleAvatar(backgroundColor: Colors.blue, child: const Icon(CupertinoIcons.eye_fill, color: AppColors.bgColor)),
                  title: const Text("View Current Photo", style: TextStyle(fontWeight: FontWeight.bold)),
                  onTap: () {
                    Navigator.pop(context);
                    _showFullImage();
                  },
                ),
              ListTile(
                leading: const CircleAvatar(backgroundColor: AppColors.kidoOrange, child: Icon(CupertinoIcons.camera_fill, color: AppColors.bgColor)),
                title: const Text("Take a photo", style: TextStyle(fontWeight: FontWeight.bold)),
                onTap: () {
                  Navigator.pop(context);
                  _handleImageAction(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const CircleAvatar(backgroundColor: AppColors.kidoPink, child: Icon(CupertinoIcons.photo_fill, color: AppColors.bgColor)),
                title: const Text("Choose from gallery", style: TextStyle(fontWeight: FontWeight.bold)),
                onTap: () {
                  Navigator.pop(context);
                  _handleImageAction(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        title: const Row(
          children: [
            Icon(CupertinoIcons.info_circle_fill, color: Colors.redAccent),
            SizedBox(width: 10),
            Text("Sign Out", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: const Text("Are you sure you want to exit the Kido app? Everything will be safely waiting for your return!"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Stay", style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            onPressed: _performLogout,
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
            ),
            child: const Text("Logout", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
      margin: EdgeInsets.only(bottom: config.localHeight * 0.022),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.06),
            blurRadius: 16,
            spreadRadius: 1,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: config.headline * 0.9),
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: config.body * 1.05, color: AppColors.textDark),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 2.0),
          child: Text(subtitle, style: TextStyle(fontSize: config.body * 0.8, color: Colors.grey.shade500)),
        ),
        trailing: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
              color: Colors.grey.shade50,
              shape: BoxShape.circle
          ),
          child: Icon(CupertinoIcons.chevron_forward, size: 14, color: Colors.grey.shade400),
        ),
      ),
    );
  }
}