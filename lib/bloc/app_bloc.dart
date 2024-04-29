import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:photo_memories/auth/auth_error.dart';
import 'package:photo_memories/bloc/app_events.dart';
import 'package:photo_memories/bloc/app_state.dart';
import 'package:photo_memories/utils/upload_image.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc()
      : super(const AppStateLoggedOut(
          isLoading: false,
        )) {
//!Handle logout events
    on<AppEventLogOut>(
      (event, emit) async {
        emit(const AppStateLoggedOut(isLoading: true));

        await FirebaseAuth.instance.signOut();

        emit(
          const AppStateLoggedOut(
            isLoading: false,
          ),
        );
      },
    );
    //!app event init
    on<AppEventInitialized>(
      (event, emit) async {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          emit(const AppStateLoggedOut(isLoading: false));
        } else {
          final image = await _getImages(user.uid);
          emit(AppStateLoggedIn(isLoading: false, user: user, images: image));
        }
      },
    );

    //!goto login
    on<AppEventGoToLogin>(
      (event, emit) {
        emit(const AppStateLoggedOut(isLoading: false));
      },
    );
    //!goto register
    on<AppEventGoToRegisteration>(
      (event, emit) {
        emit(const AppStateIsInRegisterationView(isLoading: false));
      },
    );

    ///!login
    on<AppEventLogIn>(
      (event, emit) async {
        emit(const AppStateLoggedOut(isLoading: true));

        //login
        final email = event.email;
        final password = event.password;
        try {
          final userCredential = await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: email, password: password);
          final user = userCredential.user!;

          final images = await _getImages(user.uid);
          emit(AppStateLoggedIn(user: user, images: images, isLoading: false));
        } on FirebaseAuthException catch (e) {
          emit(AppStateLoggedOut(
              isLoading: false, authError: AuthError.from(e)));
        }
      },
    );
    //!register
    on<AppEventRegister>(
      (event, emit) async {
        emit(const AppStateIsInRegisterationView(isLoading: true));

        final email = event.email;
        final password = event.password;

        try {
          final credentials = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(email: email, password: password);
          emit(AppStateLoggedIn(
              user: credentials.user!, images: [], isLoading: false));
        } on FirebaseAuthException catch (e) {
          emit(
            AppStateIsInRegisterationView(
              isLoading: false,
              authError: AuthError.from(e),
            ),
          );
        }
      },
    );
    //!Handle acc deletion
    on<AppEventDeleteAcc>(
      (event, emit) async {
        final user = FirebaseAuth.instance.currentUser;

        if (user == null) {
          emit(
            const AppStateLoggedOut(
              isLoading: false,
            ),
          );
          return;
        }

        //!start loading
        emit(
          AppStateLoggedIn(
            user: user,
            images: state.images ?? [],
            isLoading: true,
          ),
        );

        //!delete the user folder
        try {
          //delete user folder
          final folder = await FirebaseStorage.instance.ref(user.uid).listAll();
          for (final item in folder.items) {
            await item.delete().catchError((_) {});
          }

          await FirebaseStorage.instance
              .ref(user.uid)
              .delete()
              .catchError((_) {});

          //!delete the user
          await user.delete();
          //!logs the user out
          await FirebaseAuth.instance.signOut();

          emit(
            const AppStateLoggedOut(
              isLoading: false,
            ),
          );
        } on FirebaseAuthException catch (e) {
          emit(
            AppStateLoggedIn(
              user: user,
              images: state.images ?? [],
              isLoading: false,
              authError: AuthError.from(e),
            ),
          );
        } on FirebaseException {
          emit(
            const AppStateLoggedOut(
              isLoading: false,
            ),
          );
        }
      },
    );
    //!uploading an image
    on<AppEventUploadImage>(
      (event, emit) async {
        //? user from the GetUser extension
        final user = state.user;
        if (user == null) {
          emit(
            const AppStateLoggedOut(
              isLoading: false,
            ),
          );
          return;
        }
        emit(
          AppStateLoggedIn(
            user: user,
            images: state.images ?? [],
            isLoading: true,
          ),
        );

        final file = File(event.filePathToUpload);
        //!upload files
        await uploadImage(
          file: file,
          userId: user.uid,
        );

        //?after upload is complete, grab the lates file references
        final images = await _getImages(user.uid);

        emit(AppStateLoggedIn(user: user, images: images, isLoading: false));
      },
    );
  }

  Future<Iterable<Reference>> _getImages(String userId) =>
      FirebaseStorage.instance.ref(userId).list().then((value) => value.items);
}
