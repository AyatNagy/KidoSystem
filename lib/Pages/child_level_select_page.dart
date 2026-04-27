// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:kido/Pages/level2/level2_home.dart';
import 'package:kido/Pages/level3/level3_home.dart';
import 'package:kido/Widgets/responsive_provider.dart';

class ChildLevelSelectResult {
  final int level; 

  const ChildLevelSelectResult({required this.level});
}

class ChildLevelSelectPage extends StatefulWidget {
  final String childName;
  final int? recommendedLevel;

  const ChildLevelSelectPage({
    super.key,
    required this.childName,
    this.recommendedLevel,
  });

  @override
  State<ChildLevelSelectPage> createState() => _ChildLevelSelectPageState();
}

class _ChildLevelSelectPageState extends State<ChildLevelSelectPage> {
  int? _selectedLevel;

  @override
  void initState() {
    super.initState();
    _selectedLevel = widget.recommendedLevel;
  }

  void _submit() {
    final level = _selectedLevel;
    if (level == null) return;

    switch (level) {
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => const Scaffold(
                  body: Center(child: Text("Level 1 - Coming Soon")),
                ),
          ),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => Level2Home(childName: widget.childName)
          ),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => Level3Home(childName: widget.childName),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = ResponsiveProvider.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFFF7E6),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Padding(
              padding: config.pagePadding,
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).maybePop(),
                        icon: const Icon(Icons.arrow_back_ios_new),
                      ),
                      Expanded(
                        child: Text(
                          "Choose your level",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: config.title,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFF1F2A44),
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                  SizedBox(height: config.localHeight * 0.01),
                  Text(
                    widget.childName,
                    style: TextStyle(
                      fontSize: config.headline * 0.9,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF2C8FF9),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Pick a level to start your journey",
                    style: TextStyle(
                      fontSize: config.body,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: config.localHeight * 0.03),

                  Expanded(
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        _levelCard(
                          config,
                          level: 1,
                          title: "Level 1",
                          subtitle: "Easy start",
                          color: const Color(0xFF2C8FF9),
                          icon: Icons.rocket_launch,
                        ),
                        const SizedBox(height: 14),
                        _levelCard(
                          config,
                          level: 2,
                          title: "Level 2",
                          subtitle: "Growing skills",
                          color: const Color(0xFFFF8A65),
                          icon: Icons.auto_awesome,
                        ),
                        const SizedBox(height: 14),
                        _levelCard(
                          config,
                          level: 3,
                          title: "Level 3",
                          subtitle: "Challenge mode",
                          color: const Color(0xFFF06292),
                          icon: Icons.emoji_events,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _selectedLevel == null ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1F2A44),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: Text(
                        "Start",
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

  Widget _levelCard(
    dynamic config, {
    required int level,
    required String title,
    required String subtitle,
    required Color color,
    required IconData icon,
  }) {
    final selected = _selectedLevel == level;

    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () => setState(() => _selectedLevel = level),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.all(config.localWidth * 0.045),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: selected ? color : const Color(0xFFEAEAEA),
            width: selected ? 3 : 2,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.12),
              blurRadius: 16,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: color, size: 30),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: config.body,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF1F2A44),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: config.body * 0.9,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            if (selected)
              Icon(Icons.check_circle, color: color, size: 28)
            else
              Icon(
                Icons.circle_outlined,
                color: Colors.grey.shade400,
                size: 26,
              ),
          ],
        ),
      ),
    );
  }
}
