import 'package:flutter/widgets.dart';
import 'package:photo_memories/dialogs/generic_dialog.dart';

Future<bool> showLogoutialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Log out',
    content: 'Are you sure you want to log out',
    dialOptionBuilder: () => {'Cancel': false, 'Log out': true},
  ).then((value) => value ?? false);
}
