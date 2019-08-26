import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class InfoListTile extends StatelessWidget {
  final String label;
  final String content;
  final bool isOffline;
  final bool isPublic;
  final bool isEncrypted;

  const InfoListTile({
    Key key,
    @required this.label,
    @required this.content,
    this.isOffline = false,
    this.isPublic = false,
    this.isEncrypted = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(label, style: Theme.of(context).textTheme.caption),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(content, style: Theme.of(context).textTheme.subhead),
            Theme(
              data: Theme.of(context).copyWith(
                iconTheme: IconThemeData(
                  color: Theme.of(context).disabledColor,
                  size: 18.0,
                ),
              ),
              child: Row(
                children: <Widget>[
                  if (isPublic) SizedBox(width: 10),
                  if (isPublic)
                    Icon(
                      Icons.link,
                      semanticLabel: "Has public link",
                    ),
                  if (isOffline) SizedBox(width: 10),
                  if (isOffline)
                    Icon(
                      Icons.airplanemode_active,
                      semanticLabel: "Available offline",
                    ),
                  if (isEncrypted) SizedBox(width: 10),
                  if (isEncrypted)
                    Icon(
                      MdiIcons.alien,
                      semanticLabel: "Encrypted",
                    ),
                ],
              ),
            )
          ],
        ),
        Divider(
          height: 26.0,
        ),
      ],
    );
  }
}
