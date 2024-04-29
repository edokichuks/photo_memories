import 'package:flutter/widgets.dart';
import 'package:photo_memories/dialogs/generic_dialog.dart';

Future<bool> showDeleteAccountDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Delete Account',
    content:
        'Are you sure you want to delete your acccount? Ypu cannot undo this operation',
    dialOptionBuilder: () => {'Cancel': false, 'Delete': true},
  ).then((value) => value ?? false);
}
