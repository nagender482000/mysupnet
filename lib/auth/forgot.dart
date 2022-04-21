import 'package:flutter/material.dart';
import 'package:mysupnet/Apicalls/forgotapi.dart';

class ForgotBottomSheet extends StatefulWidget {
  const ForgotBottomSheet({Key? key}) : super(key: key);

  @override
  _ForgotBottomSheetState createState() => _ForgotBottomSheetState();
}

class _ForgotBottomSheetState extends State<ForgotBottomSheet> {
  final emailController = TextEditingController();
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
                "Please check the email provided for instructions to reset the password.",
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
              SizedBox(height: size.height * 0.02),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: InkWell(
                  onTap: () async {
                    setState(() {
                      isloading = true;
                    });
                    await forgot(context, emailController.text);
                    setState(() {
                      isloading = false;
                    });
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
