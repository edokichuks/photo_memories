import 'package:flutter/widgets.dart';
import 'package:photo_memories/auth/auth_error.dart';
import 'package:photo_memories/dialogs/generic_dialog.dart';

Future<void> showAuthError(
    {required BuildContext context, required AuthError authError}) {
  return showGenericDialog<void>(
    context: context,
    title: authError.dialogTitle,
    content: authError.dialogText,
    dialOptionBuilder: () => {'Ok': true},
  );
}
