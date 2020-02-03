import 'package:aurorafiles/example_widget/test_widget/category_widget.dart';
import 'package:aurorafiles/example_widget/test_widget/group_label.dart';
import 'package:aurorafiles/example_widget/test_widget/label_widget.dart';
import 'package:aurorafiles/shared_ui/app_button.dart';
import 'package:aurorafiles/shared_ui/app_input.dart';
import 'package:aurorafiles/shared_ui/custom_speed_dial.dart';
import 'package:aurorafiles/shared_ui/main_drawer.dart';
import 'package:aurorafiles/shared_ui/main_gradient.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AppCategory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CategoryWidget(
      "App widgets",
      [
        MainGradient(
          child: SizedBox(
            width: double.infinity,
            height: 400,
          ),
        ),
        GroupLabel(
          name: "AppButton",
          children: <Widget>[
            AppButton(
              width: double.infinity,
              onPressed: null,
              text: "Disabled",
            ),
            AppButton(
              width: double.infinity,
              onPressed: () {},
              text: "enabled",
            ),
            AppButton(
              width: double.infinity,
              onPressed: () {},
              isLoading: true,
              text: "Loading",
            ),
            AppButton(
              width: double.infinity,
              onPressed: () {},
              buttonCase: ButtonCase.Cancel,
              text: "Cancel",
            ),
            AppButton(
              width: double.infinity,
              onPressed: () {},
              buttonCase: ButtonCase.Warning,
              text: "Warning",
            ),
            AppButton(
              width: double.infinity,
              onPressed: () {},
              buttonCase: ButtonCase.Filled,
              text: "Filled",
            ),
          ],
        ),
        GroupLabel(
          name: "Input",
          children: <Widget>[
            AppInput(
              controller: TextEditingController(text: "text"),
              key: Key((this.hashCode + 0).toString()),
            ),
            AppInput(
              labelText: "Password",
              suffix: Icon(Icons.visibility),
              obscureText: true,
              controller: TextEditingController(text: "text"),
              key: Key((this.hashCode + 1).toString()),
            ),
            AppInput(
              inputCase: InputCase.Underline,
              labelText: "Label",
              controller: TextEditingController(text: "Static color"),
              key: Key((this.hashCode + 2).toString()),
            ),
          ],
        ),
        LabelWidget(
          SizedBox(
            width: 40,
            height: 40,
            child: FloatingActionButton(
              backgroundColor: theme.accentColor,
              heroTag: "FloatingActionButton",
              child: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                    context,
                    CustomSpeedDial(tag: "FloatingActionButton", children: [
                      MiniFab(
                        icon: Icon(Icons.create_new_folder),
                      ),
                      MiniFab(
                        icon: Icon(MdiIcons.filePlus),
                      ),
                    ]));
              },
            ),
          ),
          name: "FloatingActionButton",
        ),
        LabelWidget(
          SizedBox(
              width: double.infinity,
              height: 400,
              child: Scaffold(
                appBar: AppBar(),
                drawer: MainDrawer(),
              )),
          name: "Drawer",
        )
      ],
    );
  }
}
