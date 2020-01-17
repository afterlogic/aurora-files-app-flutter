import 'package:aurorafiles/generated/s_of_context.dart';
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
    final s = Str.of(context);
    return BottomNavigationBar(
      currentIndex: _navItem,
      onTap: (int item) => setState(() => _navItem = item),
      selectedItemColor: Theme.of(context).iconTheme.color,
      unselectedItemColor: Theme.of(context).iconTheme.color.withOpacity(0.4),
      items: [
        BottomNavigationBarItem(
          icon: Icon(MdiIcons.emailMultipleOutline),
          activeIcon: Icon(MdiIcons.emailMultiple),
          title: Text(s.mail),
          backgroundColor: Theme.of(context).cardColor,
        ),
        BottomNavigationBarItem(
          icon: Icon(MdiIcons.contactMailOutline),
          activeIcon: Icon(MdiIcons.contactMail),
          title: Text(s.contacts),
        ),
        BottomNavigationBarItem(
          icon: Icon(MdiIcons.fileMultiple),
          activeIcon: Icon(MdiIcons.fileMultiple),
          title: Text(s.files),
        ),
        BottomNavigationBarItem(
          icon: Icon(MdiIcons.calendar),
          activeIcon: Icon(MdiIcons.calendar),
          title: Text(s.calendar),
        ),
        BottomNavigationBarItem(
          icon: Icon(MdiIcons.formatListNumbered),
          activeIcon: Icon(MdiIcons.formatListNumbered),
          title: Text(s.tasks),
        ),
      ],
    );
  }
}
