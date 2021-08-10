import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class StartupDialog extends SimpleDialog {
  show(context) async {
    return await showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Select a piece:'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, "X");
                },
                child: Text('X',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline2),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, "O");
                },
                child: Text('O',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline2),
              ),
            ],
          );
        });
  }
}
