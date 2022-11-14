import 'dart:async';

import 'package:aurorafiles/models/recipient.dart';
import 'package:aurorafiles/modules/files/components/compose_type_ahead.dart';
import 'package:aurorafiles/utils/input_validation.dart';
import 'package:aurorafiles/utils/text_utils.dart';
import 'package:flutter/material.dart';

class EmailsInput extends StatefulWidget {
  final String label;
  final Future<List<Recipient>> Function(String pattern) searchContact;
  final Set<String> emails;
  final bool enable;
  final Set<String> pgpKeys;

  const EmailsInput(
    this.searchContact,
    this.emails,
    this.enable,
    Key? key,
    this.pgpKeys,
    this.label,
  ) : super(key: key);

  @override
  EmailsInputState createState() => EmailsInputState();
}

class EmailsInputState extends State<EmailsInput> {
  final textCtrl = TextEditingController();
  final composeTypeAheadFieldKey = GlobalKey<ComposeTypeAheadFieldState>();
  final focusNode = FocusNode();

  Timer? debounce;
  List<Recipient> lastSuggestions = [];
  late ThemeData theme;
  String? _search;
  late Completer<List<Recipient>> completer;

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
    debounce = Timer(const Duration(milliseconds: 500), () async {
      if (pattern == textCtrl.text) {
        lastSuggestions = await widget.searchContact(pattern);
        if (_completer == completer && pattern == textCtrl.text) {
          return _completer.complete(lastSuggestions);
        }
      }
      return _completer.complete([]);
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
    final color = theme.textTheme.bodyText2?.color;
    final positiveStyle = TextStyle(fontWeight: FontWeight.w700, color: color);
    final negativeStyle = TextStyle(fontWeight: FontWeight.w400, color: color);

    return TextUtils.highlightPartOfText(
      text: match,
      part: _search,
      positiveStyle: positiveStyle,
      negativeStyle: negativeStyle,
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
              if (contact.fullName?.isNotEmpty == true)
                RichText(
                  text: _searchMatch(contact.fullName ?? ''),
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
        if (widget.pgpKeys.contains(contact.email)) const Icon(Icons.vpn_key),
        const SizedBox(
          width: 10,
        )
      ],
    );
  }

  void _deleteEmail(String email) {
    setState(() => widget.emails.remove(email));
    composeTypeAheadFieldKey.currentState?.resize();
  }

  void _addEmail(String _email) {
    final email = _email.replaceAll(" ", "");
    textCtrl.text = " ";
    textCtrl.selection = const TextSelection.collapsed(offset: 1);
    lastSuggestions = [];
    final error =
        validateInput(email, [ValidationTypes.email, ValidationTypes.empty]);
    if (error == null) {
      setState(() => widget.emails.add(email));
    }
    composeTypeAheadFieldKey.currentState?.resize();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final dropDownWidth = screenWidth / 1.25;

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: GestureDetector(
        onTap: focusNode.requestFocus,
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: widget.label,
            contentPadding: const EdgeInsets.all(8),
            border: const OutlineInputBorder(gapPadding: 0),
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
              if (widget.emails.isNotEmpty) const SizedBox(height: 8),
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
                // suggestionsBoxHorizontalOffset:
                //     screenWidth - dropDownWidth - 16 * 2,
                autoFlipDirection: true,
                hideOnLoading: true,
                keepSuggestionsOnLoading: true,
                getImmediateSuggestions: true,
                noItemsFoundBuilder: (_) => const SizedBox(),
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
                  onChanged: (value) {
                    if (widget.emails.isNotEmpty && value.isEmpty) {
                      textCtrl.text = " ";
                      textCtrl.selection =
                          const TextSelection.collapsed(offset: 1);
                      _deleteEmail(widget.emails.last);
                    } else if (value.length > 1 && value.endsWith(" ")) {
                      onSubmit();
                    }
                    lastSuggestions = [];
                  },
                  onEditingComplete: () {
                    onSubmit();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  onSubmit() {
    if (lastSuggestions.isEmpty) {
      if (isEmailValid(textCtrl.text.replaceAll(" ", ""))) {
        _addEmail(textCtrl.text.replaceAll(" ", ""));
        composeTypeAheadFieldKey.currentState?.clear();
      }
    } else {
      _addEmail(lastSuggestions.first.email);
      composeTypeAheadFieldKey.currentState?.clear();
    }
  }
}

class EmailItem extends StatefulWidget {
  final String email;
  final Function(String) onDelete;

  const EmailItem({
    Key? key,
    required this.email,
    required this.onDelete,
  }) : super(key: key);

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
              style: const TextStyle(color: Colors.white),
            ),
          ),
          label: Text(widget.email),
          onDeleted: expanded ? () => widget.onDelete(widget.email) : null,
        ),
      ),
    );
  }
}
