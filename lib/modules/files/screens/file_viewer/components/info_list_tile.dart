import 'package:aurorafiles/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class InfoListTile extends StatefulWidget {
  final String label;
  final String content;
  final bool isOffline;
  final bool isPublic;
  final bool isShared;
  final bool isEncrypted;

  const InfoListTile({
    Key? key,
    required this.label,
    required this.content,
    this.isOffline = false,
    this.isPublic = false,
    this.isEncrypted = false,
    this.isShared = false,
  }) : super(key: key);

  @override
  _InfoListTileState createState() => _InfoListTileState();
}

class _InfoListTileState extends State<InfoListTile> {
  bool _expanded = false;
  double _rightPaddingForStatusIcons = 0.0;

  Widget _buildStatusIcons() {
    final s = context.l10n;
    return Theme(
      data: Theme.of(context).copyWith(
        iconTheme: IconThemeData(
          color: Theme.of(context).disabledColor,
          size: 18.0,
        ),
      ),
      child: Row(
        children: <Widget>[
          if (widget.isShared) const SizedBox(width: 10),
          if (widget.isShared)
            Icon(
              Icons.share,
              semanticLabel: s.label_share_with_teammates,
            ),
          if (widget.isPublic) const SizedBox(width: 10),
          if (widget.isPublic)
            Icon(
              Icons.link,
              semanticLabel: s.has_public_link,
            ),
          if (widget.isOffline) const SizedBox(width: 10),
          if (widget.isOffline)
            Icon(
              Icons.airplanemode_active,
              semanticLabel: s.available_offline,
            ),
          if (widget.isEncrypted) const SizedBox(width: 10),
          if (widget.isEncrypted)
            Icon(
              MdiIcons.alien,
              semanticLabel: s.encrypted,
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _rightPaddingForStatusIcons = 0.0;
    if (widget.isOffline) _rightPaddingForStatusIcons += 35.0;
    if (widget.isPublic) _rightPaddingForStatusIcons += 35.0;
    if (widget.isEncrypted) _rightPaddingForStatusIcons += 35.0;

    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () => setState(() => _expanded = !_expanded),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(widget.label, style: Theme.of(context).textTheme.caption),
          if (_expanded)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: Text(
                    widget.content,
                    style: Theme.of(context).textTheme.subtitle1,
                    maxLines: 20,
                  ),
                ),
                _buildStatusIcons(),
              ],
            ),
          if (!_expanded)
            Stack(
              children: <Widget>[
                SingleChildScrollView(
                  padding: EdgeInsets.only(right: _rightPaddingForStatusIcons),
                  scrollDirection: _expanded ? Axis.vertical : Axis.horizontal,
                  child: Text(
                    widget.content,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  top: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context)
                              .scaffoldBackgroundColor
                              .withOpacity(0.0),
                          Theme.of(context).scaffoldBackgroundColor,
                        ],
                        stops: const [0.0, 0.3],
                      ),
                    ),
                    child: _buildStatusIcons(),
                  ),
                ),
              ],
            ),
          const Divider(height: 26.0),
        ],
      ),
    );
  }
}
