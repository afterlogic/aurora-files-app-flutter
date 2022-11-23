import 'package:aurorafiles/models/share_access_entry.dart';
import 'package:aurorafiles/models/share_access_right.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ShareTeammateDialogItem extends StatelessWidget {
  final ShareAccessEntry share;
  final bool enabled;
  final Function(ShareAccessRight) onChange;
  final VoidCallback onDelete;
  final Future<bool> Function() confirmDelete;

  const ShareTeammateDialogItem({
    Key? key,
    required this.share,
    required this.enabled,
    required this.onChange,
    required this.onDelete,
    required this.confirmDelete,
  }) : super(key: key);

  Future<void> _requestToDelete() async {
    final result = await confirmDelete();
    if (result) onDelete();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconAsset = share.principal.getSvgIconAsset();

    return SizedBox(
      height: 40,
      child: Row(
        children: [
          iconAsset != null
              ? Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: SvgPicture.asset(
                    iconAsset,
                    color: theme.colorScheme.onSurface,
                    width: 20,
                    height: 20,
                  ),
                )
              : const SizedBox.shrink(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                share.principal.getLabel(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          const SizedBox(width: 4),
          SizedBox(
            width: 50,
            child: PopupMenuButton<ShareAccessRight>(
              enabled: enabled,
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
                  ShareAccessRightHelper.toShortName(share.access),
                  style: TextStyle(
                    color: enabled ? theme.primaryColor : theme.disabledColor,
                    decoration: TextDecoration.underline,
                    decorationStyle: TextDecorationStyle.dotted,
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.close,
              size: 16,
              color: theme.disabledColor,
            ),
            onPressed: _requestToDelete,
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}
