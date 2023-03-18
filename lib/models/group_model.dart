


class GroupModel {
  String? groupName ;
  String? senderId ;
  String? groupPic ;
  String? groupId ;
  String? lastMessage ;
  String? dateTime ;
  String? date ;
  String? time ;
  String? whoSendLastMessage ;
  List <String>? membersUid ;
  String? messageType ;
  Map <String, dynamic>? groupMessagesThatNotSeen ;


  GroupModel ({
    this.groupName ,
    this.senderId ,
    this.groupPic ,
    this.groupId ,
    this.lastMessage ,
    this.whoSendLastMessage ,
    this.dateTime ,
    this.date ,
    this.time ,
    this.membersUid ,
    this.messageType ,
    this.groupMessagesThatNotSeen ,
  });


 factory GroupModel.fromJson ( Map <String,dynamic> json ) {
    return GroupModel(
      groupName: json['groupName'],
      senderId: json['senderId'],
      groupPic: json['groupPic'],
      groupId: json['groupId'],
      lastMessage: json['lastMessage'],
      whoSendLastMessage: json['whoSendLastMessage'],
      dateTime: json['dateTime'],
      date: json['date'],
      time: json['time'],
      messageType: json['messageType'],
      membersUid: List.from(json['membersUid'].map ((e) => e )) ,
      groupMessagesThatNotSeen: json['groupMessagesThatNotSeen']
    );
  }   

  Map <String,dynamic> toMap () {
    return {
      'groupName' :groupName ,
      'senderId' :senderId ,
      'groupPic' : groupPic,
      'groupId' :groupId ,
      'lastMessage' :lastMessage ,
      'whoSendLastMessage' : whoSendLastMessage ,
      'dateTime' :dateTime ,
      'date' :date ,
      'time' :time ,
      'membersUid' : membersUid ,
      'messageType' : messageType ,
      'groupMessagesThatNotSeen' : groupMessagesThatNotSeen
    };
  }
}