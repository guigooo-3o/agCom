
import 'dart:io';

import 'package:agendador_comunitario/controller/cloud_storage_result.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class CloudStorageController {
  Future <CloudStorageResult> uploadImage ({
    @required File imageToUpload,
    @required String title,
  }) async {
    var imageFileName= title + DateTime.now().millisecondsSinceEpoch.toString();

    final StorageReference firebaseStorageRef= FirebaseStorage.instance.ref().child(imageFileName);

    StorageUploadTask uploadTask= firebaseStorageRef.putFile(imageToUpload);
    StorageTaskSnapshot storageTaskSnapshot= await uploadTask.onComplete;

    var downloadUrl= await storageTaskSnapshot.ref.getDownloadURL();

    if (uploadTask.isComplete){
      var url = downloadUrl.toString();
      return CloudStorageResult(
        imageUrl: url,
        imageFileName: imageFileName,
      );
    }
    return null;
  }
}