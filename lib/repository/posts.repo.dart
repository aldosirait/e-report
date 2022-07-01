import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_report_unika/model/user.model.dart';

import '../model/post.model.dart';

Future addPost(Post post) async {
  final docPost = FirebaseFirestore.instance.collection("Posts").doc();
  post.id = docPost.id;
  await docPost.set(post.toJson());
}



Future updatePost(Post post) async {
  final docPost = FirebaseFirestore.instance.collection('Posts').doc(post.id);
  await docPost.update(post.toJson());
}
Future updatePostp(Post post) async {
  final docPost = FirebaseFirestore.instance.collection('Posts').doc(post.np);
  await docPost.update(post.toJson());
}

Future deletePost(String id) async {
  final docPost = FirebaseFirestore.instance.collection('Posts').doc(id);
  await docPost.delete();
}


