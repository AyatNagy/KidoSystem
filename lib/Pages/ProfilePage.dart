import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Widgets/ResponsiveProvider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final config = ResponsiveProvider.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Profile",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: config.title,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(config.localWidth * 0.06),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  Container(
                    height: config.localHeight * 0.15,
                    width: config.localHeight * 0.15,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueAccent.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        )
                      ],
                    ),
                    child: Icon(
                      Icons.person,
                      size: config.localHeight * 0.07,
                      color: Colors.blueAccent,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(config.localWidth * 0.02),
                      decoration: const BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: config.body,
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: config.localHeight * 0.04),
            _buildProfileTile(
              config,
              CupertinoIcons.globe,
              "Language",
              "English / العربية",
              Colors.blueAccent,
            ),
            _buildProfileTile(
              config,
              CupertinoIcons.lock_shield,
              "Privacy & Security",
              "",
              Colors.greenAccent,
            ),
            _buildProfileTile(
              config,
              CupertinoIcons.bell,
              "Notifications",
              "On",
              Colors.orangeAccent,
            ),

            SizedBox(height: config.localHeight * 0.02),

            _buildProfileTile(
              config,
              CupertinoIcons.power,
              "Log Out",
              "",
              Colors.redAccent,
              isLogout: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTile(
      dynamic config,
      IconData icon,
      String title,
      String subtitle,
      Color color,
      {bool isLogout = false}
      ) {
    return Container(
      margin: EdgeInsets.only(bottom: config.localHeight * 0.02),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: config.localWidth * 0.04,
          vertical: config.localHeight * 0.005,
        ),
        leading: Container(
          padding: EdgeInsets.all(config.localWidth * 0.02),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: config.headline,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: config.body,
            color: isLogout ? Colors.redAccent : Colors.black87,
          ),
        ),
        subtitle: subtitle.isNotEmpty
            ? Text(
            subtitle, style: TextStyle(fontSize: config.body * 0.8)
        ) : null,
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: config.body * 0.8,
          color: Colors.grey,
        ),
        onTap: () {
        },
      ),
    );
  }
}