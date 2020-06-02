import 'dart:async';

import 'package:aurorafiles/database/app_database.dart';
import 'package:aurorafiles/models/recipient.dart';
import 'package:aurorafiles/utils/input_validation.dart';
import 'package:flutter/material.dart';

import 'compose_type_ahead.dart';

class EmailsInput extends StatefulWidget {
  final Future<List<Recipient>> Function(String pattern) searchContact;
  final Set<String> emails;
  final bool enable;
  final Set<String> pgpKeys;

  EmailsInput(
    this.searchContact,
    this.emails,
    this.enable,
    Key key,
    this.pgpKeys,
  ) : super(key: key);

  @override
  EmailsInputState createState() => EmailsInputState();
}

class EmailsInputState extends State<EmailsInput> {
  final textCtrl = TextEditingController();
  final composeTypeAheadFieldKey = GlobalKey<ComposeTypeAheadFieldState>();
  final focusNode = FocusNode();

  Timer debounce;
  List<Recipient> lastSuggestions;
  ThemeData theme;
  String _search;
  Completer<List<Recipient>> completer;

  addEmail() {
    _addEmail(textCtrl.text);
  }

  focusListener() {
    if (!focusNode.hasFocus) {
      _addEmail(textCtrl.text);
    }
  }

  Future<List<Recipient>> search(String pattern) async {
    completer = Completer();
    var _completer = completer;
    debounce?.cancel();
    print(pattern);
    debounce = Timer(Duration(seconds: 1), () async {
      if (pattern == textCtrl.text) {
        lastSuggestions = await widget.searchContact(pattern);
        if (_completer == completer && pattern == textCtrl.text) {
          return _completer.complete(lastSuggestions);
        }
      }
      return _completer.complete();
    });
    return completer.future;
  }

  @override
  void initState() {
    super.initState();
    focusNode.addListener(focusListener);
  }

  @override
  void dispose() {
    super.dispose();
    debounce?.cancel();
    focusNode.removeListener(focusListener);
    focusNode.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    theme = Theme.of(context);
  }

  TextSpan _searchMatch(String match) {
    final color = theme.textTheme.body1.color;
    final posRes = TextStyle(fontWeight: FontWeight.w700, color: color);
    final negRes = TextStyle(fontWeight: FontWeight.w400, color: color);

    if (_search == null || _search == "")
      return TextSpan(text: match, style: negRes);
    var refinedMatch = match.toLowerCase();
    var refinedSearch = _search.toLowerCase();
    if (refinedMatch.contains(refinedSearch)) {
      if (refinedMatch.substring(0, refinedSearch.length) == refinedSearch) {
        return TextSpan(
          style: posRes,
          text: match.substring(0, refinedSearch.length),
          children: [
            _searchMatch(
              match.substring(
                refinedSearch.length,
              ),
            ),
          ],
        );
      } else if (refinedMatch.length == refinedSearch.length) {
        return TextSpan(text: match, style: posRes);
      } else {
        return TextSpan(
          style: negRes,
          text: match.substring(
            0,
            refinedMatch.indexOf(refinedSearch),
          ),
          children: [
            _searchMatch(
              match.substring(
                refinedMatch.indexOf(refinedSearch),
              ),
            ),
          ],
        );
      }
    } else if (!refinedMatch.contains(refinedSearch)) {
      return TextSpan(text: match, style: negRes);
    }
    return TextSpan(
      text: match.substring(0, refinedMatch.indexOf(refinedSearch)),
      style: negRes,
      children: [
        _searchMatch(match.substring(refinedMatch.indexOf(refinedSearch)))
      ],
    );
  }

  Widget recipientWidget(Recipient contact) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (contact.fullName.isNotEmpty)
                RichText(
                  text: _searchMatch(contact.fullName),
                  maxLines: 1,
                ),
              if (contact.email.isNotEmpty)
                RichText(
                  text: _searchMatch(contact.email),
                  maxLines: 1,
                ),
            ],
          ),
        ),
        if (widget.pgpKeys.contains(contact.email)) Icon(Icons.vpn_key),
        SizedBox(
          width: 10,
        )
      ],
    );
  }

  Future _addEmail(String _email) async {
    final email = _email.replaceAll(" ", "");
    textCtrl.text = " ";
    textCtrl.selection = TextSelection.collapsed(offset: 1);
    lastSuggestions = [];
    final error =
        validateInput(email, [ValidationTypes.email, ValidationTypes.empty]);
    if (error == null) {
      setState(() => widget.emails.add(email));
    }
    composeTypeAheadFieldKey.currentState.resize();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final dropDownWidth = screenWidth / 1.25;

    return GestureDetector(
      onTap: focusNode.requestFocus,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: "Who can read",
          contentPadding: EdgeInsets.all(8),
          border: OutlineInputBorder(gapPadding: 0),
        ),
        expands: false,
        child: Wrap(
          spacing: 8,
          children: <Widget>[
            ...widget.emails.map((e) {
              return EmailItem(
                email: e,
                onDelete: (e) => setState(() => widget.emails.remove(e)),
              );
            }),
            if (widget.emails.isNotEmpty) SizedBox(height: 8),
            ComposeTypeAheadField<Recipient>(
              key: composeTypeAheadFieldKey,
              textFieldConfiguration: TextFieldConfiguration(
                focusNode: focusNode,
                enabled: true,
                controller: textCtrl,
              ),
              animationDuration: Duration.zero,
              suggestionsBoxDecoration: SuggestionsBoxDecoration(
                color: theme.cardColor,
                constraints: BoxConstraints(
                  minWidth: dropDownWidth,
                  maxWidth: dropDownWidth,
                ),
              ),
              suggestionsBoxVerticalOffset: 0.0,
              suggestionsBoxHorizontalOffset:
                  screenWidth - dropDownWidth - 16 * 2,
              autoFlipDirection: true,
              hideOnLoading: true,
              keepSuggestionsOnLoading: true,
              getImmediateSuggestions: true,
              noItemsFoundBuilder: (_) => SizedBox(),
              suggestionsCallback: (pattern) async => search(pattern),
              itemBuilder: (_, c) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: recipientWidget(c),
                );
              },
              onSuggestionSelected: (c) {
                return _addEmail(c.email);
              },
              child: TextField(
                controller: textCtrl,
                focusNode: focusNode,
                decoration: null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmailItem extends StatefulWidget {
  final String email;
  final Function(String) onDelete;

  const EmailItem({Key key, this.email, this.onDelete}) : super(key: key);

  @override
  _EmailItemState createState() => _EmailItemState();
}

class _EmailItemState extends State<EmailItem> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 43.0,
      child: GestureDetector(
        onTap: () {
          expanded = !expanded;
          setState(() {});
        },
        child: Chip(
          avatar: CircleAvatar(
            child: Text(
              widget.email[0],
              style: TextStyle(color: Colors.white),
            ),
          ),
          label: Text(widget.email),
          onDeleted: expanded ? () => widget.onDelete(widget.email) : null,
        ),
      ),
    );
  }
}
