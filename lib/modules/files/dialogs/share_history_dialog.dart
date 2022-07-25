import 'package:aurora_ui_kit/aurora_ui_kit.dart';
import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/generated/s_of_context.dart';
import 'package:aurorafiles/models/share_access_history.dart';
import 'package:aurorafiles/modules/files/state/files_state.dart';
import 'package:aurorafiles/utils/date_formatting.dart';
import 'package:aurorafiles/utils/show_snack.dart';
import 'package:flutter/material.dart';

class ShareHistoryDialog extends StatefulWidget {
  final FilesState fileState;
  final LocalFile file;

  const ShareHistoryDialog({
    Key key,
    @required this.fileState,
    @required this.file,
  }) : super(key: key);

  @override
  State<ShareHistoryDialog> createState() => _ShareHistoryDialogState();
}

class _ShareHistoryDialogState extends State<ShareHistoryDialog> {
  ShareAccessHistory _history;
  // int _currentPage = 0;
  bool _progress = true;

  @override
  void initState() {
    super.initState();
    _initHistory();
  }

  Future<void> _initHistory() async {
    try {
      _history = await widget.fileState.getFileShareHistory(widget.file);
    } catch (err) {
      _onError(err);
    }
    _progress = false;
    if (mounted) setState(() {});
  }

  void _setProgress(bool value) {
    setState(() {
      _progress = value;
    });
  }

  // Future<void> _goToPage(int page) async {
  //   _setProgress(true);
  //   try {
  //     _history = await widget.fileState.getFileShareHistory(widget.file, page);
  //     _currentPage = page;
  //   } catch (err) {
  //     _onError(err);
  //   }
  //   _setProgress(false);
  // }

  Future<void> _onClear() async {
    _setProgress(true);
    try {
      await widget.fileState.deleteFileShareHistory(widget.file);
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
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      alignment: Alignment.center,
      children: [
        AMDialog(
          title: Text('Shared file activity history'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.maxFinite,
                height: screenHeight / 2,
                child: _HistoryPaginatedDataTable(history: _history),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Clear'),
              onPressed: _onClear,
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

class _HistoryPaginatedDataTable extends StatefulWidget {
  final ShareAccessHistory history;

  const _HistoryPaginatedDataTable({
    Key key,
    @required this.history,
  }) : super(key: key);

  @override
  State<_HistoryPaginatedDataTable> createState() =>
      _HistoryPaginatedDataTableState();
}

class _HistoryPaginatedDataTableState
    extends State<_HistoryPaginatedDataTable> {
  static const headline = ['Date', 'Action', 'IP', 'User'];

  int _rowPerPage = 5;

  void _onRowsPerPageChanged(int value) {
    setState(() {
      _rowPerPage = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.history == null) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final bodyTextStyle = theme.textTheme.bodyText2;
    final headTextStyle = bodyTextStyle.copyWith(
      fontWeight: FontWeight.bold,
    );
    final columns = headline
        .map((e) => DataColumn(
              label: Text(e, style: headTextStyle),
            ))
        .toList();

    return SingleChildScrollView(
      child: PaginatedDataTable(
        columns: columns,
        source: _HistoryDTS(
          history: widget.history,
          textStyle: bodyTextStyle,
        ),
        rowsPerPage: _rowPerPage,
        availableRowsPerPage: const [5, 20, 50, 100],
        onRowsPerPageChanged: _onRowsPerPageChanged,
        horizontalMargin: 8,
        columnSpacing: 24,
      ),
    );
  }
}

class _HistoryDTS extends DataTableSource {
  final ShareAccessHistory history;
  final TextStyle textStyle;

  _HistoryDTS({
    @required this.history,
    @required this.textStyle,
  });

  @override
  DataRow getRow(int index) {
    final item = history.items[index];
    return DataRow(
      cells: [
        DataCell(
          Text(DateFormatting.shortDateTime(item.createdAt), style: textStyle),
        ),
        DataCell(
          Text(item.action, style: textStyle),
        ),
        DataCell(
          Text(item.ipAddress, style: textStyle),
        ),
        DataCell(
          Text(item.guestPublicId, style: textStyle),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => history.items.length;

  @override
  int get selectedRowCount => 0;
}

// class _HistoryDataTable extends StatefulWidget {
//   final ShareAccessHistory history;
//
//   const _HistoryDataTable({
//     Key key,
//     @required this.history,
//   }) : super(key: key);
//
//   @override
//   __HistoryDataTableState createState() => __HistoryDataTableState();
// }
//
// class __HistoryDataTableState extends State<_HistoryDataTable> {
//   static const headline = ['Date', 'Action', 'IP', 'User'];
//
//   @override
//   Widget build(BuildContext context) {
//     if (widget.history == null) {
//       return Center(child: Text('No records yet'));
//     }
//
//     final theme = Theme.of(context);
//     final bodyTextStyle = theme.textTheme.bodyText2;
//     final headTextStyle = bodyTextStyle.copyWith(
//       fontWeight: FontWeight.bold,
//     );
//     final columns = headline
//         .map((e) => DataColumn(
//               label: Text(e, style: headTextStyle),
//             ))
//         .toList();
//     final rows = widget.history.items
//         .map((e) => DataRow(
//               cells: [
//                 DataCell(Text(DateFormatting.shortDateTime(e.createdAt),
//                     style: bodyTextStyle)),
//                 DataCell(Text(e.action, style: bodyTextStyle)),
//                 DataCell(Text(e.ipAddress, style: bodyTextStyle)),
//                 DataCell(Text(e.guestPublicId, style: bodyTextStyle)),
//               ],
//             ))
//         .toList();
//
//     return SingleChildScrollView(
//       child: SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: DataTable(
//           columns: columns,
//           rows: rows,
//         ),
//       ),
//     );
//   }
// }

// class _HistoryTable extends StatelessWidget {
//   static const headline = ['Date', 'Action', 'IP', 'User'];
//   final ShareAccessHistory history;
//
//   const _HistoryTable({
//     Key key,
//     @required this.history,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     if (history == null) {
//       return Center(child: Text('No records yet'));
//     }
//
//     final theme = Theme.of(context);
//     final bodyTextStyle = theme.textTheme.bodyText2;
//     final headTextStyle = bodyTextStyle.copyWith(
//       fontWeight: FontWeight.bold,
//     );
//     final firstLine =
//         headline.map((e) => Text(e, style: headTextStyle)).toList();
//     final otherLines = history.items
//         .map((e) => TableRow(children: [
//               Text(DateFormatting.shortDateTime(e.createdAt),
//                   style: bodyTextStyle),
//               Text(e.action, style: bodyTextStyle),
//               Text(e.ipAddress, style: bodyTextStyle),
//               Text(e.guestPublicId, style: bodyTextStyle),
//             ]))
//         .toList();
//
//     return SingleChildScrollView(
//       child: Table(
//         border: TableBorder(
//           horizontalInside: BorderSide(),
//         ),
//         children: [
//           TableRow(children: firstLine),
//           ...otherLines,
//         ],
//       ),
//     );
//   }
// }
