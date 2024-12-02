import 'package:flutter/material.dart';

class DeletionDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  final String thingToDeleteText;

  const DeletionDialog({
    Key? key,
    required this.onConfirm,
    required this.thingToDeleteText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(thingToDeleteText),
      content: Text('Вы уверены?'),
      actions: <Widget>[
        TextButton(
          child: Text('Отмена'),
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
        ),
        TextButton(
          child: Text('Подтвердить'),
          onPressed: () {
            onConfirm();
          },
        ),
      ],
    );
  }
}
