import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AppBottomAppBar extends StatefulWidget {
  @override
  _AppBottomAppBarState createState() => _AppBottomAppBarState();
}

class _AppBottomAppBarState extends State<AppBottomAppBar> {
  int _navItem = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _navItem,
      onTap: (int item) => setState(() => _navItem = item),
      selectedItemColor: Theme.of(context).iconTheme.color,
      unselectedItemColor: Theme.of(context).iconTheme.color.withOpacity(0.4),
      items: [
        BottomNavigationBarItem(
          icon: Icon(MdiIcons.emailMultipleOutline),
          activeIcon: Icon(MdiIcons.emailMultiple),
          title: Text("Mail"),
          backgroundColor: Theme.of(context).cardColor,
        ),
        BottomNavigationBarItem(
          icon: Icon(MdiIcons.contactMailOutline),
          activeIcon: Icon(MdiIcons.contactMail),
          title: Text("Contacts"),
        ),
        BottomNavigationBarItem(
          icon: Icon(MdiIcons.fileMultiple),
          activeIcon: Icon(MdiIcons.fileMultiple),
          title: Text("Files"),
        ),
        BottomNavigationBarItem(
          icon: Icon(MdiIcons.calendar),
          activeIcon: Icon(MdiIcons.calendar),
          title: Text("Calendar"),
        ),
        BottomNavigationBarItem(
          icon: Icon(MdiIcons.formatListNumbered),
          activeIcon: Icon(MdiIcons.formatListNumbered),
          title: Text("Tasks"),
        ),
      ],
    );
  }
}
