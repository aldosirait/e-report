

class User{
  String id;
  String nama;
  String np;
  String password ;
  String role ;
  String prodi ;
  String imagePic ;
 


  User({this.id='', required this.nama ,required this.np,required this.password,required this.role,required this.prodi,required this.imagePic});

  Map<String , dynamic> toJson(){
    return {
      'id':id,
      'nama':nama,
      'np':np,
      'password':password,
      'role':role,
      'prodi':prodi,
      'imagePic':imagePic,
    };
  }
  factory User.fromJson(Map<String,dynamic> json){
  return  User(id: json['id'] ,nama: json['nama'], np: json['np'],password: json['password'],role: json['role'],prodi: json['prodi'],imagePic: json['imagePic']);
}
}




class UserAuth{
  static String np='';

}



