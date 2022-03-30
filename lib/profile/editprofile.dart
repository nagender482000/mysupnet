import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;
import 'package:mysupnet/Apicalls/edit.dart';
import 'package:mysupnet/profile/profile.dart';

import 'package:shared_preferences/shared_preferences.dart';

class EditPage extends StatefulWidget {
  const EditPage({Key? key}) : super(key: key);

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  LinkedHashMap<String, dynamic> userdata = LinkedHashMap();
  var isLoading = true;
  String numb = "";
  String date = "";
  String year = "";
  String medic = "";
  String doctor = "";
  String name = "";
  String hospital = "";
  String hospitalVal = "Singapore General Hospital";
  int _gradioSelected = 1;
  String gender = "";
  String countrycode = "";
  TextEditingController dateController = TextEditingController();

  TextEditingController yearController = TextEditingController();

  TextEditingController medicationController = TextEditingController();

  TextEditingController doctorController = TextEditingController();

  TextEditingController nameController = TextEditingController();

  TextEditingController hospitalController = TextEditingController();

  // String _disval = "Condition";
  // List<String> disList = ["Condition"];
  // List<dynamic> grpList = [];
  // List<dynamic> grpidList = [];
  // List<String> grpname = [""];
  //LinkedHashMap<String, dynamic> templist = LinkedHashMap();

  //String grpval = "";
  //String grpid = "1";
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    getuser();

