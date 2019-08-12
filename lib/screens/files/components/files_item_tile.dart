import 'package:flutter/material.dart';

// wrapper for file items
class FilesItemTile extends StatelessWidget {
  final ListTile child;

  const FilesItemTile({Key key, @required this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 6.0),
        child,
        SizedBox(height: 6.0),
        Padding(
          padding: const EdgeInsets.only(left: 80.0),
          child: Divider(height: 0.0),
        ),
      ],
    );
  }
}
