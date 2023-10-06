import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'app_config.dart';
import 'package:flutter_application_3/payment.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  List<dynamic> cartData = [];
  bool isAllSelected = false; // ตัวแปรเพื่อตรวจสอบสถานะการเลือกทั้งหมด

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      print(prefs.getInt("user_id"));

      final response = await http.get(
        Uri.parse(
            "${AppConfig.SERVICE_URL}/api/cart/${prefs.getInt("user_id")}"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${prefs.getString("access_token")}'
        },
      );

      final json = jsonDecode(response.body);

      if (json["result"] == true) {
        setState(() {
          cartData = List.from(json["data"]);
          // เพิ่มข้อมูลสถานะ Checkbox
          for (var item in cartData) {
            item["isSelected"] = false;
          }
        });
      } else {
        print("มีข้อผิดพลาด: ${json['message']}");
        setState(() {
          cartData = [];
        });
      }
    } catch (e) {
      print("เกิดข้อผิดพลาด: $e");
    }
  }

  Widget buildCartList() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: cartData.length,
            itemBuilder: (context, index) {
              var cart = cartData[index];
              bool isSelected = cart["isSelected"];

              return Container(
                decoration: BoxDecoration(border: Border(bottom: BorderSide())),
                child: ListTile(
                  leading: Checkbox(
                    value: isSelected,
                    onChanged: (value) {
                      setState(() {
                        cart["isSelected"] = value;
                        // เรียกใช้ฟังก์ชันเพื่อตรวจสอบสถานะการเลือกทั้งหมดเมื่อมีการเปลี่ยนแปลง
                        checkAllSelectedStatus();
                      });
                    },
                  ),
                  title: Text(
                    cart["product_name"],
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("สี: ${cart["color_name"]}"),
                          Text(
                            "ราคา: ${(cart["price"] * cart["amount"])} บาท",
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                      Text(
                        "ไซส์: ${cart["size_name"]}",
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              setState(() {
                                if (cart["amount"] > 1) {
                                  cart["amount"]--;
                                }
                              });
                            },
                          ),
                          Text(
                            '${cart["amount"]}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                cart["amount"]++;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Row(
          children: [
            Checkbox(
              value: isAllSelected,
              onChanged: (value) {
                if (value == true) {
                  selectAllItems();
                } else {
                  deselectAllItems();
                }
              },
            ),
            Text("เลือกทั้งหมด"),
          ],
        ),
      ],
    );
  }

  void checkAllSelectedStatus() {
    bool allSelected = true;
    for (var item in cartData) {
      if (!item["isSelected"]) {
        allSelected = false;
        break;
      }
    }
    setState(() {
      isAllSelected = allSelected;
    });
  }

  void selectAllItems() {
    setState(() {
      for (var item in cartData) {
        item["isSelected"] = true;
      }
      isAllSelected = true;
    });
  }

  void deselectAllItems() {
    setState(() {
      for (var item in cartData) {
        item["isSelected"] = false;
      }
      isAllSelected = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ตะกร้าสินค้า"),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            icon: Icon(
              Icons.shopping_cart,
              color: Colors.black,
            ),
            onPressed: () {
              // เปิดหน้าตะกร้าสินค้าเมื่อคลิกที่ไอคอนตะกร้า
              // คุณสามารถเพิ่มโค้ดเปิดหน้าตะกร้าสินค้าที่นี่
            },
          ),
        ],
      ),
      body: Container(
        color: const Color(0xFFFFDCDF),
        child: Column(
          children: [
            Expanded(
              child: buildCartList(),
            ),
            ElevatedButton(
              onPressed: () {
                // เพิ่มโค้ดสำหรับการเช็คเอาต์ที่นี่
                // เช่น การนำคุณไปยังหน้า Payment
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Payment(),
                ));
              },
              child: Text("ชำระเงิน"),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "ราคารวมทั้งหมด: ฿${calculateTotalPrice()}",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String calculateTotalPrice() {
    double total = 0;
    for (var cart in cartData) {
      if (cart["isSelected"]) {
        total += (cart["amount"] * cart["price"]);
      }
    }
    return total.toStringAsFixed(2);
  }
}
