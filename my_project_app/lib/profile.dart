import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('โปรไฟล์ของฉัน'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue, // สีของพื้นหลังของไอคอน
              child: Icon(
                Icons.person, // ไอคอนที่คุณต้องการใช้
                size: 70, // ขนาดของไอคอน
                color: Colors.white, // สีของไอคอน
              ),
            ),
            SizedBox(height: 16),
            Text(
              'ชื่อผู้ใช้',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'user@example.com',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // กดปุ่มแก้ไขโปรไฟล์
                // คุณสามารถเพิ่มโค้ดเปิดหน้าแก้ไขโปรไฟล์ที่นี่
              },
              child: Text('แก้ไขโปรไฟล์'),
            ),
          ],
        ),
      ),
    );
  }
}
