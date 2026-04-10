import 'package:flutter/material.dart';
import 'package:kido/Widgets/ResponsiveProvider.dart';

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
    'assets/images/Characters/Boy.jpg',
    'assets/images/Characters/Girl.jpg',
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
      backgroundColor: const Color(0xFFEAF3FF),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Padding(
              padding: config.pagePadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.arrow_back_ios_new),
                  ),
                  SizedBox(height: config.localHeight * 0.01),
                  Text(
                    "Create Child Profile",
                    style: TextStyle(
                      fontSize: config.headline,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF1F2A44),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Tell us about your little learner",
                    style: TextStyle(
                      fontSize: config.body,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: config.localHeight * 0.03),

                  Text(
                    "Child's Name",
                    style: TextStyle(
                      fontSize: config.body,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1F2A44),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x14000000),
                          blurRadius: 18,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _nameController,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _submit(),
                      decoration: const InputDecoration(
                        hintText: "Enter name",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: config.localHeight * 0.03),
                  Text(
                    "Choose an Avatar",
                    style: TextStyle(
                      fontSize: config.body,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1F2A44),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: List.generate(_avatars.length, (i) {
                      final selected = i == _selectedAvatarIndex;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedAvatarIndex = i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            margin: EdgeInsets.only(right: i == 0 ? 12 : 0),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color:
                                    selected
                                        ? const Color(0xFF2C8FF9)
                                        : const Color(0xFFE6EAF2),
                                width: selected ? 3 : 2,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x12000000),
                                  blurRadius: 16,
                                  offset: Offset(0, 10),
                                ),
                              ],
                            ),
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: Image.asset(
                                  _avatars[i],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),

                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2C8FF9),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        elevation: 8,
                        shadowColor: const Color(0x552C8FF9),
                      ),
                      child: Text(
                        "Create Profile",
                        style: TextStyle(
                          fontSize: config.title,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
