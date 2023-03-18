


class StatusModel {
  String? uId ;
  String? userName; 
  String ? text ;
  String? fileUrl ;
  String? profilePic ; 
  String? createdAt ;
  String? time ;
  String ? statusId ;
  List <String>? whoCanSee ; 
  String? fileType ;
  bool? isStory ;
  List<String>? isSeen ;


  StatusModel({
    this.uId ,
    this.userName ,
    this.fileUrl ,
    this.profilePic ,
    this.createdAt ,
    this.time ,
    this.statusId ,
    this.whoCanSee ,
    this.fileType ,
    this.text ,
    this.isStory ,
    this.isSeen
  });


 factory StatusModel.fromJson ( Map <String,dynamic> json ) {
    return StatusModel(
       uId: json['uId'], 
       text : json['text'] ,
       userName: json['userName'], 
       fileUrl: json['photoUrl'] , 
       profilePic: json['profilePic'],
       createdAt: json['createdAt'] , 
       time: json['time'] , 
       statusId: json['statusId'] , 
       whoCanSee: List<String>.from(json['whoCanSee']) , 
       isSeen: List<String>.from(json['isSeen']) , 
       fileType: json['fileType'] ,
       isStory: json['isStory'] ,
       
    );
  }


  Map <String ,dynamic> toMap () {
    return {
      'uId' : uId ,
      'userName' : userName ,
      'photoUrl' : fileUrl ,
      'profilePic' : profilePic ,
      'createdAt' : createdAt ,
      'time' : time ,
      'statusId' : statusId ,
      'whoCanSee' : whoCanSee ,
      'fileType' : fileType ,
      'text'  :text ,
      'isStory' : isStory ,
      'isSeen' : isSeen
    };
  }

  
}