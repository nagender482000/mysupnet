// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// void getreq() async {
//   var request = http.MultipartRequest(
//       'GET',
//       Uri.parse(
//           'http://mysupnet-env.eba-mxkmz8fy.ap-southeast-1.elasticbeanstalk.com/api/v1/supportgroup?name=testgroup2&city=chennai'));

//   http.StreamedResponse response = await request.send();

//   if (response.statusCode == 200) {
//     print(await response.stream.bytesToString());
//   } else {
//     print(response.reasonPhrase);
//   }
// }

// void postreq() async {
//   var request = http.MultipartRequest(
//       'POST',
//       Uri.parse(
//           'http://mysupnet-env.eba-mxkmz8fy.ap-southeast-1.elasticbeanstalk.com/api/v1/supportgroup'));
//   request.fields.addAll({
//     'name': 'group14',
//     'city': 'chennai',
//     'country': 'india',
//     'admin_phone': '9840476581',
//     'admin_email': 'deeps.subramaniam@gmail.com',
//     'disease ': 'alzeimer'
//   });

//   http.StreamedResponse response = await request.send();

//   if (response.statusCode == 200) {
//     print(await response.stream.bytesToString());
//   } else {
//     print(response.reasonPhrase);
//   }
// }

// multipartProdecudre() async {
//   //for multipartrequest
//   var request = http.MultipartRequest(
//       'POST',
//       Uri.parse(
//           'http://mysupnet-env.eba-mxkmz8fy.ap-southeast-1.elasticbeanstalk.com/api/v1/user/register'));

//   request.fields.addAll({
//     'name': 'deepikaa subramaniam',
//     'email': 'nagender48@gmail.com',
//     'password': 'test123',
//     'under_medication': 'False',
//     'phone': '3522786797',
//     'role': '"patient"',
//     'support_group': '3',
//     'gender ': 'female',
//     'country_code': 'US',
//     'admin': 'False',
//     'disease': 'alzeimer'
//   });
//   // for token
//   // request.headers.addAll({"Authorization": "Bearer token"});

//   //for image and videos and files

//   // request.files.add(await http.MultipartFile.fromPath(
//   //     "key_value_from_api", "image_path/video/path"));
//   // request.fields.addAll({
//   //   'name ': 'nagender',
//   //   'email': 'aryan2000@gmail.com',
//   //   'gender': 'male',
//   //   'role': 'patient',
//   //   'under_medication': 'True',
//   //   'support_group': '1',
//   //   'password': 'test123',
//   //   'country_code': 'US',
//   //   'disease': 'alzeimer'
//   // });
//   //for completeing the request
//   //var response = await request.send();
//   // var request = http.MultipartRequest(
//   //     'GET',
//   //     Uri.parse(
//   //         'http://mysupnet-env.eba-mxkmz8fy.ap-southeast-1.elasticbeanstalk.com/api/v1/supportgroup?name=testgroup2&city=chennai'));
//   // http.StreamedResponse response = await request.send();
//   //for getting and decoding the response into json format
//   // var request = http.MultipartRequest(
//   //     'POST',
//   //     Uri.parse(
//   //         'http://mysupnet-env.eba-mxkmz8fy.ap-southeast-1.elasticbeanstalk.com/api/v1/user/login'));
//   // request.fields
//   //     .addAll({'email': 'tharun211@gmail.com', 'password': 'test123'});

//   // var request = http.MultipartRequest(
//   //     'GET',
//   //     Uri.parse(
//   //         'http://mysupnet-env.eba-mxkmz8fy.ap-southeast-1.elasticbeanstalk.com/api/v1/supportgroup?name=testgroup2&city=chennai'));

//   http.StreamedResponse response = await request.send();
//   var responsed = await http.Response.fromStream(response);
//   final responseData = json.decode(responsed.body);

//   if (responseData["status"] == 200) {
//     print(responseData["data"]["access_token"]);
//   } else {
//     print(responseData["detail"]);
//   }
// }

// class EditPPage extends StatefulWidget {
//   @override
//   _EditPPageState createState() => _EditPPageState();
// }

// class _EditPPageState extends State<EditPPage> {
//   final searchController = TextEditingController();
//   int _currentIndex = 0;

//   void onTabTapped(int index) {
//     setState(() {
//       _currentIndex = index;
//     });
//   }

//   @override
//   void dispose() {
//     searchController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SizedBox(
//         height: size.height * 1.2,
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Topbar(size: size, searchController: searchController),
//               const SizedBox(
//                 height: 20,
//               ),
//               SizedBox(
//                 width: size.width * 0.8,
//                 child: Center(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         onTap: onTabTapped, // new
//         selectedItemColor: const Color(0xFF71B48D),
//         currentIndex: 1, // this will be set when a new tab is tapped
//         items: const [
//           BottomNavigationBarItem(
//             icon: ImageIcon(
//               AssetImage("assets/images/feed.png"),
//             ),
//             title: Text('FEED'),
//             backgroundColor: null,
//           ),
//           BottomNavigationBarItem(
//             icon: ImageIcon(
//               AssetImage("assets/images/chat.png"),
//             ),
//             title: Text('MENTORS'),
//           ),
//           BottomNavigationBarItem(
//             icon: ImageIcon(
//               AssetImage("assets/images/new.png"),
//             ),
//             title: Text("WHAT'S NEW"),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class Topbar extends StatelessWidget {
//   const Topbar({
//     Key? key,
//     required this.size,
//     required this.searchController,
//   }) : super(key: key);

//   final Size size;
//   final TextEditingController searchController;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 20.0),
//       child: Container(
//         color: const Color(0xFFF2F9FF),
//         child: Container(
//           height: size.height * 0.12,
//           width: size.width,
//           alignment: Alignment.center,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Flexible(
//                 child: IconButton(
//                   icon: const Icon(
//                     Icons.arrow_back,
//                     color: Color(0xFF4682B4),
//                   ),
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                 ),
//               ),
//               Flexible(
//                 child: TextFormField(
//                   style: const TextStyle(
//                     fontFamily: "Avenir LT Std",
//                     color: Color(0xFF4682B4),
//                     fontSize: 20,
//                   ),
//                   decoration: const InputDecoration(
//                     contentPadding: EdgeInsets.only(top: 10),
//                     labelText: "Search",
//                     labelStyle: TextStyle(
//                       fontFamily: "Avenir LT Std",
//                       color: Color(0xFF4682B4),
//                       fontSize: 16,
//                       height: 0.5,
//                     ),
//                   ),
//                   keyboardType: TextInputType.emailAddress,
//                   controller: searchController,
//                   validator: (value) {
//                     if (value == null) {
//                       return 'Please Enter a value.';
//                     }
//                     return null;
//                   },
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () {},
//                 child: Image.asset(
//                   "assets/images/addec5a8-1f71-4772-96f0-843755aaaed1.png",
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () {},
//                 child: Image.asset(
//                   "assets/images/53e933ab-b850-43e3-990f-61d635d4ac34.png",
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
