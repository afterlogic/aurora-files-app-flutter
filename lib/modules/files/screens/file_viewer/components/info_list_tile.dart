import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class InfoListTile extends StatefulWidget {
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
  _InfoListTileState createState() => _InfoListTileState();
}

class _InfoListTileState extends State<InfoListTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () => setState(() => _expanded = !_expanded),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(widget.label, style: Theme.of(context).textTheme.caption),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: Text(
                  widget.content,
                  style: Theme.of(context).textTheme.subhead,
                  maxLines: _expanded ? 20 : 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                ),
              ),
              Theme(
                data: Theme.of(context).copyWith(
                  iconTheme: IconThemeData(
                    color: Theme.of(context).disabledColor,
                    size: 18.0,
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    if (widget.isPublic) SizedBox(width: 10),
                    if (widget.isPublic)
                      Icon(
                        Icons.link,
                        semanticLabel: "Has public link",
                      ),
                    if (widget.isOffline) SizedBox(width: 10),
                    if (widget.isOffline)
                      Icon(
                        Icons.airplanemode_active,
                        semanticLabel: "Available offline",
                      ),
                    if (widget.isEncrypted) SizedBox(width: 10),
                    if (widget.isEncrypted)
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
      ),
    );
  }
}
