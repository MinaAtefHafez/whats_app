class UserModel {
  String? name;
  String? uId;
  String? profileImage;
  String? phoneNumber;
  bool? isOnline;
  List<String>? groupId;
  String? fcmToken ;
  String? bio ; 

  UserModel({
     this.name,
     this.uId,
     this.profileImage,
     this.phoneNumber,
     this.isOnline,
     this.groupId,
     this.fcmToken ,
     this.bio ,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      uId: json['uId'],
      phoneNumber: json['phoneNumber'],
      profileImage: json['profileImage'],
      isOnline: json['isOnline'],
      groupId: List<String>.from(json['groupId']),
      fcmToken: json['fcmToken'] ,
      bio: json['bio'] ,
    );
  }

  Map <String, dynamic> toMap () {
    return {
      'name' : name ,
      'uId' : uId ,
      'profileImage' : profileImage ,
      'phoneNumber' : phoneNumber ,
      'isOnline' : isOnline ,
      'groupId' : groupId ,
      'fcmToken' : fcmToken
    };
  }


}
