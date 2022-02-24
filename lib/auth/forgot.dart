import 'package:flutter/material.dart';

class ForgotBottomSheet extends StatefulWidget {
  const ForgotBottomSheet({Key? key}) : super(key: key);

  @override
  _ForgotBottomSheetState createState() => _ForgotBottomSheetState();
}

class _ForgotBottomSheetState extends State<ForgotBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 30,
      ),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      child: Wrap(
        children: <Widget>[
          Column(
            children: [
              const Text(
                "Please check the email provided for instructions to reset the password.",
                style: TextStyle(
                  fontFamily: "Avenir LT Std",
                  color: Color(0xFF000000),
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: InkWell(
                  onTap: () {
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
                              color: const Color(0xffB8B8B8).withAlpha(100),
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
              ),
            ],
          ),
        ],
      ),
    );
  }
}
