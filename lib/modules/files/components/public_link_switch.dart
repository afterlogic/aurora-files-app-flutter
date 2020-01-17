import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/generated/s_of_context.dart';
import 'package:aurorafiles/modules/files/state/files_page_state.dart';
import 'package:aurorafiles/modules/files/state/files_state.dart';
import 'package:aurorafiles/utils/show_snack.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class PublicLinkSwitch extends StatefulWidget {
  final LocalFile file;
  final FilesState filesState;
  final FilesPageState filesPageState;
  final bool isFileViewer;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Function(String) updateFile;

  const PublicLinkSwitch({
    Key key,
    @required this.file,
    this.filesState,
    this.filesPageState,
    // default snacks are shown on files screen, in order to show it on other screens, pass scaffoldState
    this.scaffoldKey,
    this.isFileViewer = false,
    this.updateFile,
  }) : super(key: key);

  @override
  _PublicLinkSwitchState createState() => _PublicLinkSwitchState();
}

class _PublicLinkSwitchState extends State<PublicLinkSwitch> {
  FilesState filesState;
  FilesPageState filesPageState;
  S s;
  bool _isGettingPublicLink = false;
  bool _hasPublicLink = false;

  @override
  void initState() {
    super.initState();
    _hasPublicLink = widget.file.published;
  }

  void _getLink() {
    filesState.onGetPublicLink(
      path: filesPageState.pagePath,
      name: widget.file.name,
      size: widget.file.size,
      isFolder: widget.file.isFolder,
      onSuccess: (link) async {
        Clipboard.setData(ClipboardData(text: link));
        setState(() => _isGettingPublicLink = false);
        showSnack(
          context: context,
          scaffoldState: widget.scaffoldKey != null
              ? widget.scaffoldKey.currentState
              : filesPageState.scaffoldKey.currentState,
          msg: s.link_coppied_to_clipboard,
          isError: false,
        );
        if (!widget.isFileViewer && Navigator.of(context).canPop()) {
          Navigator.pop(context);
        }
        await filesPageState.onGetFiles();
        if (widget.updateFile != null) widget.updateFile(widget.file.id);
      },
      onError: (String err) => setState(() {
        _isGettingPublicLink = false;
        _hasPublicLink = false;
        showSnack(
          context: context,
          scaffoldState: widget.scaffoldKey != null
              ? widget.scaffoldKey.currentState
              : filesPageState.scaffoldKey.currentState,
          msg: err,
        );
      }),
    );
  }

  void _deleteLink() {
    filesState.onDeletePublicLink(
      path: filesPageState.pagePath,
      name: widget.file.name,
      onSuccess: () async {
        setState(() => _isGettingPublicLink = false);
        await filesPageState.onGetFiles();
        if (widget.updateFile != null) widget.updateFile(widget.file.id);
      },
      onError: (String err) => setState(() {
        _isGettingPublicLink = false;
        _hasPublicLink = true;
        showSnack(
          context: context,
          scaffoldState: widget.scaffoldKey != null
              ? widget.scaffoldKey.currentState
              : filesPageState.scaffoldKey.currentState,
          msg: err,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    filesState = widget.filesState ?? Provider.of<FilesState>(context);
    filesPageState =
        widget.filesPageState ?? Provider.of<FilesPageState>(context);
    s = Str.of(context);
    return Column(
      children: <Widget>[
        InkWell(
          onTap: _isGettingPublicLink
              ? null
              : () {
                  setState(() {
                    _isGettingPublicLink = true;
                    _hasPublicLink = !_hasPublicLink;
                  });
                  if (_hasPublicLink) {
                    _getLink();
                  } else {
                    _deleteLink();
                  }
                },
          child: ListTile(
            contentPadding: widget.isFileViewer ? EdgeInsets.zero : null,
            leading: Icon(Icons.link),
            title: Text(s.public_link_access),
            trailing: Switch.adaptive(
              value: _hasPublicLink,
              activeColor: Theme.of(context).accentColor,
              onChanged: _isGettingPublicLink
                  ? null
                  : (bool val) {
                      setState(() {
                        _isGettingPublicLink = true;
                        _hasPublicLink = val;
                      });
                      if (val) {
                        _getLink();
                      } else {
                        _deleteLink();
                      }
                    },
            ),
          ),
        ),
        if (_hasPublicLink)
          Opacity(
            opacity: _isGettingPublicLink ? 0.4 : 1.0,
            child: ListTile(
              contentPadding: widget.isFileViewer ? EdgeInsets.zero : null,
              leading: Icon(Icons.content_copy),
              title: Text(s.copy_public_link),
              onTap: _isGettingPublicLink
                  ? null
                  : () {
                      setState(() => _isGettingPublicLink = true);
                      _getLink();
                    },
            ),
          )
      ],
    );
  }
}
