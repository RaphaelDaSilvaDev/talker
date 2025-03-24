class UserModel {
  final String username;
  final String email;
  final String token;

  UserModel(
    this.email,
    this.username,
    this.token
  );

  Map<String, dynamic> toMap(){
    return{
      'username': username,
      'email': email
    };
  }


  factory UserModel.fromMap(Map<String, dynamic> map){
    return UserModel(
      map['email'],
      map['username'],
      map['token']
    );
  }
}