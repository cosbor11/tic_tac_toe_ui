import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class Square extends StatelessWidget {
  final String cellAssignment;
  final String? value;
  final Function moveCallback;

  final Map<String, Border> _borders = {
    "A1": Border(bottom: BorderSide(width: 5), right: BorderSide(width: 5)),
    "A2": Border(bottom: BorderSide(width: 5)),
    "A3": Border(bottom: BorderSide(width: 5), left: BorderSide(width: 5)),
    "B1": Border(right: BorderSide(width: 5)),
    "B2": Border(),
    "B3": Border(left: BorderSide(width: 5)),
    "C1": Border(top: BorderSide(width: 5), right: BorderSide(width: 5)),
    "C2": Border(top: BorderSide(width: 5)),
    "C3": Border(top: BorderSide(width: 5), left: BorderSide(width: 5))
  };

  Square(
      {Key? key,
      required this.cellAssignment,
      required this.value,
      required this.moveCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        hoverColor: value == null ? Colors.cyanAccent : Colors.transparent,
        focusColor: value == null ? Colors.cyanAccent : Colors.transparent,
        highlightColor:
            value == null ? Colors.orangeAccent : Colors.transparent,
        splashColor: value == null ? Colors.orangeAccent : Colors.transparent,
        onTap: () {
          if (value == null || value == '') {
            moveCallback(cellAssignment);
          }
        },
        child: Container(
            decoration: BoxDecoration(border: _borders[cellAssignment]),
            child: FittedBox(
                child: Text(value ?? "",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline2))));
  }
}
