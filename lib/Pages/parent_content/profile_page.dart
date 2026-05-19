// ignore_for_file: deprecated_member_use
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kido/Widgets/responsive_provider.dart';
import 'package:kido/constants.dart';
import '../../config/app_launch.dart';
import '../../config/cache_helper.dart';

class ProfilePage extends StatefulWidget {
  final Function(Locale) onLanguageChanged;

  const ProfilePage({super.key, required this.onLanguageChanged});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final String _parentName;
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
      _parentName = prefs.getString('parent_name') ?? '';
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
    try {
      await LocalStorage.logout();
      try {
        await GoogleSignIn.instance.signOut();
        await GoogleSignIn.instance.disconnect();
      } catch (_) {}

      if (!mounted) return;
      AppLaunch.navigateToLogin(context);
    } catch (e) {
      debugPrint("Logout Error: $e");
      if (!mounted) return;
      AppLaunch.navigateToLogin(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = ResponsiveProvider.of(context);
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                top: config.localHeight * 0.06,
                bottom: config.localHeight * 0.04,
              ),
              decoration: BoxDecoration(
                color: AppColors.kidoBlue.withOpacity(0.15),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
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
          ),
          SliverPadding(
            padding: EdgeInsets.only(
              left: config.localWidth * 0.06,
              right: config.localWidth * 0.06,
              top: config.localHeight * 0.03,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _ProfileTile(
                  icon: CupertinoIcons.person_fill,
                  title: isRtl ? "تعديل الملف الشخصي" : "Edit Profile",
                  subtitle: isRtl ? "تحديث معلوماتك الشخصية" : "Update your personal info",
                  color: AppColors.kidoBlue,
                  onTap: () {},
                  config: config,
                  isRtl: isRtl,
                ),
                _buildLanguageSwitchTile(config, isRtl),
                _ProfileTile(
                  icon: CupertinoIcons.lock_shield_fill,
                  title: isRtl ? "الخصوصية والأمان" : "Privacy & Security",
                  subtitle: isRtl ? "إدارة بياناتك الخاصة" : "Manage your data",
                  color: AppColors.textDark,
                  onTap: () {},
                  config: config,
                  isRtl: isRtl,
                ),
                SizedBox(height: config.localHeight * 0.04),
                _buildLogoutButton(config, isRtl),
                SizedBox(height: config.localHeight * 0.04),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSwitchTile(dynamic config, bool isRtl) {
    return Container(
      margin: EdgeInsets.only(bottom: config.localHeight * 0.022),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.purpleMain.withOpacity(0.06),
            blurRadius: 16,
            spreadRadius: 1,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.purpleMain.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                CupertinoIcons.globe,
                color: AppColors.purpleMain,
                size: config.headline * 0.9,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isRtl ? "اللغة" : "Language",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: config.body * 1.05,
                      color: AppColors.textDark,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Text(
                      isRtl ? "تغيير لغة واجهة التطبيق" : "Change application language",
                      style: TextStyle(
                        fontSize: config.body * 0.8,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: AppColors.bgColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSwitchButton('EN', 'English', !isRtl),
                  _buildSwitchButton('AR', 'العربية', isRtl),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchButton(String langCode, String label, bool isActive) {
    return GestureDetector(
      onTap: () {
        if (langCode == 'EN' && isActive == false) {
          widget.onLanguageChanged(const Locale('en'));
        } else if (langCode == 'AR' && isActive == false) {
          widget.onLanguageChanged(const Locale('ar'));
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.purpleMain : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isActive ? [
            BoxShadow(
              color: AppColors.purpleMain.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ] : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            color: isActive ? Colors.white : AppColors.textGray,
            fontFamily: langCode == 'AR' ? 'Cairo' : 'Fredoka',
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarSection(dynamic config) {
    final bool hasWebImage = kIsWeb && _webImageBytes != null;
    final bool hasMobileImage = !kIsWeb && _imageFile != null;
    final bool hasImage = hasWebImage || hasMobileImage;

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
        alignment: Alignment.center,
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
                  backgroundImage: hasWebImage
                      ? MemoryImage(_webImageBytes!)
                      : (hasMobileImage ? FileImage(_imageFile!) : null) as ImageProvider?,
                  child: !hasImage
                      ? Icon(
                    CupertinoIcons.person_alt,
                    size: config.localHeight * 0.055,
                    color: AppColors.kidoBlue,
                  )
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
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.kidoOrange,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    CupertinoIcons.camera_fill,
                    color: Colors.white,
                    size: 16,
                  ),
                  onPressed: () => _showImageSourceSheet(config),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(dynamic config, bool isRtl) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.redAccent.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: TextButton(
        onPressed: () => _showLogoutDialog(isRtl),
        style: TextButton.styleFrom(
          backgroundColor: Colors.red.shade50,
          minimumSize: Size(double.infinity, config.localHeight * 0.065),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(color: Colors.red.shade200, width: 1.5),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isRtl ? CupertinoIcons.arrow_left_circle : CupertinoIcons.arrow_right_circle,
              color: Colors.redAccent,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              isRtl ? "تسجيل الخروج" : "LOG OUT",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: config.body,
                color: AppColors.kidoRed,
                letterSpacing: 1.2,
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
    final isRtl = Directionality.of(context) == TextDirection.rtl;

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
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 12),
              if (hasImage)
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(
                      CupertinoIcons.eye_fill,
                      color: AppColors.bgColor,
                    ),
                  ),
                  title: Text(
                    isRtl ? "عرض الصورة الحالية" : "View Current Photo",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _showFullImage();
                  },
                ),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: AppColors.kidoOrange,
                  child: Icon(
                    CupertinoIcons.camera_fill,
                    color: AppColors.bgColor,
                  ),
                ),
                title: Text(
                  isRtl ? "التقاط صورة" : "Take a photo",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _handleImageAction(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: AppColors.kidoPink,
                  child: Icon(
                    CupertinoIcons.photo_fill,
                    color: AppColors.bgColor,
                  ),
                ),
                title: Text(
                  isRtl ? "اختيار من المعرض" : "Choose from gallery",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
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

  void _showLogoutDialog(bool isRtl) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        title: Row(
          children: [
            const Icon(CupertinoIcons.info_circle_fill, color: Colors.redAccent),
            const SizedBox(width: 10),
            Text(
              isRtl ? "تسجيل الخروج" : "Sign Out",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(
          isRtl
              ? "هل أنت متأكد من رغبتك في تسجيل الخروج من تطبيق كيدو؟ كل شيء سينتظرك بأمان لحين عودتك!"
              : "Are you sure you want to exit the Kido app? Everything will be safely waiting for your return!",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              isRtl ? "البقاء" : "Stay",
              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _performLogout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: Text(
              isRtl ? "خروج" : "Logout",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
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
  final bool isRtl;

  const _ProfileTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
    required this.config,
    this.isRtl = false,
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
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: config.body * 1.05,
            color: AppColors.textDark,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 2.0),
          child: Text(
            subtitle,
            style: TextStyle(
              fontSize: config.body * 0.8,
              color: Colors.grey.shade500,
            ),
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            shape: BoxShape.circle,
          ),
          child: Icon(
            isRtl ? CupertinoIcons.chevron_back : CupertinoIcons.chevron_forward,
            size: 14,
            color: Colors.grey.shade400,
          ),
        ),
      ),
    );
  }
}