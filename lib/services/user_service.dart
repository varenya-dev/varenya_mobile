import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:varenya_mobile/dtos/user/update_email_dto/update_email_dto.dart';
import 'package:varenya_mobile/dtos/user/update_password_dto/update_password_dto.dart';
import 'package:varenya_mobile/exceptions/auth/user_already_exists_exception.dart';
import 'package:varenya_mobile/exceptions/auth/weak_password_exception.dart';
import 'package:varenya_mobile/exceptions/auth/wrong_password_exception.dart';
import 'package:firebase_database/firebase_database.dart';

/*
 * Service implementation for user module.
 */
class UserService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  /*
   * Update profile picture for the given user.
   * @param imageUrl updated URL of the new profile picture.
   */
  Future<User> updateProfilePicture(String imageUrl) async {
    // Fetch the currently logged in user.
    User firebaseUser = this._firebaseAuth.currentUser!;

    // Update profile picture URL for the user.
    await firebaseUser.updatePhotoURL(imageUrl);

    // Return updated user.
    return this._firebaseAuth.currentUser!;
  }

  /*
   * Update display name for the given user.
   * @param fullName Updated full name of the user.
   */
  Future<User> updateFullName(String fullName) async {
    try {
      // Fetch the currently logged in user.
      User loggedInUser = this._firebaseAuth.currentUser!;

      // Updating the name of the user.
      await loggedInUser.updateDisplayName(fullName);

      // Returning updated user data.
      return this._firebaseAuth.currentUser!;
    } catch (error) {
      print(error);
      throw Exception("Something went wrong, please try again later");
    }
  }

  /*
   * Update email address for the given user.
   * @param updateEmailDto DTO for email address update.
   */
  Future<User> updateEmailAddress(UpdateEmailDto updateEmailDto) async {
    try {
      // Fetch the currently logged in user.
      User loggedInUser = this._firebaseAuth.currentUser!;

      // Get the email address for the currently logged in user.
      String currentUserEmailAddress = loggedInUser.email!;

      // Prepare the auth credentials for re-authentication.
      AuthCredential authCredential = EmailAuthProvider.credential(
        email: currentUserEmailAddress,
        password: updateEmailDto.password,
      );

      // Re-authenticate the user with credential.
      await loggedInUser.reauthenticateWithCredential(authCredential);

      // Update email address for the user.
      await loggedInUser.updateEmail(updateEmailDto.newEmailAddress);

      // Returning updated user data.
      return this._firebaseAuth.currentUser!;
    } on FirebaseAuthException catch (error) {
      // Firebase Error: If the user has typed a weak password.
      if (error.code == "email-already-in-use") {
        throw UserAlreadyExistsException(
          message: "There is an account associated with this email address.",
        );
      }

      // Firebase Error: If the user has typed the wrong password.
      else if (error.code == 'wrong-password') {
        throw WrongPasswordException(
          message: 'Wrong password provided for the specified user account.',
        );
      }

      // Handle other unknown errors
      else {
        print(error);
        throw Exception("Something went wrong, please try again later");
      }
    } catch (error) {
      print(error);
      throw Exception("Something went wrong, please try again later");
    }
  }

  /*
   * Update password for the given user.
   * @param updateEmailDto DTO for password update.
   */
  Future<void> updatePassword(UpdatePasswordDto updatePasswordDto) async {
    try {
      // Fetch the currently logged in user.
      User loggedInUser = this._firebaseAuth.currentUser!;

      // Get the email address for the currently logged in user.
      String currentUserEmailAddress = loggedInUser.email!;

      // Prepare the auth credentials for re-authentication.
      AuthCredential authCredential = EmailAuthProvider.credential(
        email: currentUserEmailAddress,
        password: updatePasswordDto.oldPassword,
      );

      // Re-authenticate the user with credential.
      await loggedInUser.reauthenticateWithCredential(authCredential);

      // Update password for the user.
      await loggedInUser.updatePassword(updatePasswordDto.newPassword);
    } on FirebaseAuthException catch (error) {
      // Firebase Error: If the user has typed a weak password.
      if (error.code == "weak-password") {
        throw WeakPasswordException(message: "Password provided is weak.");
      }

      // Firebase Error: If the user has typed the wrong password.
      else if (error.code == 'wrong-password') {
        throw WrongPasswordException(
          message: 'Wrong password provided for the specified user account.',
        );
      }

      // Handle other unknown errors
      else {
        print(error);
        throw Exception("Something went wrong, please try again later");
      }
    } catch (error) {
      print(error);
      throw Exception("Something went wrong, please try again later");
    }
  }

  /*
   * Delete account of the logged in user.
   * @param password user password.
   */
  Future<void> deleteAccount(String password) async {
    try {
      // Fetch the currently logged in user.
      User loggedInUser = this._firebaseAuth.currentUser!;

      // Get the email address for the currently logged in user.
      String currentUserEmailAddress = loggedInUser.email!;

      // Prepare the auth credentials for re-authentication.
      AuthCredential authCredential = EmailAuthProvider.credential(
        email: currentUserEmailAddress,
        password: password,
      );

      // Re-authenticate the user with credential.
      await loggedInUser.reauthenticateWithCredential(authCredential);

      // Deleting user account.
      await loggedInUser.delete();
    } on FirebaseAuthException catch (error) {
      // Firebase Error: If the user has typed the wrong password.
      if (error.code == 'wrong-password') {
        throw WrongPasswordException(
          message: 'Wrong password provided for the specified user account.',
        );
      }

      // Handle other unknown errors
      else {
        print(error);
        throw Exception("Something went wrong, please try again later");
      }
    } catch (error) {
      print(error);
      throw Exception("Something went wrong, please try again later");
    }
  }

  /*
   * Method to update user online presence in firebase.
   */
  Future<void> updateUserPresence() async {
    // Online status document.
    Map<String, dynamic> presenceStatusTrue = {
      'presence': true,
      'lastSeen': DateTime.now().millisecondsSinceEpoch,
    };

    // Save the document in firebase database.
    await this
        ._firebaseDatabase
        .reference()
        .child(this._firebaseAuth.currentUser!.uid)
        .update(presenceStatusTrue)
        .whenComplete(() => print('USER STATUS UPDATED'));

    // Offline status document.
    Map<String, dynamic> presenceStatusFalse = {
      'presence': false,
      'lastSeen': DateTime.now().millisecondsSinceEpoch,
    };

    // Listen for connection disconnection to update status with offline.
    this
        ._firebaseDatabase
        .reference()
        .child(this._firebaseAuth.currentUser!.uid)
        .onDisconnect()
        .update(presenceStatusFalse);
  }

  /*
   * Save FCM token to database on each update.
   * @param token FCM Token to be saved.
   */
  Future<void> saveTokenToDatabase(String token) async {
    // Save token to the respective document collection.
    String userId = this._firebaseAuth.currentUser!.uid;
    await this._firebaseFirestore.collection('users').doc(userId).update({
      'token': token,
    });
  }

  /*
   * Save token to the database on first run.
   */
  Future<void> generateAndSaveTokenToDatabase() async {
    //  Generate an FCM token and save it to firestore.
    String? token = await this._firebaseMessaging.getToken();
    this.saveTokenToDatabase(token!);

    print('TOKEN GENERATED AND SAVED.');
  }
}
