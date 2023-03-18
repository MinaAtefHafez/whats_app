


class WhoSeenStoryModel {
  String? profilePic ;
  String? userName ;
  String? dateTime ;
  String ? time ;

  WhoSeenStoryModel({
    this.userName ,
    this.profilePic ,
    this.dateTime ,
    this.time
  });

  factory WhoSeenStoryModel.fromJson (Map <String , dynamic> json ) {
     return WhoSeenStoryModel(
      userName: json['userName'] ,
      profilePic: json['profilePic'] ,
      dateTime: json['dateTime'] ,
      time: json['time'] ,
     );
  }


  Map <String ,dynamic > toMap () {
    return {
      'userName' : userName ,
      'profilePic' : profilePic ,
      'dateTime' : dateTime ,
      'time' : time ,
    };
  }

}