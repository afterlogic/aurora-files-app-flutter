import 'package:aurorafiles/models/contact_group.dart';
import 'package:aurorafiles/models/recipient.dart';

class ContactSuggestion {
  final List<Recipient> recipients;
  final List<ContactGroup> groups;

  ContactSuggestion(this.recipients, this.groups);
}
