import 'package:flutter/material.dart';

class UploadingDialog extends StatefulWidget {
  const UploadingDialog({
    Key? key,
  }) : super(key: key);

  @override
  _UploadingDialogState createState() => _UploadingDialogState();
}

class _UploadingDialogState extends State<UploadingDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          CircularProgressIndicator.adaptive(),
          SizedBox(
            height: 20,
          ),
          Text(
            "Uploading...",
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
            ),
          ),
        ],
      ),
    );
  }
}
