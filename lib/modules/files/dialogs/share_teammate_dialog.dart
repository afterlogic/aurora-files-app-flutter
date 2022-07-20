import 'dart:convert';

import 'package:aurora_ui_kit/components/dialogs/am_dialog.dart';
import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/generated/s_of_context.dart';
import 'package:aurorafiles/models/recipient.dart';
import 'package:aurorafiles/modules/app_store.dart';
import 'package:aurorafiles/modules/files/dialogs/share_teammate_dialog_item.dart';
import 'package:aurorafiles/modules/files/repository/share_access_entry.dart';
import 'package:aurorafiles/modules/files/repository/share_access_right.dart';
import 'package:aurorafiles/modules/files/state/files_state.dart';
import 'package:aurorafiles/utils/show_snack.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ShareTeammateDialog extends StatefulWidget {
  final FilesState fileState;
  final LocalFile file;

  const ShareTeammateDialog({
    Key key,
    @required this.fileState,
    @required this.file,
  }) : super(key: key);

  @override
  State<ShareTeammateDialog> createState() => _ShareTeammateDialogState();
}

class _ShareTeammateDialogState extends State<ShareTeammateDialog> {
  List<Recipient> _teammates = [];
  List<ShareAccessEntry> _shares = [];

  // Recipient _selectedRecipient;
  ShareAccessRight _lastSelectedRight = ShareAccessRight.read;
  bool _rebuildingDropdown = false;
  bool _progress = true;

  String get _userEmail => AppStore.authState.userEmail;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await Future.wait([
      _initTeammates(),
      _initShares(),
    ]);
    _progress = false;
    if (mounted) setState(() {});
  }

  Future<void> _initTeammates() async {
    final result = await _searchContact('');
    if (result.isNotEmpty) {
      result.removeWhere((e) => e.email == _userEmail);
      _teammates.addAll(result);
    }
  }

  Future<void> _initShares() async {
    final shares = await widget.fileState.getFileShares(widget.file);
    _shares.addAll(shares);

    // if (widget.file.extendedProps == null) return;
    // final map = json.decode(widget.file.extendedProps);
    // if (map["Shares"] != null) {
    //   final shares = map["Shares"] as List;
    //   for (final value in shares) {
    //     final share = ShareAccessEntry.fromShareJson(value);
    //     if (share != null) {
    //       _shares.add(share);
    //     }
    //   }
    // }
  }

  Future<List<Recipient>> _searchContact(String pattern) {
    return widget.fileState.searchContact(pattern.replaceAll(" ", ""));
  }

  // void _selectRecipient(Recipient recipient) {
  //   setState(() {
  //     _selectedRecipient = recipient;
  //   });
  // }

  void _addShare(
    Recipient recipient, [
    ShareAccessRight right,
  ]) {
    if (recipient == null) return;
    final actualRight = right ?? _lastSelectedRight;
    final share = ShareAccessEntry(recipient: recipient, right: actualRight);
    setState(() {
      _shares.add(share);
      // _selectedRecipient = null;
    });
    _rebuildDropdownWidget();
  }

  void _rebuildDropdownWidget() {
    setState(() {
      _rebuildingDropdown = true;
    });
    SchedulerBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _rebuildingDropdown = false;
      });
    });
  }

  void _changeShare(ShareAccessEntry share, ShareAccessRight right) {
    if (share == null || right == null) return;
    _lastSelectedRight = right;
    final index = _shares.indexOf(share);
    setState(() {
      _shares[index] = share.copyWith(right: right);
    });
  }

  void _removeShare(ShareAccessEntry share) {
    setState(() {
      _shares.remove(share);
    });
    // final index = _shares.indexWhere((e) => e.id == share.id);
    // if (index != -1) {
    //   setState(() {
    //     _shares.removeAt(index);
    //   });
    // }
  }

  bool _recipientNotInShares(Recipient recipient) {
    final index =
        _shares.indexWhere((e) => e.recipient.idUser == recipient.idUser);
    return index == -1;
  }

  void _setProgress(bool value) {
    setState(() {
      _progress = value;
    });
  }

  void _onShowHistory() {}

  Future<void> _onSave() async {
    _setProgress(true);
    try {
      final newShares =
          await widget.fileState.shareFileToTeammate(widget.file, _shares);
      final map = widget.file.extendedProps == null
          ? {}
          : json.decode(widget.file.extendedProps);
      map["Shares"] = newShares;
      final file = widget.file.copyWith(extendedProps: json.encode(map));
      Navigator.pop(context, file);
    } catch (err) {
      _onError(err);
    }
    _setProgress(false);
  }

  void _onCancel() {
    Navigator.pop(context);
  }

  void _onError(dynamic error) {
    showSnack(context, msg: '$error');
  }

  @override
  Widget build(BuildContext context) {
    final s = Str.of(context);
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;

    //TODO: check this in future packet version
    //recreate DropdownSearch, because there is no method for cleaning its contents
    final dropdownSearch = _rebuildingDropdown
        ? Container(
            decoration: BoxDecoration(
              border: Border.all(color: theme.disabledColor),
              borderRadius: BorderRadius.circular(4),
            ),
          )
        : DropdownSearch<Recipient>(
            mode: Mode.MENU,
            items: _teammates,
            onChanged: _addShare,
            //_selectRecipient,
            filterFn: (item, _) => _recipientNotInShares(item),
            itemAsString: (Recipient r) => r.email,
            maxHeight: screenHeight / 3,
            dropdownSearchDecoration: InputDecoration(
              hintText: "Select teammate",
              contentPadding: EdgeInsets.only(left: 8),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: theme.disabledColor),
                borderRadius: const BorderRadius.all(Radius.circular(4.0)),
              ),
            ),
          );

    return Stack(
      alignment: Alignment.center,
      children: [
        AMDialog(
          title: Text(s.label_share_with_teammates),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: dropdownSearch,
                    ),
                  ),
                  // PopupMenuButton<ShareAccessRight>(
                  //   itemBuilder: (context) {
                  //     return ShareAccessRight.values
                  //         .map((value) => PopupMenuItem<ShareAccessRight>(
                  //               value: value,
                  //               child: Text(ShareAccessRightHelper.toName(value)),
                  //             ))
                  //         .toList();
                  //   },
                  //   enabled: _selectedRecipient != null,
                  //   onSelected: (right) => _addShare(_selectedRecipient, right),
                  //   icon: Icon(
                  //     Icons.add_circle_outline,
                  //     color: theme.disabledColor,
                  //   ),
                  // ),
                ],
              ),
              Container(
                width: double.infinity,
                height: screenHeight / 4,
                margin: EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: theme.disabledColor,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  child: _shares.isEmpty
                      ? Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Text(
                              'No shares yet',
                              style: TextStyle(color: theme.disabledColor),
                            ),
                          ),
                        )
                      : Scrollbar(
                          child: ListView.builder(
                            itemCount: _shares.length,
                            itemBuilder: (context, index) {
                              final item = _shares[index];
                              return ShareTeammateDialogItem(
                                share: item,
                                onChange: (right) => _changeShare(item, right),
                                onDelete: () => _removeShare(item),
                              );
                            },
                          ),
                        ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Show history'),
              onPressed: _onShowHistory,
            ),
            TextButton(
              child: Text('Save'),
              onPressed: _onSave,
            ),
            TextButton(
              child: Text(s.cancel),
              onPressed: _onCancel,
            ),
          ],
        ),
        if (_progress) CircularProgressIndicator(),
      ],
    );
  }
}
