import 'package:aurorafiles/store/app_state.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FileWidget extends StatelessWidget {
  final file;

  const FileWidget({Key key, @required this.file}) : super(key: key);

  Widget _getThumbnail(BuildContext context) {
    if (file["ThumbnailUrl"] != null) {
      return SizedBox(
        width: 48.0,
        child: Image.network(
          '${SingletonStore.instance.hostName}/${file["ThumbnailUrl"]}',
          headers: {
            'Authorization': 'Bearer ${SingletonStore.instance.authToken}'
          },
        ),
      );
    } else {
      return Icon(Icons.description, size: 48.0, color: Colors.grey[700]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 6.0),
        ListTile(
          leading: _getThumbnail(context),
          title: Text(file["Name"]),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(filesize(file["Size"])),
              SizedBox(height: 4.0),
              Text(DateFormat("dd MMM yyyy").format(
                  DateTime.fromMillisecondsSinceEpoch(
                      (file["LastModified"] * 1000))))
            ],
          ),
        ),
        SizedBox(height: 6.0),
        Padding(
          padding: const EdgeInsets.only(left: 80.0),
          child: Divider(height: 0.0),
        ),
      ],
    );
  }
}
