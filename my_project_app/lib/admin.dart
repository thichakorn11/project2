// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'app_config.dart';
// import 'package:getwidget/getwidget.dart';
// import 'package:flutter_application_3/entity/user_model.dart';

// class AdminList extends StatefulWidget {
//   const AdminList({Key? key}) : super(key: key);

//   @override
//   AdminListState createState() => AdminListState();
// }

// class AdminListState extends State<AdminList> {
//   List<User> adminList = [];
//   int roleId = 3;

//   @override
//   void initState() {
//     fetchAdmin();
//     super.initState();
//   }

//   void fetchAdmin() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();

//     final response = await http.get(
//       Uri.parse("${AppConfig.SERVICE_URL}/api/users/type/:roleId"),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset:UTF-8',
//         'Accept': 'application/json',
//         'Authorization': 'Bearer ${prefs.getString("access_token")}'
//       },
//     );

//     final json = jsonDecode(response.body);

//     print(json["data"]);

//     List<User> store = List<User>.from(json["data"].map((item) {
//       return User.fromJSON(item);
//     }));

//     setState(() {
//       print(store);
//       adminList = store;
//     });
//   }

//   void deleteAdmin() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();

//     final response = await http.post(
//       Uri.parse("${AppConfig.SERVICE_URL}/api/users/delete"),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//         'Accept': 'application/json',
//         'Authorization': 'Bearer ${prefs.getString("access_token")}'
//       },
//       body: jsonEncode(<String, String>{'user_id': userId.toString()}),
//     );

//     final json = jsonDecode(response.body);

//     print(json["data"]);

//     fetchAdmin();
//   }

//   Widget getAdminListView() {
//     return ListView.builder(
//       padding: EdgeInsets.all(8),
//       itemCount: adminList.length,
//       itemBuilder: (context, index) {
//         User item = adminList[index];
//         return Card(
//           shape: RoundedRectangleBorder(
//             side: BorderSide(width: 2, color: Colors.amberAccent),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: GFListTile(
//             title: Text(
//               item.name,
//               style: TextStyle(
//                 fontSize: 17,
//               ),
//             ),
//             description: Text(
//               "${item.tel}",
//               style: TextStyle(color: Colors.red),
//             ),
//             subTitleText: ("${item.address}"),
//             icon: Icon(Icons.edit),
//             onTap: () {
//               Navigator.of(context)
//                   .push(MaterialPageRoute(
//                       builder: (context) =>
//                           AdminDetail(userId: item.userId)))
//                   .then((value) => {fetchAdmin()});
//             },
//             onLongPress: () {
//               setState(() {
//                 userId = item.userId;
//               });

//               showModalBottomSheet<void>(
//                 isScrollControlled: true,
//                 shape: const RoundedRectangleBorder(
//                   borderRadius:
//                       BorderRadius.vertical(top: Radius.circular(15.0)),
//                 ),
//                 context: context,
//                 builder: (BuildContext context) {
//                   return getConfirmPanel(context);
//                 },
//               );
//             },
//           ),
//         );
//       },
//     );
//   }

//   Widget getScreen() {
//     return SafeArea(child: getAdminListView());
//   }

//   Widget getConfirmPanel(BuildContext context) {
//     return SafeArea(
//       child: Padding(
//         padding: const EdgeInsets.all(40.0),
//         child: Column(
//           children: [
//             SizedBox(height: 15),
//             const Text(
//               "คุณแน่ใจหรือไม่ว่าต้องการลบข้อมูลนี้",
//               style: TextStyle(
//                 fontSize: 18,
//               ),
//             ),
//             SizedBox(height: 15),
//             ElevatedButton(
//               onPressed: () {
//                 deleteAdmin();
//                 Navigator.pop(context);
//               },
//               style: ElevatedButton.styleFrom(
//                 primary: Colors.green,
//                 fixedSize: Size(150, 50),
//               ),
//               child: const Text(
//                 "ตกลง",
//                 style: TextStyle(
//                   fontSize: 18,
//                 ),
//               ),
//             ),
//             SizedBox(height: 15), // เพิ่มระยะห่างระหว่างปุ่ม
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               style: ElevatedButton.styleFrom(
//                 primary: Colors.red,
//                 fixedSize: Size(150, 50),
//               ),
//               child: const Text(
//                 "ยกเลิก",
//                 style: TextStyle(
//                   fontSize: 18,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("ข้อมูลแอดมิน"),
//         backgroundColor: Colors.red,
//       ),
//       body: Container(
//         color: const Color(0xFFFFDCDF),
//         child: getScreen(),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.of(context)
//               .push(MaterialPageRoute(
//                   builder: (context) => const AdminDetail(userId: 0)))
//               .then((value) => {fetchAdmin()});
//         },
//         child: const Icon(Icons.add),
//         backgroundColor: Colors.red,
//       ),
//     );
//   }
// }
