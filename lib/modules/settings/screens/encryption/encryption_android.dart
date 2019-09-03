import 'package:aurorafiles/shared_ui/app_button.dart';
import 'package:flutter/material.dart';

class EncryptionAndroid extends StatefulWidget {
  @override
  _EncryptionAndroidState createState() => _EncryptionAndroidState();
}

class _EncryptionAndroidState extends State<EncryptionAndroid> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Encryption"),
      ),
      body: ListView(
        children: <Widget>[
          SwitchListTile(
            value: true,
            onChanged: (bool v) {},
            title: Text("Enable Paranoid Encryption"),
          ),
          Divider(height: 0),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Files are encrypted/decrypted right on this device, even the server itself cannot get access to non-encrypted content of paranoid-encrypted files. Encryption method is AES256.",
              style: Theme.of(context).textTheme.caption,
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: Text("Encryption key:"),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text("To start using encryption of uploaded files your need to set any encryption key.", style: Theme.of(context).textTheme.caption,),
          ),
          SizedBox(height: 8.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
            child: AppButton(child: Text("IMPORT KEY FROM TEXT"), onPressed: () {},),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
            child: AppButton(child: Text("IMPORT KEY FROM FILE"), onPressed: () {},),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
            child: AppButton(child: Text("GENERATE KEYS"), onPressed: () {},),
          ),
        ],
      ),
    );
  }
}
