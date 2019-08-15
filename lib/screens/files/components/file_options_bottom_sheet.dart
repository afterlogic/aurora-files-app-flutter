import 'package:aurorafiles/screens/files/state/files_state.dart';
import 'package:flutter/material.dart';

class FileOptionsBottomSheet extends StatefulWidget {
  final file;
  final FilesState filesState;

  const FileOptionsBottomSheet(
      {Key key, @required this.file, @required this.filesState})
      : super(key: key);

  @override
  _FileOptionsBottomSheetState createState() => _FileOptionsBottomSheetState();
}

class _FileOptionsBottomSheetState extends State<FileOptionsBottomSheet> {
  bool _isGettingPublicLink = false;
  bool _hasPublicLink = false;

  @override
  void initState() {
    super.initState();
    _hasPublicLink = widget.file["Published"];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            widget.file["Name"],
            style: Theme.of(context).textTheme.title,
          ),
        ),
        Divider(height: 0),
        LimitedBox(
          maxHeight: 260.0,
          child: ListView(
            children: <Widget>[
              SwitchListTile.adaptive(
                title: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.link),
                  title: Text("Get public link"),
                ),
                value: _hasPublicLink,
                onChanged: _isGettingPublicLink
                    ? null
                    : (bool val) {
                        setState(() {
                          _isGettingPublicLink = true;
                          _hasPublicLink = val;
                          widget.file["Published"] = val;
                        });
                        if (val) {
                          widget.filesState.onGetPublicLink(
                            name: widget.file["Name"],
                            size: widget.file["Size"],
                            isFolder: widget.file["IsFolder"],
                            onSuccess: () =>
                                setState(() => _isGettingPublicLink = false),
                            onError: (String err) => setState(() {
                              _isGettingPublicLink = false;
                              _hasPublicLink = !val;
                              widget.file["Published"] = !val;
                            }),
                          );
                        } else {
                          widget.filesState.onDeletePublicLink(
                            name: widget.file["Name"],
                            onSuccess: () =>
                                setState(() => _isGettingPublicLink = false),
                            onError: (String err) => setState(() {
                              _isGettingPublicLink = false;
                              _hasPublicLink = !val;
                              widget.file["Published"] = !val;
                            }),
                          );
                        }
                      },
              ),
              if (_hasPublicLink && !_isGettingPublicLink)
                ListTile(
                  leading: Icon(Icons.content_copy),
                  title: Text("Copy public link"),
                  onTap: () => {},
                ),
              Divider(height: 0),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text("Move"),
                onTap: () => {},
              ),
              ListTile(
                leading: Icon(Icons.share),
                title: Text("Share"),
                onTap: () => {},
              ),
              ListTile(
                leading: Icon(Icons.edit),
                title: Text("Rename"),
                onTap: () => {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}
