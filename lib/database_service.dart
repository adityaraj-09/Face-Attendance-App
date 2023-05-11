
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class Database{
  final String? uid;
  Database({this.uid});
  final CollectionReference usercollection=FirebaseFirestore.instance.collection("users");

  final CollectionReference groupcollection=FirebaseFirestore.instance.collection("groups");

  Future save(List list)async{
    return await usercollection.doc(uid).update({
      "faceId":list
    });
  }

  Future savingData(String name,String entryNo) async{
    return await usercollection.doc(uid).set({
      "Name": name,
      "Entry No":entryNo,
      "profilePic":"",
      "faceId":[],
      "uid":uid,
      "attendance":0,
    });
  }


  Future gettingUserData(String entryNo) async{
    QuerySnapshot snapshot=await usercollection.where("Entry No",isEqualTo: entryNo).get();
    return snapshot;
  }
  getImg()async{
    DocumentReference d=usercollection.doc(uid);
    DocumentSnapshot documentSnapshot=await d.get();
    return documentSnapshot['faceId'];
  }

   gettingUserfromid(String id) async{
     DocumentReference d=usercollection.doc(id);
     DocumentSnapshot documentSnapshot=await d.get();
    return documentSnapshot['email'];
  }
  getProfileFromid(String id)async{
    DocumentReference d=usercollection.doc(id);
    DocumentSnapshot documentSnapshot=await d.get();
    return documentSnapshot['profilePic'];
  }
  getData(String id)async{
    DocumentReference d=usercollection.doc(id);
    DocumentSnapshot documentSnapshot=await d.get();
    return documentSnapshot;
  }

  uploadImage(File? file) async {
    FirebaseStorage _storage = FirebaseStorage.instance;
    final storgeRef=FirebaseStorage.instance.ref().child(DateTime.now().microsecondsSinceEpoch.toString());
    UploadTask uploadTask = storgeRef.putFile(file!);
    final snapshot=await uploadTask.whenComplete((){});
    final urlDownload=await snapshot.ref.getDownloadURL();
    return urlDownload;
}
  putImage(String uri) async{
    usercollection.doc(uid).update({
      "profilePic":uri,

    }
    );
  }


}
