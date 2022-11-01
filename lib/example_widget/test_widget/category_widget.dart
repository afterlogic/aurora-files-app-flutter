import 'package:aurorafiles/example_widget/test_widget/label_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryWidget extends StatefulWidget {
  final String name;
  final List<Widget> children;

  const CategoryWidget(
    this.name,
    this.children, {
    super.key,
  });

  @override
  _CategoryWidgetState createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  @override
  Widget build(BuildContext context) {
    final stateHolder = Provider.of<CategoryStateHolder>(context);
    final isShow = stateHolder.getIsShow(widget.name);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            stateHolder.setIsShow(widget.name, !isShow);
            setState(() {});
          },
          child: SizedBox(
            width: double.infinity,
            child: Container(
              color: Colors.black26,
              padding: const EdgeInsets.all(10),
              child: Text(
                "Category: " + widget.name + " (${widget.children.length})",
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        if (isShow)
          SizedBox(
            width: double.infinity,
            child: Column(
              children: List.generate(
                widget.children.length,
                (i) => widget.children[i] is LabelWidget
                    ? widget.children[i]
                    : LabelWidget(widget.children[i]),
              ),
            ),
          )
      ],
    );
  }
}

class CategoryStateHolder {
  final Map<String, bool> isShow = {};

  setIsShow(Object object, bool value) {
    return isShow[object.toString()] = value;
  }

  bool getIsShow(Object object) {
    return isShow[object.toString()] ?? false;
  }
}
