import 'package:flutter/material.dart';
import 'package:mysupnet/Apicalls/log.dart';
import 'package:mysupnet/auth/forgot.dart';
import 'package:mysupnet/auth/signup.dart';
import 'package:mysupnet/fadetransition.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  late bool _isObscure = true;

 

  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(00.0),
        child: AppBar(
          backgroundColor: Colors.white,
          bottomOpacity: 0.0,
          elevation: 0.0,
        ),
      ),
      backgroundColor: Colors.white,
      body: Builder(builder: (context) {
        return SizedBox(
          width: size.width,
          height: size.height,
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 60,
                      left: 30,
                      right: 30,
                    ),
                    child: Image.asset("assets/images/nameArtboard 1.png"),
                  ),
                  SizedBox(height: size.height * 0.05),
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
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
                  SizedBox(height: size.height * 0.03),
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
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
                  SizedBox(height: size.height * 0.03),
                  Row(
                    children: [
                      // Checkbox(
                      //   value: rememberMe,
                      //   onChanged: _onRememberMeChanged,
                      // ),
                      // const Text(
                      //   "Keep me logged in",
                      //   style: TextStyle(
                      //     fontFamily: "Avenir LT Std",
                      //     color: Color(0xFF4078A6),
                      //     fontSize: 12,
                      //   ),
                      // ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (BuildContext bc) {
                                return const ForgotBottomSheet();
                              });
                        },
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(
                            fontFamily: "Avenir LT Std",
                            color: Color(0xFF4078A6),
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.12),
                  Padding(
                    padding: const EdgeInsets.all(40.0),
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
                                        child: const CircularProgressIndicator(
                                          strokeWidth: 50,
                                        ),
                                      ),
                                    ),
                                  );
                                });
                            // SharedPreferences prefs =
                            //     await SharedPreferences.getInstance();
                            // String token = prefs.getString('token').toString();
                            await log(
                              emailController.text,
                              passwordController.text,
                              context,
                            );
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(4)),
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
                              'LOG IN',
                              style: TextStyle(
                                fontFamily: "Avenir LT Std",
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: size.height * 0.03),
                        InkWell(
                          onTap: () async {
                            Navigator.of(context).pop();
                            Navigator.of(context)
                                .push(CustomPageRoute(const SignupPage()));
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(4)),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: const Color(0xffB8B8B8)
                                          .withAlpha(100),
                                      offset: const Offset(0, 4),
                                      blurRadius: 8,
                                      spreadRadius: 2)
                                ],
                                color: Colors.white),
                            child: const Text(
                              'SIGN UP',
                              style: TextStyle(
                                fontFamily: "Avenir LT Std",
                                color: Color(0xFF71B48D),
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
        );
      }),
    );
  }
}
