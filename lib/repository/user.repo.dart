import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_report_unika/model/user.model.dart';
import 'package:flutter/material.dart';

Future addUser(User user) async {
  final docUser = FirebaseFirestore.instance.collection("Users").doc();
  user.id = docUser.id;
  await docUser.set(user.toJson());
}

Future updateUser(User user) async {
  final docUser = FirebaseFirestore.instance.collection('Users').doc(user.id);
  await docUser.update(user.toJson());
}

Future deleteUser(String id) async {
  final docUser = FirebaseFirestore.instance.collection('Users').doc(id);
  await docUser.delete();
}
