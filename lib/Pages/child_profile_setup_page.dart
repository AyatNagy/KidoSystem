// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:kido/Widgets/responsive_provider.dart';
import 'package:kido/constants.dart';

class ChildProfileSetupResult {
  final String childName;
  final String avatarAsset;

  const ChildProfileSetupResult({
    required this.childName,
    required this.avatarAsset,
  });
}

class ChildProfileSetupPage extends StatefulWidget {
  final String childName;

  const ChildProfileSetupPage({super.key, required this.childName});

  @override
  State<ChildProfileSetupPage> createState() => _ChildProfileSetupPageState();
}

class _ChildProfileSetupPageState extends State<ChildProfileSetupPage> {
  late final TextEditingController _nameController;
  final List<String> _avatars = const [
    'assets/images/Characters/boy.gif',
    'assets/images/Characters/girl.gif',
  ];
  int _selectedAvatarIndex = 0;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.childName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    Navigator.of(context).pop(
      ChildProfileSetupResult(
        childName: name,
        avatarAsset: _avatars[_selectedAvatarIndex],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final config = ResponsiveProvider.of(context);

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: config.pagePadding,
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [AppColors.textDark, AppColors.kidoBlue],
                        ).createShader(bounds),
                        child: Text(
                          "Choose Your Buddy",
                          style: TextStyle(
                            fontSize: config.headline * 1.2,
                            fontWeight: FontWeight.w900,
                            color: AppColors.bgColor,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      height: config.localHeight * 0.32,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(_avatars.length, (i) {
                          final bool isSelected = i == _selectedAvatarIndex;
                          return Flexible(
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedAvatarIndex = i),
                              child: AnimatedScale(
                                scale: isSelected ? 1.1 : 0.85,
                                duration: const Duration(milliseconds: 600),
                                curve: Curves.elasticOut,
                                child: Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 10),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.bgColor,
                                    boxShadow: [
                                      BoxShadow(
                                        color: isSelected
                                            ? AppColors.kidoYellow.withOpacity(0.6)
                                            : Colors.black.withOpacity(0.05),
                                        blurRadius: isSelected ? 40 : 15,
                                        spreadRadius: isSelected ? 10 : 0,
                                      ),
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    radius: config.localWidth * 0.16,
                                    backgroundColor: Colors.transparent,
                                    child: Image.asset(_avatars[i]),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    SizedBox(height: config.localHeight * 0.04),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                      decoration: BoxDecoration(
                        color: AppColors.bgColor,
                        borderRadius: BorderRadius.circular(40),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.textDark.withOpacity(0.04),
                            blurRadius: 30,
                            offset: const Offset(0, 15),
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            "YOUR ADVENTURER NAME",
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 12,
                              color: AppColors.kidoBlue.withOpacity(0.6),
                              letterSpacing: 2.0,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _nameController,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textDark,
                            ),
                            decoration: const InputDecoration(
                              hintText: "Nickname...",
                              border: InputBorder.none,
                            ),
                          ),
                          Container(
                            height: 4,
                            width: 40,
                            decoration: BoxDecoration(
                              color: AppColors.kidoYellow,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    GestureDetector(
                      onTap: _submit,
                      child: Container(
                        width: double.infinity,
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppColors.kidoRed, AppColors.kidoColors[6]],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Center(
                          child: Text(
                            "START ADVENTURE!",
                            style: TextStyle(
                              color: AppColors.bgColor,
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}