import 'package:flutter/material.dart';

class AlertShopDialog extends StatelessWidget {
  final String title;
  final String content;
  final String cancelLabel;
  final String confirmLabel;
  final void Function() cancelFunction;
  final void Function() confirmFunction;

  const AlertShopDialog({
    super.key,
    required this.title,
    required this.content,
    this.cancelLabel = 'Cancelar',
    this.confirmLabel = 'Confirmar',
    required this.cancelFunction,
    required this.confirmFunction,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: Text(title),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(content),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: cancelFunction,
          child: Text(cancelLabel),
        ),
        TextButton(
          onPressed: confirmFunction,
          child: const Text('Remover'),
        ),
      ],
    );
  }
}
