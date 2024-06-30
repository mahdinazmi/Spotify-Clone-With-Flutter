import 'package:spotify/domain/entities/auth/user.dart';

class UserModel {

  String ? fullName;
  String ? email;
  String ? imageURL;

  UserModel({
    this.fullName,
    this.email,
    this.imageURL
  });
  

   UserModel.fromJson(Map<String,dynamic> data) {
    fullName = data['name'];
    email = data['email'];
  }


  
}

extension UserModelX on UserModel {

  UserEntity toEntity() {
    return UserEntity(
      email: email,
      fullName: fullName,
      imageURL: imageURL
    );
  }
}