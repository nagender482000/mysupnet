import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mysupnet/Apicalls/forgotapi.dart';

class ForgotPassBottomSheet extends StatefulWidget {
  final String email;
  const ForgotPassBottomSheet({Key? key, required this.email})
      : super(key: key);

  @override
  _ForgotPassBottomSheetState createState() => _ForgotPassBottomSheetState();
}

class _ForgotPassBottomSheetState extends State<ForgotPassBottomSheet> {
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();

  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      // padding: const EdgeInsets.symmetric(
      //   horizontal: 25,
      //   vertical: 30,
      // ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 30,
        left: 25,
        right: 25,
      ),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      child: Wrap(
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Enter new Password",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Avenir LT Std",
                  color: Color(0xFF000000),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: size.height * 0.02),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                child: TextFormField(
                  style: const TextStyle(
                    fontFamily: "Avenir LT Std",
                    color: Color(0xFF000000),
                    fontSize: 20,
                  ),
                  decoration: const InputDecoration(
                    labelText: "New Password",
                    labelStyle: TextStyle(
                      fontFamily: "Avenir LT Std",
                      color: Color(0xFFB8B8B8),
                      fontSize: 16,
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  controller: passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Password';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: size.height * 0.02),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                child: TextFormField(
                  style: const TextStyle(
                    fontFamily: "Avenir LT Std",
                    color: Color(0xFF000000),
                    fontSize: 20,
                  ),
                  decoration: const InputDecoration(
                    labelText: "Confirm New Password",
                    labelStyle: TextStyle(
                      fontFamily: "Avenir LT Std",
                      color: Color(0xFFB8B8B8),
                      fontSize: 16,
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  controller: confirmpasswordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Confirm Password';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: size.height * 0.02),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: InkWell(
                  onTap: () async {
                    if (confirmpasswordController.text ==
                        passwordController.text) {
                      setState(() {
                        isloading = true;
                      });
                      await fpass(
                          context, widget.email, passwordController.text);
                      //await forgot(context, emailController.text);
                      setState(() {
                        isloading = false;
                      });
                    } else {
                      Fluttertoast.showToast(msg: "Password Mismatch!!");
                    }
                  },
                  child: isloading
                      ? const Center(child: CircularProgressIndicator())
                      : Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4)),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color:
                                        const Color(0xffB8B8B8).withAlpha(100),
                                    offset: const Offset(0, 4),
                                    blurRadius: 8,
                                    spreadRadius: 2)
                              ],
                              color: const Color(0xFF71B48D)),
                          child: const Text(
                            'SUBMIT',
                            style: TextStyle(
                              fontFamily: "Avenir LT Std",
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
