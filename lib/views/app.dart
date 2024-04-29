import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_memories/bloc/app_bloc.dart';
import 'package:photo_memories/bloc/app_events.dart';
import 'package:photo_memories/bloc/app_state.dart';
import 'package:photo_memories/dialogs/show_auth_error.dart';
import 'package:photo_memories/loading/loading_screen.dart';
import 'package:photo_memories/views/login_view.dart';
import 'package:photo_memories/views/photo_gallery_view.dart';
import 'package:photo_memories/views/register_view.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppBloc>(
      create: (context) => AppBloc()..add(AppEventInitialized()),
      child: MaterialApp(
        title: 'Photo App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: BlocConsumer<AppBloc, AppState>(
          builder: (context, state) {
            if (state is AppStateLoggedOut) {
              return const LoginView();
            } else if (state is AppStateLoggedIn) {
              return const PhotoGalleryView();
            } else if (state is AppStateIsInRegisterationView) {
              return const RegisterView();
            } else {
              return Container();
            }
          },
          listener: (context, state) {
            if (state.isLoading) {
              return LoadingScreen.instance()
                  .show(context: context, text: 'Loading...');
            } else {
              LoadingScreen.instance().hide();
            }
            final authError = state.authError;

            if (authError != null) {
              showAuthError(context: context, authError: authError);
            }
          },
        ),
      ),
    );
  }
}
