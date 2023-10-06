import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'app_config.dart';
import 'package:flutter_application_3/customer_detail.dart';

class Customer extends StatefulWidget {
  @override
  _CustomerState createState() => _CustomerState();
}

class _CustomerState extends State<Customer> {
  List<dynamic> customerData = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      final response = await http.get(
        Uri.parse("${AppConfig.SERVICE_URL}/api/customer"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${prefs.getString("access_token")}'
        },
      );

      final json = jsonDecode(response.body);

      print(json["data"]);

      if (json["result"] == true) {
        setState(() {
          customerData = List.from(json["data"]);
        });
      } else {
        // แสดงข้อความหรือกระทบอื่น ๆ เมื่อมีข้อผิดพลาด
        print("มีข้อผิดพลาด: ${json['message']}");
        // เพิ่มบรรทัดนี้เพื่อตั้งค่า customerData เป็นรายการว่างเมื่อมีข้อผิดพลาด
        customerData = [];
      }
    } catch (e) {
      // แสดงข้อความข้อผิดพลาดเมื่อเกิดข้อผิดพลาด
      print("เกิดข้อผิดพลาด: $e");
    }
  }

  Widget buildCustomerList() {
    return ListView.builder(
      itemCount: customerData.length,
      itemBuilder: (context, index) {
        var customer = customerData[index];
        return Container(
          decoration: BoxDecoration(border: Border(bottom: BorderSide())),
          child: ListTile(
            leading: Container(
              width: 40, // กำหนดความกว้างของวงกลม
              height: 40, // กำหนดความสูงของวงกลม
              decoration: BoxDecoration(
                shape: BoxShape.circle, // ตั้งค่าให้เป็นวงกลม
                color: const Color(0xff6ae792), // สีพื้นหลัง
              ),
              child: Center(
                child: Icon(
                  Icons.person,
                  color: Colors.black,
                ),
              ),
            ),
            title: Text(customer["name"]),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(customer["address"]),
                // Text("เบอร์โทร: ${customer["tel"]}"), // เพิ่มเบอร์โทร
                // Text("อีเมล: ${customer["email"]}"), // เพิ่มอีเมล
              ],
            ),
            trailing: Icon(Icons.arrow_forward), // เพิ่มไอคอนด้านหลัง
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CustomerDetailScreen(customer: customer),
                ),
              );
            },
            // แสดงข้อมูลอื่น ๆ ที่คุณต้องการแสดง
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ข้อมูลลูกค้า"),
        backgroundColor: Colors.red,
      ),
      body: Container(
        color: const Color(0xFFFFDCDF),
        child: buildCustomerList(),
      ),
    );
  }
}
