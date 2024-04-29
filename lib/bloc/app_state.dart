import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:photo_memories/auth/auth_error.dart';

@immutable
class AppState {
  final bool isLoading;
  final AuthError? authError;

  const AppState({
    required this.isLoading,
     this.authError,
  });
}

@immutable
class AppStateLoggedIn extends AppState {
  final User user;
  final Iterable<Reference> images;
  const AppStateLoggedIn({
    required this.user,
    required this.images,
    required bool isLoading,
     AuthError? authError,
  }) : super(authError: authError, isLoading: isLoading);

  @override
  bool operator ==(other) {
    final otherClass = other;
    if (otherClass is AppStateLoggedIn) {
      return isLoading == otherClass.isLoading &&
          user.uid == otherClass.user.uid &&
          images.length == otherClass.images.length;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => Object.hash(user.uid, images);

  @override
  String toString() => 'AppStateLoggedIn, images.length = ${images.length}';
}

@immutable
class AppStateLoggedOut extends AppState {
  const AppStateLoggedOut({
    required bool isLoading,
     AuthError? authError,
  }) : super(
          authError: authError,
          isLoading: isLoading,
        );
  @override
  String toString() =>
      'AppStateLoggedOut, isLoading = $isLoading, authError = $authError';
}

@immutable
class AppStateIsInRegisterationView extends AppState {
  const AppStateIsInRegisterationView(
      {required bool isLoading,  AuthError? authError})
      : super(
          authError: authError,
          isLoading: isLoading,
        );
}

extension Getuser on AppState {
  User? get user {
    final cls = this;
    if (cls is AppStateLoggedIn) {
      return cls.user;
    } else {
      return null;
    }
  }
}
extension GetImages on AppState {
  Iterable<Reference>? get images {
    final cls = this;
    if (cls is AppStateLoggedIn) {
      return cls.images;
    } else {
      return null;
    }
  }
}


