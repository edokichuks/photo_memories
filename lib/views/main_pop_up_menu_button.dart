import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_memories/bloc/app_bloc.dart';
import 'package:photo_memories/bloc/app_events.dart';
import 'package:photo_memories/dialogs/delete_account_dialog.dart';
import 'package:photo_memories/dialogs/logout_dialog.dart';

enum MenuAction { logout, deleteAccount }

class MainPopMenuButton extends StatelessWidget {
  const MainPopMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuAction>(
      onSelected: (value) async {
        switch (value) {
          case MenuAction.logout:
            final shouldLogout = await showLogoutialog(context);

            if (shouldLogout) {
              context.read<AppBloc>().add(const AppEventLogOut());
            }

            break;
          case MenuAction.deleteAccount:
                      final shouldDeleteAccount = await showDeleteAccountDialog(context);

            if (shouldDeleteAccount) {
              
              context.read<AppBloc>().add(const AppEventDeleteAcc());
            }
            break;
          default:
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          const PopupMenuItem<MenuAction>(
            value: MenuAction.logout,
            child: Text('Log out'),
          ),
          const PopupMenuItem<MenuAction>(
            value: MenuAction.deleteAccount,
            child: Text('Delete Account'),
          )
        ];
      },
    );
  }
}
