import 'package:aurora_ui_kit/components/dialogs/am_dialog.dart';
import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/generated/s_of_context.dart';
import 'package:aurorafiles/models/recipient.dart';
import 'package:aurorafiles/modules/files/repository/share_access_entry.dart';
import 'package:aurorafiles/modules/files/repository/share_access_right.dart';
import 'package:aurorafiles/modules/files/state/files_state.dart';
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
  bool _rebuildingDropdown = false;

  @override
  void initState() {
    super.initState();
    _initTeammates();
  }

  Future<void> _initTeammates() async {
    final result = await _searchContact('');
    if (result.isNotEmpty) {
      _teammates.addAll(result);
      if (mounted) setState(() {});
    }
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
    ShareAccessRight right = ShareAccessRight.read,
  ]) {
    if (recipient == null || right == null) return;
    setState(() {
      final share = ShareAccessEntry(recipient: recipient, right: right);
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
    if (right == null) return;
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

    return AMDialog(
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
                  : ListView.builder(
                    itemCount: _shares.length,
                    itemBuilder: (context, index) {
                      final item = _shares[index];
                      return _ShareItem(
                        share: item,
                        onChange: (right) => _changeShare(item, right),
                        onDelete: () => _removeShare(item),
                      );
                    },
                  ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: Text(s.cancel),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}

class _ShareItem extends StatelessWidget {
  final ShareAccessEntry share;
  final Function(ShareAccessRight) onChange;
  final VoidCallback onDelete;

  const _ShareItem({
    Key key,
    @required this.share,
    @required this.onChange,
    @required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dismissible(
      key: ValueKey(share.id),
      background: Container(
        color: theme.disabledColor,
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Icon(Icons.delete_outline, color: Colors.white),
        ),
      ),
      secondaryBackground: Container(
        color: theme.disabledColor,
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Icon(Icons.delete_outline, color: Colors.white),
        ),
      ),
      onDismissed: (_) => onDelete(),
      child: Container(
        width: double.infinity,
        height: 40,
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  share.recipient.email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            SizedBox(
              width: 50,
              child: PopupMenuButton<ShareAccessRight>(
                itemBuilder: (context) {
                  return ShareAccessRight.values
                      .map((value) => PopupMenuItem<ShareAccessRight>(
                            value: value,
                            child: Text(ShareAccessRightHelper.toName(value)),
                          ))
                      .toList();
                },
                onSelected: onChange,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    ShareAccessRightHelper.toShortName(share.right),
                    style: TextStyle(
                      color: theme.primaryColor,
                      decoration: TextDecoration.underline,
                      decorationStyle: TextDecorationStyle.dotted,
                    ),
                  ),
                ),
              ),

              // TextButton(
              //   onPressed: onChangeAccess,
              //   child: Text(
              //     ShareAccessRightHelper.toShortName(share.right),
              //     style: TextStyle(
              //       color: theme.primaryColor,
              //       decoration: TextDecoration.underline,
              //       decorationStyle: TextDecorationStyle.dotted,
              //     ),
              //   ),
              // ),
            ),
            const SizedBox(width: 8),
            // IconButton(
            //   icon: Icon(
            //     Icons.close,
            //     size: 16,
            //     color: theme.disabledColor,
            //   ),
            //   onPressed: onDelete,
            //   padding: EdgeInsets.zero,
            // ),
          ],
        ),
      ),
    );
  }
}
