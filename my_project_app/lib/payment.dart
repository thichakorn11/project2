import 'package:flutter/material.dart';

class Payment extends StatefulWidget {
  const Payment({Key? key}) : super(key: key);

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  // เมธอดสำหรับเปิดหน้าแนบหลักฐานการชำระเงิน
  void _openAttachmentPage() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) {
        return AttachmentPage(); // แทน "AttachmentPage" ด้วยชื่อหน้าที่คุณต้องการเปิด
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('คำสั่งซื้อ'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // แสดงเนื้อหาของหน้าคำสั่งซื้อที่นี่
            Text('นี่คือหน้าคำสั่งซื้อ'),

            // ปุ่ม "แนบหลักฐานการชำระเงิน"
            ElevatedButton(
              onPressed: () {
                // เมื่อปุ่มถูกคลิก, เรียกใช้เมธอดเพื่อเปิดหน้าแนบหลักฐานการชำระเงิน
                _openAttachmentPage();
              },
              child: Text("แนบหลักฐานการชำระเงิน"),
            ),
          ],
        ),
      ),
    );
  }
}

// เพิ่มหน้า AttachmentPage ตามต้องการ
class AttachmentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แนบหลักฐานการชำระเงิน'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // เนื้อหาของหน้า AttachmentPage ที่นี่
            Text('นี่คือหน้าแนบหลักฐานการชำระเงิน'),
          ],
        ),
      ),
    );
  }
}
