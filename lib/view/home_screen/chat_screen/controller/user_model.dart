class UserModel{
  String? id;
  String? email;
  String? name;
  String? profilePic;

  UserModel({this.id, this.email, this.name, this.profilePic});

  UserModel.fromMap(Map<String, dynamic> map){
    id = map['id'];
    email = map['email'];
    name = map['name'];
    profilePic = map['profilePic'];
  }

  Map<String, dynamic> toMap(){
    return{
      "id": id,
      "email": email,
      "name": name,
      "profilePic": profilePic,
    };
  }
}