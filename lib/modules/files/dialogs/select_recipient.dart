import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/modules/files/state/file_viewer_state.dart';
import 'package:flutter/material.dart';

class SelectRecipient extends StatefulWidget {
  final FileViewerState fileViewerState;
  final LocalFile file;

  SelectRecipient(this.file, this.fileViewerState);

  @override
  _SelectRecipientState createState() => _SelectRecipientState();
}

class _SelectRecipientState extends State<SelectRecipient> {

  loadRecipients() {
    final recipients = widget.fileViewerState.getRecipient();
  }

  @override
  void initState() {
    loadRecipients();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              left: 10,
              bottom: 24,
            ),
            child: Text("Secure sharing", style: theme.textTheme.title),
          ),
          Text(
            "Select recipient:",
            style: theme.textTheme.subtitle,
          ),
        ],
      ),
      content: ListView.builder(itemBuilder: (_, __) => Text("1")),
    );
  }
}

class RecipientWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }
}
