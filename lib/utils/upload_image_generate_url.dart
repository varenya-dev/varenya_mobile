import 'dart:io';

import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';

/*
 * Upload image to firebase storage and return a URL for the same.
 * @param imageFile File object of the image.
 * @param folderName Folder where the image is to be uploaded.
 */
Future<String> uploadImageAndGenerateUrl(
  File imageFile,
  String folderName,
) async {
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  Uuid uuid = new Uuid();

  // Generate a UUID upload the image to storage.
  String imageUuid = uuid.v4();
  await firebaseStorage.ref("$folderName/$imageUuid.png").putFile(imageFile);

  // Return the URL for the same.
  return await firebaseStorage
      .ref("$folderName/$imageUuid.png")
      .getDownloadURL();
}