    super.initState();
  }

  getuser() async {
    setState(() {
      isLoading = true;
    });
    await eprofile();
    setState(() {
      isLoading = false;
    });
  }

  eprofile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token').toString();
    String email = prefs.getString('email').toString();

    var headers = {'Authorization': 'Bearer ' + token.toString()};
    var request = http.MultipartRequest('GET',
        Uri.parse('https://apis.mysupnet.org/api/v1/user?email=' + email));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var responsed = await http.Response.fromStream(response);
    final responseData = json.decode(responsed.body);

    if (response.statusCode == 200) {
      userdata = responseData["data"];
      name = userdata["name"].toString();
      nameController.text = name;
      gender = userdata["gender"].toString();
      if (gender == "Male") {
        _gradioSelected = 1;
      } else {
        _gradioSelected = 2;
      }

      numb = userdata["phone"].toString();
      countrycode = userdata["country_code"].toString();
      if (userdata["date_of_birth"] != null) {
        date = DateFormat("yyyy-MM-dd")
            .format(DateTime.parse(userdata["date_of_birth"].toString()))
            .toString();
      } else {
        date = "";
      }
      dateController.text = date;
      if (userdata["year_of_diagnosis"] != null) {
        year = DateFormat("yyyy-MM-dd")
            .format(DateTime.parse(userdata["year_of_diagnosis"].toString()))
            .toString();
      } else {
        year = "";
      }
      yearController.text = year;
      hospital = userdata["hospital"].toString();
      hospitalController.text = hospital;
      medic = userdata["medications"].toString();
      medicationController.text = medic;
      doctor = userdata["physician"].toString();
      doctorController.text = doctor;
    } else {
      return responseData["detail"];
    }
  }

  void onTabTapped(int index) {
    setState(() {});
  }

  @override
  void dispose() {
    dateController.dispose();
    medicationController.dispose();
    yearController.dispose();
    nameController.dispose();
    super.dispose();
  }

  // getConditionData() async {
  //   var request = http.MultipartRequest(
  //       'GET',
  //       Uri.parse(
  //           'https://apis.mysupnet.org/api/v1/supportgroup/disease/list'));
  //   http.StreamedResponse response = await request.send();
  //   var responsed = await http.Response.fromStream(response);
  //   final item = json.decode(responsed.body);
  //   setState(() {
  //     isLoading = true;

  //     disList.remove("Condition");
  //     item.forEach((key, value1) {
  //       disList.add(key);
  //       _disval = disList[0];
  //     });
  //   });

  //   setState(() {
  //     isLoading = false;
  //   });
  // }

  // getGroupData(int index) async {
  //   var request = http.MultipartRequest(
  //       'GET',
  //       Uri.parse(
  //           'https://apis.mysupnet.org/api/v1/supportgroup/disease/list'));
  //   http.StreamedResponse response = await request.send();
  //   var responsed = await http.Response.fromStream(response);
  //   final item = json.decode(responsed.body);

  //   int i = 0;

  //   setState(() {
  //     isLoading = true;
  //     item.forEach((key, value1) {
  //       templist.addAll(value1);
  //       templist.forEach((key, value2) {
  //         if (i % 2 == 1) {
  //           grpList.add(value2);
  //         }
  //         i++;
  //       });
  //     });

  //     i = 0;
  //     for (var element in grpList) {
  //       if (i == index) {
  //         grpidList.addAll(element);
  //       }
  //       i++;
  //     }
  //     grpname.clear();
  //     for (i = 0; i < grpidList.length; i++) {
  //       grpname.add(grpidList[i]["name"]);
  //     }
  //     grpval = grpname[0];

  //     grpList.clear();
  //     grpidList.clear();
  //   });

  //   setState(() {
  //     isLoading = false;
  //   });
  // }

  // void grpnameset(String disval) {
  //   int index = 0;
  //   for (int i = 0; i < disList.length; i++) {
  //     if (disList[i] == disval) {
  //       index = i;
  //       break;
  //     }
  //   }
  //   getGroupData(index);
  // }

  // void grpidsearch(
  //   String searchval,
  //   grpList,
  // ) {
  //   for (int i = 0; i < grpList.length; i++) {
  //     for (int j = 0; j < grpList[i].length; j++) {
  //       if (grpList[i][j]["name"] == searchval) {
  //         grpid = grpList[i][j]["id"].toString();
  //         break;
  //       }
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // dateController.text = userdata["date_of_birth"].toString();
    // yearController.text = userdata["year_of_diagnosis"].toString();
    // countrycode = userdata["country_code"].toString();
    // medicationController.text = userdata["medications"].toString();
    // doctorController.text = userdata["physician"].toString();
    // emailController.text = userdata["email"].toString();
    // nameController.text = userdata["name"].toString();
    // gender = userdata["gender"].toString();
    // number = userdata["phone"].toString();

    if (gender == "Male") {
      _gradioSelected = 1;
    } else {
      _gradioSelected = 2;
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Builder(builder: (context) {
              return SizedBox(
                height: size.height * 2,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Topbar(size: size),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: size.width * 0.9,
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 50,
                                    child: Image.asset(
                                      "assets/images/user.png",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 50,
                                  ),
                                  InkWell(
                                    onTap: () {},
                                    child: Container(
                                      width: size.width * 0.4,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 13),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(4)),
                                          border:
                                              Border.all(color: Colors.green),
                                          color: Colors.white),
                                      child: const Text(
                                        'UPLOAD IMAGE',
                                        style: TextStyle(
                                          fontFamily: "Avenir LT Std",
                                          color: Color(0xFF4078A6),
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: size.height * 0.03),
                              const Text(
                                "Personal Information",
                                style: TextStyle(
                                  fontFamily: "Avenir LT Std",
                                  color: Color(0xFF4682B4),
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                alignment: Alignment.center,
                                child: TextFormField(
                                  style: const TextStyle(
                                    fontFamily: "Avenir LT Std",
                                    color: Color(0xFF000000),
                                    fontSize: 20,
                                  ),
                                  decoration: const InputDecoration(
                                    labelText: "Full Name",
                                    labelStyle: TextStyle(
                                      fontFamily: "Avenir LT Std",
                                      color: Color(0xFFB8B8B8),
                                      fontSize: 16,
                                    ),
                                  ),
                                  keyboardType: TextInputType.name,
                                  controller: nameController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please Enter Name';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              // Container(
                              //   alignment: Alignment.center,
                              //   child: TextFormField(
                              //     style: const TextStyle(
                              //       fontFamily: "Avenir LT Std",
                              //       color: Color(0xFF000000),
                              //       fontSize: 20,
                              //     ),
                              //     decoration: const InputDecoration(
                              //       labelText: "Email",
                              //       labelStyle: TextStyle(
                              //         fontFamily: "Avenir LT Std",
                              //         color: Color(0xFFB8B8B8),
                              //         fontSize: 16,
                              //       ),
                              //     ),
                              //     keyboardType: TextInputType.emailAddress,
                              //     controller: emailController,
                              //     validator: (value) {
                              //       if (value == null || value.isEmpty) {
                              //         return 'Please Enter Email';
                              //       } else if (!value.contains('@')) {
                              //         return 'Please Enter Valid Email';
                              //       }
                              //       return null;
                              //     },
                              //   ),
                              // ),
                              // const SizedBox(
                              //   height: 10,
                              // ),
                              const Text(
                                "Gender",
                                style: TextStyle(
                                  fontFamily: "Avenir LT Std",
                                  color: Color(0xFFB8B8B8),
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(
                                width: size.width,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: size.width * 0.06,
                                    ),
                                    Radio(
                                      value: 1,
                                      groupValue: _gradioSelected,
                                      activeColor: Colors.blue,
                                      onChanged: (int? value) {
                                        setState(() {
                                          _gradioSelected = value!;
                                          gender = 'Male';
                                        });
                                      },
                                    ),
                                    const Text(
                                      "Male",
                                      style: TextStyle(
                                        fontFamily: "Avenir LT Std",
                                        color: Color(0xFF000000),
                                        fontSize: 20,
                                      ),
                                    ),
                                    SizedBox(
                                      width: size.width * 0.2,
                                    ),
                                    Radio(
                                      value: 2,
                                      groupValue: _gradioSelected,
                                      activeColor: Colors.blue,
                                      onChanged: (int? value) {
                                        setState(() {
                                          _gradioSelected = value!;
                                          gender = 'Female';
                                        });
                                      },
                                    ),
                                    const Text(
                                      "Female",
                                      style: TextStyle(
                                        fontFamily: "Avenir LT Std",
                                        color: Color(0xFF000000),
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                child: GestureDetector(
                                  onTap: () async {
                                    await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1900),
                                      lastDate: DateTime(2025),
                                    ).then((selectedDate) {
                                      if (selectedDate != null) {
                                        dateController.text =
                                            DateFormat("yyyy-MM-dd")
                                                .format(selectedDate);
                                      }
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Flexible(
                                        child: TextFormField(
                                          enabled: false,
                                          style: const TextStyle(
                                            fontFamily: "Avenir LT Std",
                                            color: Color(0xFF000000),
                                            fontSize: 20,
                                          ),
                                          decoration: const InputDecoration(
                                            labelText: "DOB (Date of Birth)",
                                            labelStyle: TextStyle(
                                              fontFamily: "Avenir LT Std",
                                              color: Color(0xFFB8B8B8),
                                              fontSize: 16,
                                            ),
                                          ),
                                          keyboardType: TextInputType.name,
                                          controller: dateController,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please Enter Date';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 50,
                                      ),
                                      Flexible(
                                        child: InkWell(
                                          onTap: () async {
                                            await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(1900),
                                              lastDate: DateTime(2025),
                                            ).then((selectedDate) {
                                              if (selectedDate != null) {
                                                dateController.text =
                                                    DateFormat("yyyy-MM-dd")
                                                        .format(selectedDate);
                                              }
                                            });
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 13),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(4)),
                                                boxShadow: <BoxShadow>[
                                                  BoxShadow(
                                                      color: const Color(
                                                              0xffB8B8B8)
                                                          .withAlpha(100),
                                                      offset:
                                                          const Offset(0, 4),
                                                      blurRadius: 8,
                                                      spreadRadius: 2)
                                                ],
                                                color: Colors.white),
                                            child: const Text(
                                              'Select',
                                              style: TextStyle(
                                                fontFamily: "Avenir LT Std",
                                                color: Color(0xFF4682B4),
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              // const SizedBox(
                              //   height: 16,
                              // ),
                              // Container(
                              //   alignment: Alignment.center,
                              //   child: Row(
                              //     children: [
                              //       Flexible(
                              //         child: TextFormField(
                              //           style: const TextStyle(
                              //             fontFamily: "Avenir LT Std",
                              //             color: Color(0xFF000000),
                              //             fontSize: 20,
                              //           ),
                              //           decoration: const InputDecoration(
                              //             labelText: "Country of Residence",
                              //             labelStyle: TextStyle(
                              //               fontFamily: "Avenir LT Std",
                              //               color: Color(0xFFB8B8B8),
                              //               fontSize: 16,
                              //             ),
                              //           ),
                              //           keyboardType: TextInputType.name,
                              //           controller: countryController,
                              //           validator: (value) {
                              //             if (value == null || value.isEmpty) {
                              //               return 'Please Enter Country';
                              //             }
                              //             return null;
                              //           },
                              //         ),
                              //       ),
                              //       const SizedBox(
                              //         width: 50,
                              //       ),
                              //       Flexible(
                              //         child: InkWell(
                              //           onTap: () async {
                              //             showCountryPicker(
                              //               context: context,
                              //               //Optional.  Can be used to exclude(remove) one ore more country from the countries list (optional).
                              //               exclude: <String>['KN', 'MF'],
                              //               //Optional. Shows phone code before the country name.
                              //               showPhoneCode: true,
                              //               onSelect: (Country country) {
                              //                 countryController.text = country
                              //                     .displayNameNoCountryCode
                              //                     .toString();
                              //               },
                              //               // Optional. Sets the theme for the country list picker.
                              //               countryListTheme:
                              //                   CountryListThemeData(
                              //                 // Optional. Sets the border radius for the bottomsheet.
                              //                 borderRadius:
                              //                     const BorderRadius.only(
                              //                   topLeft: Radius.circular(40.0),
                              //                   topRight: Radius.circular(40.0),
                              //                 ),
                              //                 // Optional. Styles the search field.
                              //                 inputDecoration: InputDecoration(
                              //                   labelText: 'Search',
                              //                   hintText:
                              //                       'Start typing to search',
                              //                   prefixIcon:
                              //                       const Icon(Icons.search),
                              //                   border: OutlineInputBorder(
                              //                     borderSide: BorderSide(
                              //                       color: const Color(0xFF8C98A8)
                              //                           .withOpacity(0.2),
                              //                     ),
                              //                   ),
                              //                 ),
                              //               ),
                              //             );
                              //           },
                              //           child: Container(
                              //             width:
                              //                 MediaQuery.of(context).size.width,
                              //             padding: const EdgeInsets.symmetric(
                              //                 vertical: 13),
                              //             alignment: Alignment.center,
                              //             decoration: BoxDecoration(
                              //                 borderRadius:
                              //                     const BorderRadius.all(
                              //                         Radius.circular(4)),
                              //                 boxShadow: <BoxShadow>[
                              //                   BoxShadow(
                              //                       color: const Color(0xffB8B8B8)
                              //                           .withAlpha(100),
                              //                       offset: const Offset(0, 4),
                              //                       blurRadius: 8,
                              //                       spreadRadius: 2)
                              //                 ],
                              //                 color: Colors.white),
                              //             child: const Text(
                              //               'Select',
                              //               style: TextStyle(
                              //                 fontFamily: "Avenir LT Std",
                              //                 color: Color(0xFF4682B4),
                              //                 fontSize: 20,
                              //                 fontWeight: FontWeight.bold,
                              //               ),
                              //             ),
                              //           ),
                              //         ),
                              //       )
                              //     ],
                              //   ),
                              // ),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                  height: 100,
                                  width: size.width,
                                  alignment: Alignment.topLeft,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Phone",
                                        style: TextStyle(
                                          fontFamily: "Avenir LT Std",
                                          color: Color(0xFFB8B8B8),
                                          fontSize: 14,
                                        ),
                                      ),
                                      IntlPhoneField(
                                        decoration: const InputDecoration(
                                          counterStyle: TextStyle(fontSize: 0),
                                          // labelText: 'Phone',
                                          // labelStyle: TextStyle(
                                          //   fontFamily: "Avenir LT Std",
                                          //   color: Color(0xFFB8B8B8),
                                          //   fontSize: 16,
                                          // ),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(width: 20),
                                          ),
                                        ),
                                        initialCountryCode: countrycode,
                                        initialValue: numb,
                                        onChanged: (phone) {
                                          countrycode =
                                              phone.countryISOCode.toString();
                                          numb = phone.number.toString();
                                        },
                                      ),
                                    ],
                                  )),
                              const SizedBox(
                                height: 16,
                              ),
                              const Text(
                                "Disease Information",
                                style: TextStyle(
                                  fontFamily: "Avenir LT Std",
                                  color: Color(0xFF4682B4),
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // const SizedBox(
                              //   height: 16,
                              // ),
                              // const Text(
                              //   "Select condition.",
                              //   style: TextStyle(
                              //     fontFamily: "Avenir LT Std",
                              //     color: Color(0xFFB8B8B8),
                              //     fontSize: 14,
                              //   ),
                              // ),
                              // Container(
                              //   padding: const EdgeInsets.only(
                              //       left: 16.0, right: 16.0),
                              //   decoration: const BoxDecoration(
                              //     border: Border(
                              //       bottom:
                              //           BorderSide(color: Colors.grey, width: 1),
                              //     ),
                              //   ),
                              //   child: DropdownButtonHideUnderline(
                              //     child: DropdownButton(
                              //       hint: const Text('Condition'),
                              //       dropdownColor: Colors.white,
                              //       elevation: 5,
                              //       icon: const Icon(
                              //         Icons.arrow_drop_down,
                              //         color: Colors.blue,
                              //       ),
                              //       iconSize: 36.0,
                              //       isExpanded: true,
                              //       value: _disval,
                              //       style: const TextStyle(
                              //           color: Color(0xff2F3037), fontSize: 22.0),
                              //       onChanged: (value) {
                              //         setState(() {
                              //           _disval = value.toString();
                              //           grpnameset(_disval);
                              //         });
                              //       },
                              //       items: disList.map((value) {
                              //         return DropdownMenuItem(
                              //           value: value,
                              //           child: Text(
                              //             value,
                              //             style: const TextStyle(
                              //               fontFamily: "Avenir LT Std",
                              //               color: Color(0xFF000000),
                              //               fontSize: 20,
                              //             ),
                              //           ),
                              //         );
                              //       }).toList(),
                              //     ),
                              //   ),
                              // ),
                              // const SizedBox(
                              //   height: 16,
                              // ),
                              // const Text(
                              //   "Select support group.",
                              //   style: TextStyle(
                              //     fontFamily: "Avenir LT Std",
                              //     color: Color(0xFFB8B8B8),
                              //     fontSize: 14,
                              //   ),
                              // ),
                              // Container(
                              //   padding: const EdgeInsets.only(
                              //       left: 16.0, right: 16.0),
                              //   decoration: const BoxDecoration(
                              //     border: Border(
                              //       bottom:
                              //           BorderSide(color: Colors.grey, width: 1),
                              //     ),
                              //   ),
                              //   child: DropdownButtonHideUnderline(
                              //     child: DropdownButton(
                              //       hint: const Text('Group'),
                              //       dropdownColor: Colors.white,
                              //       elevation: 5,
                              //       icon: const Icon(
                              //         Icons.arrow_drop_down,
                              //         color: Colors.blue,
                              //       ),
                              //       iconSize: 36.0,
                              //       isExpanded: true,
                              //       value: grpval,
                              //       style: const TextStyle(
                              //           color: Color(0xff2F3037), fontSize: 22.0),
                              //       onChanged: (value) {
                              //         setState(() {
                              //           grpidsearch(value.toString(), grpList);
                              //           grpval = value.toString();
                              //         });
                              //       },
                              //       items: grpname.map((value) {
                              //         return DropdownMenuItem(
                              //           value: value,
                              //           child: Text(
                              //             value,
                              //             style: const TextStyle(
                              //               fontFamily: "Avenir LT Std",
                              //               color: Color(0xFF000000),
                              //               fontSize: 20,
                              //             ),
                              //           ),
                              //         );
                              //       }).toList(),
                              //     ),
                              //   ),
                              // ),
                              Container(
                                alignment: Alignment.center,
                                child: GestureDetector(
                                  onTap: () async {
                                    await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1900),
                                      lastDate: DateTime(2025),
                                    ).then((selectedDate) {
                                      if (selectedDate != null) {
                                        yearController.text =
                                            DateFormat("yyyy-MM-dd")
                                                .format(selectedDate);
                                      }
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Flexible(
                                        child: TextFormField(
                                          enabled: false,
                                          style: const TextStyle(
                                            fontFamily: "Avenir LT Std",
                                            color: Color(0xFF000000),
                                            fontSize: 20,
                                          ),
                                          decoration: const InputDecoration(
                                            labelText: "Year of Diagnosis",
                                            labelStyle: TextStyle(
                                              fontFamily: "Avenir LT Std",
                                              color: Color(0xFFB8B8B8),
                                              fontSize: 16,
                                            ),
                                          ),
                                          keyboardType: TextInputType.name,
                                          controller: yearController,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please Enter Year';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 50,
                                      ),
                                      Flexible(
                                        child: InkWell(
                                          onTap: () async {
                                            await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(1900),
                                              lastDate: DateTime(2025),
                                            ).then((selectedDate) {
                                              if (selectedDate != null) {
                                                yearController.text =
                                                    DateFormat("yyyy-MM-dd")
                                                        .format(selectedDate);
                                              }
                                            });
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 13),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(4)),
                                                boxShadow: <BoxShadow>[
                                                  BoxShadow(
                                                      color: const Color(
                                                              0xffB8B8B8)
                                                          .withAlpha(100),
                                                      offset:
                                                          const Offset(0, 4),
                                                      blurRadius: 8,
                                                      spreadRadius: 2)
                                                ],
                                                color: Colors.white),
                                            child: const Text(
                                              'Select',
                                              style: TextStyle(
                                                fontFamily: "Avenir LT Std",
                                                color: Color(0xFF4682B4),
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              // const SizedBox(
                              //   height: 16,
                              // ),
                              // const Text(
                              //   "Hospital",
                              //   style: TextStyle(
                              //     fontFamily: "Avenir LT Std",
                              //     color: Color(0xFFB8B8B8),
                              //     fontSize: 14,
                              //   ),
                              // ),
                              // Container(
                              //   padding: const EdgeInsets.only(
                              //       left: 16.0, right: 16.0),
                              //   decoration: const BoxDecoration(
                              //     border: Border(
                              //       bottom:
                              //           BorderSide(color: Colors.grey, width: 1),
                              //     ),
                              //   ),
                              //   child: DropdownButtonHideUnderline(
                              //     child: DropdownButton(
                              //       hint: const Text('Condition'),
                              //       dropdownColor: Colors.white,
                              //       elevation: 5,
                              //       icon: const Icon(
                              //         Icons.arrow_drop_down,
                              //         color: Colors.blue,
                              //       ),
                              //       iconSize: 36.0,
                              //       isExpanded: true,
                              //       value: hospitalVal,
                              //       style: const TextStyle(
                              //           color: Color(0xff2F3037), fontSize: 22.0),
                              //       onChanged: (value) {
                              //         setState(() {
                              //           hospitalVal = value.toString();
                              //         });
                              //       },
                              //       items: hospitalList.map((value) {
                              //         return DropdownMenuItem(
                              //           value: value,
                              //           child: Text(
                              //             value,
                              //             style: const TextStyle(
                              //               fontFamily: "Avenir LT Std",
                              //               color: Color(0xFF000000),
                              //               fontSize: 20,
                              //             ),
                              //           ),
                              //         );
                              //       }).toList(),
                              //     ),
                              //   ),
                              // ),
                              // const SizedBox(
                              //   height: 10,
                              // ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                alignment: Alignment.center,
                                child: TextFormField(
                                  style: const TextStyle(
                                    fontFamily: "Avenir LT Std",
                                    color: Color(0xFF000000),
                                    fontSize: 20,
                                  ),
                                  decoration: const InputDecoration(
                                    labelText: "Hospital",
                                    labelStyle: TextStyle(
                                      fontFamily: "Avenir LT Std",
                                      color: Color(0xFFB8B8B8),
                                      fontSize: 16,
                                    ),
                                  ),
                                  keyboardType: TextInputType.name,
                                  controller: hospitalController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please Enter Hospital';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                alignment: Alignment.center,
                                child: TextFormField(
                                  style: const TextStyle(
                                    fontFamily: "Avenir LT Std",
                                    color: Color(0xFF000000),
                                    fontSize: 20,
                                  ),
                                  decoration: const InputDecoration(
                                    labelText: "Medications",
                                    labelStyle: TextStyle(
                                      fontFamily: "Avenir LT Std",
                                      color: Color(0xFFB8B8B8),
                                      fontSize: 16,
                                    ),
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  controller: medicationController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please Enter Medications';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                alignment: Alignment.center,
                                child: TextFormField(
                                  style: const TextStyle(
                                    fontFamily: "Avenir LT Std",
                                    color: Color(0xFF000000),
                                    fontSize: 20,
                                  ),
                                  decoration: const InputDecoration(
                                    labelText: "Doctor",
                                    labelStyle: TextStyle(
                                      fontFamily: "Avenir LT Std",
                                      color: Color(0xFFB8B8B8),
                                      fontSize: 16,
                                    ),
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  controller: doctorController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please Enter Doctor';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              InkWell(
                                onTap: () async {
                                  await edit(
                                    context,
                                    nameController.text,
                                    gender,
                                    dateController.text,
                                    countrycode,
                                    numb,
                                    yearController.text,
                                    hospitalController.text,
                                    medicationController.text,
                                    doctorController.text,
                                  );
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 13),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(4)),
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                            color: const Color(0xffB8B8B8)
                                                .withAlpha(100),
                                            offset: const Offset(0, 4),
                                            blurRadius: 8,
                                            spreadRadius: 2)
                                      ],
                                      color: const Color(0xFF71B48D)),
                                  child: const Text(
                                    'SAVE',
                                    style: TextStyle(
                                      fontFamily: "Avenir LT Std",
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      // bottomNavigationBar: BottomNavigationBar(
      //   onTap: onTabTapped, // new
      //   selectedItemColor: const Color(0xFF71B48D),
      //   currentIndex: 1, // this will be set when a new tab is tapped
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: ImageIcon(
      //         AssetImage("assets/images/feed.png"),
      //       ),
      //       label: 'FEED',
      //       backgroundColor: null,
      //     ),
      //     BottomNavigationBarItem(
      //       icon: ImageIcon(
      //         AssetImage("assets/images/chat.png"),
      //       ),
      //       label: 'MENTORS',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: ImageIcon(
      //         AssetImage("assets/images/new.png"),
      //       ),
      //       label: "WHAT'S NEW",
      //     ),
      //   ],
      // ),
    );
  }
}

class Topbar extends StatelessWidget {
  const Topbar({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF2F9FF),
      child: Column(
        children: [
          SizedBox(
            height: size.height * 0.04,
          ),
          Container(
            height: size.height * 0.1,
            width: size.width,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: SizedBox(
                    width: size.width * 0.02,
                  ),
                ),
                Flexible(
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFF4682B4),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (_) => const ProfileScreen()));
                    },
                  ),
                ),
                Flexible(
                  child: SizedBox(
                    width: size.width * 0.02,
                  ),
                ),
                const Text("EDIT PROFILE",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF4682B4),
                      fontFamily: "Avenir LT Std",
                    )),
                // Flexible(
                //   child: TextFormField(
                //     style: const TextStyle(
                //       fontFamily: "Avenir LT Std",
                //       color: Color(0xFF4682B4),
                //       fontSize: 20,
                //     ),
                //     decoration: const InputDecoration(
                //       contentPadding: EdgeInsets.only(top: 10),
                //       labelText: "Search",
                //       labelStyle: TextStyle(
                //         fontFamily: "Avenir LT Std",
                //         color: Color(0xFF4682B4),
                //         fontSize: 16,
                //         height: 0.5,
                //       ),
                //     ),
                //     keyboardType: TextInputType.emailAddress,
                //     controller: searchController,
                //     validator: (value) {
                //       if (value == null) {
                //         return 'Please Enter a value.';
                //       }
                //       return null;
                //     },
                //   ),
                // ),
                // GestureDetector(
                //   onTap: () {},
                //   child: Image.asset(
                //     "assets/images/addec5a8-1f71-4772-96f0-843755aaaed1.png",
                //   ),
                // ),
                // GestureDetector(
                //   onTap: () {
                //     Scaffold.of(context).openEndDrawer();
                //   },
                //   child: Image.asset(
                //     "assets/images/53e933ab-b850-43e3-990f-61d635d4ac34.png",
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
