import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kido/Pages/student_data_screen.dart';
import '../Widgets/ResponsiveProvider.dart';
import 'ProfilePage.dart';

class ParentHomePage extends StatefulWidget {
  const ParentHomePage({super.key});

  @override
  State<ParentHomePage> createState() => _ParentHomePageState();
}

class _ParentHomePageState extends State<ParentHomePage> {
  int _selectedIndex = 0;
  List<Map<String, dynamic>> childrenList = [];

  void _goToAddChild() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const StudentData()),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        childrenList.add(result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = ResponsiveProvider.of(context);

    final List<Widget> _pages = [
      _buildHomeContent(config),
      const Scaffold(body: Center(child: Text("Dashboard"))),
      const Scaffold(body: Center(child: Text("Learn"))),
      const ProfilePage(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHomeContent(config) {
    return Stack(
      children: [
        SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(config.localWidth * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(config),
                SizedBox(height: config.localHeight * 0.03),
                Text(
                  "Your Children",
                  style: TextStyle(
                    fontSize: config.title,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2D3142),
                  ),
                ),
                SizedBox(height: config.localHeight * 0.02),
                ...childrenList
                    .map(
                      (child) => Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: _buildChildCard(
                          config,
                          child['name'],
                          "Level 1",
                          const Color(0xfff06292),
                          child['score'],
                        ),
                      ),
                    )
                    .toList(),

                _buildAddChildButton(config),
                SizedBox(height: config.localHeight * 0.15),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          left: 20,
          right: 20,
          child: _buildAIChatCard(config),
        ),
      ],
    );
  }

  Widget _buildHeader(config) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome back,",
              style: TextStyle(fontSize: config.body, color: Colors.grey),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
          ),
          child: Icon(
            CupertinoIcons.bell_fill,
            color: Colors.blueAccent,
            size: config.headline,
          ),
        ),
      ],
    );
  }

  Widget _buildChildCard(
    config,
    String name,
    String level,
    Color color,
    double progress,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(config.localWidth * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: color.withOpacity(0.1),
            child: Icon(Icons.face, color: color),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: config.body,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                LinearProgressIndicator(
                  value: progress,
                  color: color,
                  backgroundColor: Colors.grey[200],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            "${(progress * 100).toInt()}%",
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildAddChildButton(config) {
    return Container(
      width: double.infinity,
      height: config.localHeight * 0.1,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade400,
          style: BorderStyle.solid,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(25),
          onTap: _goToAddChild,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                CupertinoIcons.add_circled,
                size: config.headline,
                color: Colors.grey,
              ),
              const SizedBox(width: 10),
              Text(
                "Add Child",
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                  fontSize: config.body,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAIChatCard(config) {
    return Container(
      padding: EdgeInsets.all(config.localWidth * 0.05),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            CupertinoIcons.sparkles,
            color: Colors.white,
            size: config.headline,
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Need advice?",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: config.body,
                  ),
                ),
                Text(
                  "Ask our AI about progress",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: config.body * 0.8,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.blueAccent,
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(horizontal: 12),
            ),
            child: Text("Chat", style: TextStyle(fontSize: config.body * 0.8)),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.blueAccent,
      unselectedItemColor: Colors.grey,
      currentIndex: _selectedIndex,
      onTap: (index) => setState(() => _selectedIndex = index),
      items: const [
        BottomNavigationBarItem(icon: Icon(CupertinoIcons.home), label: "Home"),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.graph_square),
          label: "Dashboard",
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.play_rectangle),
          label: "Learn",
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.person),
          label: "Profile",
        ),
      ],
    );
  }
}
