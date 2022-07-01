class Post{
  String id;
  String np;
  String name;
  String desc;
  String url;
  final dataPublished;
  String imagePic;
  String status;
  

 


  Post({this.id='', required this.name,required this.np ,required this.desc,required this.url,required this.dataPublished,required this.imagePic,required this.status});

  Map<String , dynamic> toJson(){
    return {
      'id':id,
      'np':np,
      'name':name,
      'desc':desc,
      'url':url,
      'dataPublished':dataPublished,
      'imagePic':imagePic,
      'status':status,
     
      
     
    };
  }
  factory Post.fromJson(Map<String,dynamic> json){
  return  Post(id: json['id'] ,np: json['np'],name: json['name'], desc: json['desc'], url: json['url'],dataPublished: json['dataPublished'],imagePic: json['imagePic'],status: json['status']);
}
}