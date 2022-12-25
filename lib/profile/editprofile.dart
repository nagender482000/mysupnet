// ignore_for_file: avoid_print

import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;
import 'package:mysupnet/Apicalls/edit.dart';
import 'package:mysupnet/Apicalls/profilePic.dart';
import 'package:mysupnet/global.dart';
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
  bool hide_email = false;
  bool hide_gender = false;
  bool hide_date_of_birth = false;
  bool hide_phone = false;
  bool hide_support_group = false;
  bool hide_condition = false;
  bool hide_year_of_diagnosis = false;
  bool hide_hospital = false;
  bool hide_medications = false;
  bool hide_doctor = false;
  Widget img = const CircleAvatar(
      radius: 50,
      backgroundImage: AssetImage(
        "assets/images/user.png",
      ));
  String sentdate = "";
  String sentyear = "";
  TextEditingController emailController = TextEditingController();

  TextEditingController dateController = TextEditingController();

  TextEditingController yearController = TextEditingController();

  TextEditingController medicationController = TextEditingController();

  TextEditingController doctorController = TextEditingController();

  TextEditingController nameController = TextEditingController();

  TextEditingController hospitalController = TextEditingController();
  String formatISOTime(DateTime date) {
    //converts date into the following format:
// or 2019-06-04T12:08:56.235-0700
    var duration = date.timeZoneOffset;
    if (duration.isNegative)
      return (DateFormat("yyyy-MM-ddTHH:mm:ss.mmm").format(date) +
          "-${duration.inHours.toString().padLeft(2, '0')}${(duration.inMinutes - (duration.inHours * 60)).toString().padLeft(2, '0')}");
    else
      return (DateFormat("yyyy-MM-ddTHH:mm:ss.mmm").format(date) +
          "+${duration.inHours.toString().padLeft(2, '0')}${(duration.inMinutes - (duration.inHours * 60)).toString().padLeft(2, '0')}");
  }

  @override
  void initState() {
    getuser();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

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
    print(responseData);
    if (response.statusCode == 200) {
      userdata = responseData["data"];
      name = userdata["name"].toString();
      nameController.text = name;
      hide_email = userdata["hide_email"];
      hide_gender = userdata["hide_gender"];
      hide_date_of_birth = userdata["hide_date_of_birth"];
      hide_phone = userdata["hide_phone"];
      hide_support_group = userdata["hide_support_group"];
      hide_condition = userdata["hide_condition"];
      hide_year_of_diagnosis = userdata["hide_year_of_diagnosis"];
      hide_hospital = userdata["hide_hospital"];
      hide_medications = userdata["hide_medications"];
      hide_doctor = userdata["hide_doctor"];
      gender = userdata["gender"].toString();
      img = CachedNetworkImage(
        imageUrl: baseurl + userdata["photo"].toString(),
        imageBuilder: (context, imageProvider) => Container(
          width: 80.0,
          height: 80.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
          ),
        ),
        placeholder: (context, url) => const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Colors.blue,
                    ),
                  ),
                ),
        errorWidget: (context, url, error) => const CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage(
              "assets/images/user.png",
            )),
      );
      if (gender == "Male") {
        _gradioSelected = 1;
      } else {
        _gradioSelected = 2;
      }
      emailController.text = userdata["email"].toString();
      numb = userdata["phone"].toString();
      countrycode = userdata["country_code"].toString();
      if (userdata["date_of_birth"] != null) {
        sentdate = formatISOTime(DateTime.parse(userdata["date_of_birth"]));
        date = DateFormat("dd-MM-yyyy")
            .format(DateTime.parse(userdata["date_of_birth"].toString()))
            .toString();
      } else {
        date = "";
      }
      dateController.text = date;
      if (userdata["year_of_diagnosis"] != null) {
        sentyear = formatISOTime(DateTime.parse(userdata["year_of_diagnosis"]));
        year = DateFormat("dd-MM-yyyy")
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

  @override
  void dispose() {
    dateController.dispose();
    medicationController.dispose();
    yearController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

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
                                  Flexible(child: img),
                                  const SizedBox(
                                    width: 50,
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      FilePickerResult? result =
                                          await FilePicker.platform.pickFiles();

                                      if (result != null) {
                                        PlatformFile file = result.files.first;
                                        print(file.name);
                                        print(file.path);
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                backgroundColor: Colors.white,
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: const [
                                                    CircularProgressIndicator
                                                        .adaptive(),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    Text(
                                                      "Uploading...",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 17,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            });
                                        await profilepic(file.path);
                                        Navigator.pop(context);
                                        setState(() {
                                          if (file.path.toString() != "") {
                                            img = Image.file(
                                                File(file.path.toString()));
                                          }
                                        });
                                      }
                                    },
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
                              SizedBox(
                                width: size.width,
                                child: Row(
                                  children: [
                                    Container(
                                      width: size.width * 0.75,
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
                                      width: 10,
                                    ),
                                    Flexible(
                                      child: Column(
                                        children: [
                                          const Text(
                                            "Visble to all?",
                                            style: TextStyle(
                                              fontFamily: "Avenir LT Std",
                                              color: Color(0xFF4682B4),
                                              fontSize: 16,
                                            ),
                                          ),
                                          Switch(
                                            onChanged: (asd) {},
                                            value: true,
                                            activeColor:
                                                const Color(0xFF4682B4),
                                            activeTrackColor:
                                                const Color(0xFF4682B4),
                                            inactiveThumbColor: Colors.grey,
                                            inactiveTrackColor: Colors.grey,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                width: size.width,
                                child: Row(
                                  children: [
                                    Container(
                                      width: size.width * 0.75,
                                      alignment: Alignment.center,
                                      child: TextFormField(
                                        enabled: false,
                                        style: const TextStyle(
                                          fontFamily: "Avenir LT Std",
                                          color: Color(0xFF000000),
                                          fontSize: 20,
                                        ),
                                        decoration: const InputDecoration(
                                          labelText: "Email",
                                          labelStyle: TextStyle(
                                            fontFamily: "Avenir LT Std",
                                            color: Color(0xFFB8B8B8),
                                            fontSize: 16,
                                          ),
                                        ),
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        controller: emailController,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please Enter Email';
                                          } else if (!value.contains('@')) {
                                            return 'Please Enter Valid Email';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Flexible(
                                      child: Switch(
                                        onChanged: (asc) {
                                          if (hide_email == true) {
                                            setState(() {
                                              hide_email = false;
                                            });
                                            print('Switch Button is OFF');
                                          } else {
                                            setState(() {
                                              hide_email = true;
                                            });
                                            print('Switch Button is ON');
                                          }
                                        },
                                        value: hide_email,
                                        activeColor: const Color(0xFF4682B4),
                                        activeTrackColor:
                                            const Color(0xFF4682B4),
                                        inactiveThumbColor: Colors.grey,
                                        inactiveTrackColor: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
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
                                  children: [
                                    SizedBox(
                                      width: size.width * .75,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
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
                                            width: size.width * 0.1,
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
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Flexible(
                                      child: Switch(
                                        onChanged: (asc) {
                                          if (hide_gender == true) {
                                            setState(() {
                                              hide_gender = false;
                                            });
                                            print('Switch Button is OFF');
                                          } else {
                                            setState(() {
                                              hide_gender = true;
                                            });
                                            print('Switch Button is ON');
                                          }
                                        },
                                        value: hide_gender,
                                        activeColor: const Color(0xFF4682B4),
                                        activeTrackColor:
                                            const Color(0xFF4682B4),
                                        inactiveThumbColor: Colors.grey,
                                        inactiveTrackColor: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: size.width,
                                child: Row(
                                  children: [
                                    Container(
                                      width: size.width * .75,
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
                                              sentdate =
                                                  formatISOTime(selectedDate);
                                              dateController.text =
                                                  DateFormat("dd-MM-yyyy")
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
                                                decoration:
                                                    const InputDecoration(
                                                  labelText:
                                                      "DOB (Date of Birth)",
                                                  labelStyle: TextStyle(
                                                    fontFamily: "Avenir LT Std",
                                                    color: Color(0xFFB8B8B8),
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                keyboardType:
                                                    TextInputType.name,
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
                                                      sentdate = formatISOTime(
                                                          selectedDate);
                                                      dateController
                                                          .text = DateFormat(
                                                              "dd-MM-yyyy")
                                                          .format(selectedDate);
                                                    }
                                                  });
                                                },
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 10),
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  4)),
                                                      boxShadow: <BoxShadow>[
                                                        BoxShadow(
                                                            color: const Color(
                                                                    0xffB8B8B8)
                                                                .withAlpha(100),
                                                            offset:
                                                                const Offset(
                                                                    0, 4),
                                                            blurRadius: 8,
                                                            spreadRadius: 2)
                                                      ],
                                                      color: Colors.white),
                                                  child: const Text(
                                                    'Select',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          "Avenir LT Std",
                                                      color: Color(0xFF4682B4),
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Flexible(
                                      child: Switch(
                                        onChanged: (asc) {
                                          if (hide_date_of_birth == true) {
                                            setState(() {
                                              hide_date_of_birth = false;
                                            });
                                            print('Switch Button is OFF');
                                          } else {
                                            setState(() {
                                              hide_date_of_birth = true;
                                            });
                                            print('Switch Button is ON');
                                          }
                                        },
                                        value: hide_date_of_birth,
                                        activeColor: const Color(0xFF4682B4),
                                        activeTrackColor:
                                            const Color(0xFF4682B4),
                                        inactiveThumbColor: Colors.grey,
                                        inactiveTrackColor: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                width: size.width,
                                child: Row(
                                  children: [
                                    Container(
                                        height: 100,
                                        width: size.width * .75,
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
                                                counterStyle:
                                                    TextStyle(fontSize: 0),
                                                border: OutlineInputBorder(
                                                  borderSide:
                                                      BorderSide(width: 20),
                                                ),
                                              ),
                                              initialCountryCode: countrycode,
                                              initialValue: numb,
                                              onChanged: (phone) {
                                                countrycode = phone
                                                    .countryISOCode
                                                    .toString();
                                                numb = phone.number.toString();
                                              },
                                            ),
                                          ],
                                        )),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Flexible(
                                      child: Switch(
                                        onChanged: (asc) {
                                          if (hide_phone == true) {
                                            setState(() {
                                              hide_phone = false;
                                            });
                                            print('Switch Button is OFF');
                                          } else {
                                            setState(() {
                                              hide_phone = true;
                                            });
                                            print('Switch Button is ON');
                                          }
                                        },
                                        value: hide_phone,
                                        activeColor: const Color(0xFF4682B4),
                                        activeTrackColor:
                                            const Color(0xFF4682B4),
                                        inactiveThumbColor: Colors.grey,
                                        inactiveTrackColor: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
                              SizedBox(
                                width: size.width,
                                child: Row(
                                  children: [
                                    Container(
                                      width: size.width * .75,
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
                                              sentyear =
                                                  selectedDate.toString();
                                              yearController.text =
                                                  DateFormat("dd-MM-yyyy")
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
                                                decoration:
                                                    const InputDecoration(
                                                  labelText:
                                                      "Year of Diagnosis",
                                                  labelStyle: TextStyle(
                                                    fontFamily: "Avenir LT Std",
                                                    color: Color(0xFFB8B8B8),
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                keyboardType:
                                                    TextInputType.name,
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
                                                      sentyear = selectedDate
                                                          .toString();
                                                      yearController
                                                          .text = DateFormat(
                                                              "dd-MM-yyyy")
                                                          .format(selectedDate);
                                                    }
                                                  });
                                                },
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 10),
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  4)),
                                                      boxShadow: <BoxShadow>[
                                                        BoxShadow(
                                                            color: const Color(
                                                                    0xffB8B8B8)
                                                                .withAlpha(100),
                                                            offset:
                                                                const Offset(
                                                                    0, 4),
                                                            blurRadius: 8,
                                                            spreadRadius: 2)
                                                      ],
                                                      color: Colors.white),
                                                  child: const Text(
                                                    'Select',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          "Avenir LT Std",
                                                      color: Color(0xFF4682B4),
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Flexible(
                                      child: Switch(
                                        onChanged: (asc) {
                                          if (hide_year_of_diagnosis == true) {
                                            setState(() {
                                              hide_year_of_diagnosis = false;
                                            });
                                            print('Switch Button is OFF');
                                          } else {
                                            setState(() {
                                              hide_year_of_diagnosis = true;
                                            });
                                            print('Switch Button is ON');
                                          }
                                        },
                                        value: hide_year_of_diagnosis,
                                        activeColor: const Color(0xFF4682B4),
                                        activeTrackColor:
                                            const Color(0xFF4682B4),
                                        inactiveThumbColor: Colors.grey,
                                        inactiveTrackColor: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                width: size.width,
                                child: Row(
                                  children: [
                                    Container(
                                      width: size.width * .75,
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
                                      width: 10,
                                    ),
                                    Flexible(
                                      child: Switch(
                                        onChanged: (asc) {
                                          if (hide_hospital == true) {
                                            setState(() {
                                              hide_hospital = false;
                                            });
                                            print('Switch Button is OFF');
                                          } else {
                                            setState(() {
                                              hide_hospital = true;
                                            });
                                            print('Switch Button is ON');
                                          }
                                        },
                                        value: hide_hospital,
                                        activeColor: const Color(0xFF4682B4),
                                        activeTrackColor:
                                            const Color(0xFF4682B4),
                                        inactiveThumbColor: Colors.grey,
                                        inactiveTrackColor: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                width: size.width,
                                child: Row(
                                  children: [
                                    Container(
                                      width: size.width * .75,
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
                                        keyboardType:
                                            TextInputType.emailAddress,
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
                                      width: 10,
                                    ),
                                    Flexible(
                                      child: Switch(
                                        onChanged: (asc) {
                                          if (hide_medications == true) {
                                            setState(() {
                                              hide_medications = false;
                                            });
                                            print('Switch Button is OFF');
                                          } else {
                                            setState(() {
                                              hide_medications = true;
                                            });
                                            print('Switch Button is ON');
                                          }
                                        },
                                        value: hide_medications,
                                        activeColor: const Color(0xFF4682B4),
                                        activeTrackColor:
                                            const Color(0xFF4682B4),
                                        inactiveThumbColor: Colors.grey,
                                        inactiveTrackColor: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                child: Row(
                                  children: [
                                    Container(
                                      width: size.width * .75,
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
                                        keyboardType:
                                            TextInputType.emailAddress,
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
                                      width: 10,
                                    ),
                                    Flexible(
                                      child: Switch(
                                        onChanged: (asc) {
                                          if (hide_doctor == true) {
                                            setState(() {
                                              hide_doctor = false;
                                            });
                                            print('Switch Button is OFF');
                                          } else {
                                            setState(() {
                                              hide_doctor = true;
                                            });
                                            print('Switch Button is ON');
                                          }
                                        },
                                        value: hide_doctor,
                                        activeColor: const Color(0xFF4682B4),
                                        activeTrackColor:
                                            const Color(0xFF4682B4),
                                        inactiveThumbColor: Colors.grey,
                                        inactiveTrackColor: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              InkWell(
                                onTap: () async {
                                  if (sentdate.toString() == "") {
                                    Fluttertoast.showToast(
                                        msg: "Please Select DOB.");
                                  } else if (sentyear.toString() == "") {
                                    Fluttertoast.showToast(
                                        msg: "Please Select Year of Diagnosis");
                                  } else {
                                    await edit(
                                      context,
                                      nameController.text,
                                      gender,
                                      sentdate,
                                      countrycode,
                                      numb,
                                      sentyear,
                                      hospitalController.text,
                                      medicationController.text,
                                      doctorController.text,
                                      toBeginningOfSentenceCase(
                                          hide_email.toString()),
                                      toBeginningOfSentenceCase(
                                          hide_gender.toString()),
                                      toBeginningOfSentenceCase(
                                          hide_date_of_birth.toString()),
                                      toBeginningOfSentenceCase(
                                          hide_phone.toString()),
                                      toBeginningOfSentenceCase(
                                          hide_support_group.toString()),
                                      toBeginningOfSentenceCase(
                                          hide_condition.toString()),
                                      toBeginningOfSentenceCase(
                                          hide_year_of_diagnosis.toString()),
                                      toBeginningOfSentenceCase(
                                          hide_hospital.toString()),
                                      toBeginningOfSentenceCase(
                                          hide_medications.toString()),
                                      toBeginningOfSentenceCase(
                                          hide_doctor.toString()),
                                    );
                                  }
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
