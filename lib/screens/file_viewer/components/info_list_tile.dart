import 'package:flutter/material.dart';

class InfoListTile extends StatelessWidget {
  final String label;
  final String content;

  const InfoListTile({
    Key key,
    @required this.label,
    @required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(label, style: Theme.of(context).textTheme.caption),
        Text(content, style: Theme.of(context).textTheme.subhead),
        Divider(
          height: 26.0,
        ),
      ],
    );
  }
}
