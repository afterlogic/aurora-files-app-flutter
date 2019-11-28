import 'network_route.dart';

class ModuleContacts extends NetworkRoute {
  @override
  final String module = "Contacts";
  @override
  final Map<String, dynamic> parameters;

  ModuleContacts(ContactsMethod method, {this.parameters, bool toUpperCase})
      : super(method, toUpperCase);
}

enum ContactsMethod {
  GetContacts,
}
