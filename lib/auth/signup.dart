import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:mysupnet/Apicalls/reg.dart';
import 'package:mysupnet/auth/login.dart';
import 'package:mysupnet/fadetransition.dart';
import 'package:mysupnet/auth/terms.dart';
import 'package:http/http.dart' as http;
import 'package:dropdown_button2/dropdown_button2.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  var _isLoading = false;

  late bool _isObscure = true;
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final nameController = TextEditingController();

  String _disval = "Select Condition";
  List<String> disList = ["Select Condition"];
  List<dynamic> grpList = [];
  List<dynamic> grpidList = [];
  List<String> grpname = ["Select Group"];
  LinkedHashMap<String, dynamic> templist = LinkedHashMap();

  String grpval = "Select Group";
  int _gradioSelected = 1;
  int _mradioSelected = 1;
  int _rradioSelected = 1;
  String numb = "";
  String grpid = "1";

  // ignore: non_constant_identifier_names
  String _under_medication = "True";
  String _gender = "Male";
  String message = "";
  String _role = "Patient";
  // ignore: non_constant_identifier_names
  String country_code = "IND";

  @override
  void initState() {
    super.initState();

    getConditionData();
  }

  getConditionData() async {
    var request = http.MultipartRequest(
        'GET',
        Uri.parse(
            'https://apis.mysupnet.org/api/v1/supportgroup/disease/list'));
    http.StreamedResponse response = await request.send();
    var responsed = await http.Response.fromStream(response);
    final item = json.decode(responsed.body);
    setState(() {
      _isLoading = true;

      item.forEach((key, value1) {
        disList.add(key);
        //_disval = disList[0];
      });
    });

    setState(() {
      _isLoading = false;
    });
  }

  getGroupData(int index) async {
    var request = http.MultipartRequest(
        'GET',
        Uri.parse(
            'https://apis.mysupnet.org/api/v1/supportgroup/disease/list'));
    http.StreamedResponse response = await request.send();
    var responsed = await http.Response.fromStream(response);
    final item = json.decode(responsed.body);
    int i = 0;

    setState(() {
      _isLoading = true;
      item.forEach((key, value1) {
        templist.addAll(value1);
        templist.forEach((key, value2) {
          if (i % 2 == 1) {
            grpList.add(value2);
          }
          i++;
        });
      });

      i = 0;
      for (var element in grpList) {
        if (i == index) {
          grpidList.addAll(element);
        }
        i++;
      }

      grpname.clear();
      for (i = 0; i < grpidList.length; i++) {
        grpname.add(grpidList[i]["name"]);
      }

      grpval = grpname[0];
      grpidsearch(grpval, grpList);
      grpidList.clear();
    });

    setState(() {
      _isLoading = false;
    });
  }

  void grpnameset(String disval) {
    int index = 0;
    for (int i = 0; i < disList.length; i++) {
      if (disList[i] == disval) {
        index = i;
        break;
      }
    }
    getGroupData(index);
  }

  void grpidsearch(
    String searchval,
    grpList,
  ) {
    for (int i = 0; i < grpList.length; i++) {
      for (int j = 0; j < grpList[i].length; j++) {
        if (grpList[i][j]["name"] == searchval) {
          grpid = grpList[i][j]["id"].toString();
          break;
        }
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2F9FF),
        bottomOpacity: 0.0,
        elevation: 0.0,
        title: const Text(
          "Create an Account",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: "Avenir LT Std",
            color: Color(0xFF4682B4),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF4682B4),
          ),
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(CustomPageRoute(const LoginPage()));
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Builder(
              builder: (context) => SizedBox(
                width: size.width,
                height: size.height * 2,
                child: SingleChildScrollView(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                          Container(
                            alignment: Alignment.center,
                            child: TextFormField(
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
                              keyboardType: TextInputType.emailAddress,
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
                              decoration: InputDecoration(
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: IconButton(
                                      icon: Icon(
                                        _isObscure
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Colors.blue,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isObscure = !_isObscure;
                                        });
                                      }),
                                ),
                                labelText: 'Password',
                                labelStyle: const TextStyle(
                                  fontFamily: "Avenir LT Std",
                                  color: Color(0xFFB8B8B8),
                                  fontSize: 16,
                                ),
                              ),
                              obscureText: _isObscure,
                              autofocus: false,
                              controller: passwordController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please Enter Password';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                              height: 100,
                              width: size.width,
                              alignment: Alignment.topLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                    initialCountryCode: 'IN',
                                    onChanged: (phone) {
                                      country_code =
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
                                      _gender = 'Male';
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
                                      _gender = 'Female';
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
                          SizedBox(height: size.height * 0.04),
                          const Text(
                            "Disease Information",
                            style: TextStyle(
                              fontFamily: "Avenir LT Std",
                              color: Color(0xFF4682B4),
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          const Text(
                            "Select condition.",
                            style: TextStyle(
                              fontFamily: "Avenir LT Std",
                              color: Color(0xFFB8B8B8),
                              fontSize: 14,
                            ),
                          ),
                          Container(
                            padding:
                                const EdgeInsets.only(left: 16.0, right: 16.0),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom:
                                    BorderSide(color: Colors.grey, width: 1),
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2(
                                hint: const Text('Condition'),
                                icon: const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.blue,
                                ),
                                iconSize: 36.0,
                                isExpanded: true,
                                value: _disval,
                                style: const TextStyle(
                                    color: Color(0xff2F3037), fontSize: 22.0),
                                onChanged: (value) {
                                  if (value != "Select Condition") {
                                    disList.remove("Select Condition");
                                    _disval = disList[0];
                                    setState(() {
                                      _disval = value.toString();
                                      grpnameset(_disval);
                                    });
                                  }
                                },
                                items: disList.map((value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: const TextStyle(
                                        fontFamily: "Avenir LT Std",
                                        color: Color(0xFF000000),
                                        fontSize: 20,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          const Text(
                            "Select support group.",
                            style: TextStyle(
                              fontFamily: "Avenir LT Std",
                              color: Color(0xFFB8B8B8),
                              fontSize: 14,
                            ),
                          ),
                          Container(
                            padding:
                                const EdgeInsets.only(left: 16.0, right: 16.0),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom:
                                    BorderSide(color: Colors.grey, width: 1),
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2(
                                hint: const Text('Group'),
                                // dropdownColor: Colors.white,
                                // elevation: 5,
                                icon: const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.blue,
                                ),
                                iconSize: 36.0,
                                isExpanded: true,
                                value: grpval,
                                style: const TextStyle(
                                    color: Color(0xff2F3037), fontSize: 22.0),
                                onChanged: (value) {
                                  setState(() {
                                    grpidsearch(value.toString(), grpList);
                                    grpval = value.toString();
                                  });
                                },
                                items: grpname.map((value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: const TextStyle(
                                        fontFamily: "Avenir LT Std",
                                        color: Color(0xFF000000),
                                        fontSize: 20,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          const Text(
                            "Under Medication?",
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
                                  groupValue: _mradioSelected,
                                  activeColor: Colors.blue,
                                  onChanged: (int? value) {
                                    setState(() {
                                      _mradioSelected = value!;
                                      _under_medication = 'True';
                                    });
                                  },
                                ),
                                const Text(
                                  "Yes",
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
                                  groupValue: _mradioSelected,
                                  activeColor: Colors.blue,
                                  onChanged: (int? value) {
                                    setState(() {
                                      _mradioSelected = value!;
                                      _under_medication = 'False';
                                    });
                                  },
                                ),
                                const Text(
                                  "No",
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
                            height: 16,
                          ),
                          const Text(
                            "Role",
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
                                  groupValue: _rradioSelected,
                                  activeColor: Colors.blue,
                                  onChanged: (int? value) {
                                    setState(() {
                                      _rradioSelected = value!;
                                      _role = 'Patient';
                                    });
                                  },
                                ),
                                const Text(
                                  "Patient",
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
                                  groupValue: _rradioSelected,
                                  activeColor: Colors.blue,
                                  onChanged: (int? value) {
                                    setState(() {
                                      _rradioSelected = value!;
                                      _role = 'Caregiver';
                                    });
                                  },
                                ),
                                const Text(
                                  "Caregiver",
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
                            height: 20,
                          ),
                          SizedBox(
                            width: size.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Wrap(
                                  children: [
                                    const Text(
                                      "By creating an account you agree to our",
                                      style: TextStyle(
                                        fontFamily: "Avenir LT Std",
                                        color: Color(0xFF4078A6),
                                        fontSize: 12,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            backgroundColor: Colors.transparent,
                                            builder: (BuildContext bc) {
                                              return const TermsBottomSheet();
                                            });
                                      },
                                      child: const Text.rich(
                                        TextSpan(
                                          text: '     ',
                                          style: TextStyle(
                                            fontFamily: "Avenir LT Std",
                                            color: Color(0xFF4078A6),
                                            fontSize: 12,
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text:
                                                  'Terms of Service and Privacy Policy',
                                              style: TextStyle(
                                                decoration:
                                                    TextDecoration.underline,
                                                fontFamily: "Avenir LT Std",
                                                color: Color(0xFF4078A6),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40.0,
                              vertical: 20.0,
                            ),
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    showDialog(
                                        barrierColor: const Color(0xaaFFFFFF),
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return WillPopScope(
                                            onWillPop: () async => false,
                                            child: SizedBox(
                                              height: 40,
                                              width: 40,
                                              child: Transform.scale(
                                                scale: 0.05,
                                                child:
                                                    const CircularProgressIndicator(
                                                  strokeWidth: 50,
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                                    message = await reg(
                                        context,
                                        nameController.text,
                                        emailController.text,
                                        passwordController.text,
                                        _under_medication.toString(),
                                        numb,
                                        _role.toString(),
                                        grpid.toString(),
                                        _gender.toString(),
                                        country_code,
                                        _disval);
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 13),
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
                                      'SIGN UP',
                                      style: TextStyle(
                                        fontFamily: "Avenir LT Std",
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
