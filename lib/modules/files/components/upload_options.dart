import 'package:aurorafiles/l10n/l10n.dart';
import 'package:aurorafiles/modules/files/state/files_page_state.dart';
import 'package:aurorafiles/modules/files/state/files_state.dart';
import 'package:aurorafiles/shared_ui/aurora_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UploadOptions extends StatefulWidget {
  final FilesState filesState;
  final FilesPageState filesPageState;

  const UploadOptions({
    Key? key,
    required this.filesState,
    required this.filesPageState,
  }) : super(key: key);

  @override
  _UploadOptionsState createState() => _UploadOptionsState();
}

class _UploadOptionsState extends State<UploadOptions> {
  bool _buttonsDisabled = false;

  void _uploadFiles(BuildContext context, bool copy) {
    widget.filesPageState.filesLoading = FilesLoadingType.filesVisible;
    setState(() => _buttonsDisabled = true);
    widget.filesState.uploadShared(
      context,
      toPath: widget.filesPageState.pagePath,
      onSuccess: () async {
        await widget.filesPageState.onGetFiles(
          onError: (String err) => AuroraSnackBar.showSnack(msg: err),
        );
        if (mounted) {
          setState(() => _buttonsDisabled = false);
        }
        widget.filesState.disableUploadShared();
        //todo
        SystemNavigator.pop();
      },
      onError: (err) {
        setState(() => _buttonsDisabled = false);
        widget.filesPageState.filesLoading = FilesLoadingType.none;
        AuroraSnackBar.showSnack(msg: err);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    return Container(
      decoration: BoxDecoration(
        border: const Border(top: BorderSide(color: Colors.grey)),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 3.0, bottom: 6.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              TextButton(
                child: Text(
                  s.cancel,
                  style: TextStyle(
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
                onPressed: () {
                  widget.filesState.disableUploadShared();
                },
              ),
              TextButton(
                onPressed: _buttonsDisabled
                    ? null
                    : () => _uploadFiles(context, false),
                child: Text(
                  s.upload,
                  style: TextStyle(
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
