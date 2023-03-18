class MessageModel {
  String? text;
  String? type;
  String? senderId;
  String? receiverId;
  String? profilePic ;
  String? dateTime;
  String? dateMonthYear ;
  String? time;
  String? fileUrl ;
  bool? isSeen;
  String? repliedText ;
  String? repliedType ;
  String? repliedFileUrl ;
  String? messageId ;
  String? contactName ;
  String? senderName ;
  String? repliedId ;
  bool? isDeleted ;

  MessageModel({
     this.text,
     this.type,
     this.senderId,
     this.receiverId,
     this.profilePic ,
     this.time,
     this.dateTime,
     this.dateMonthYear ,
     this.isSeen,
     this.fileUrl ,
     this.repliedType ,
     this.repliedFileUrl,
     this.repliedText ,
     this.messageId ,
     this.contactName,
     this.senderName ,
     this.repliedId ,
     this.isDeleted
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
        text: json['text'],
        type: json['type'],
        senderId: json['senderId'],
        receiverId: json['receiverId'],
        profilePic: json['profilePic'],
        time: json['time'],
        dateTime: json['dateTime'],
        dateMonthYear: json['dateMonthYear'],
        fileUrl: json['fileUrl'],
        isSeen: json['isSeen'],
        repliedText: json['repliedText'] ,
        repliedType:  json['repliedType'] ,
        repliedFileUrl:  json['repliedFileUrl'] ,
        messageId:  json['messageId'] ,
        contactName:  json['contactName'] ,
        senderName:  json['senderName'] ,
        repliedId:  json['repliedId'] ,
        isDeleted:  json['isDeleted'] ,
        );
  }
  
  Map <String,dynamic> toMap () {
     return {
      'text' : text ,
      'type' : type ,
      'senderId' : senderId ,
      'receiverId' : receiverId ,
      'profilePic' : profilePic ,
      'time' : time ,
      'dateTime' : dateTime ,
      'dateMonthYear' : dateMonthYear ,
      'isSeen' : isSeen ,
      'fileUrl' : fileUrl ,
      'repliedText' : repliedText ,
      'repliedType' : repliedType ,
      'repliedFileUrl' : repliedFileUrl ,
      'messageId' : messageId ,
      'contactName' : contactName ,
      'senderName' : senderName,
      'repliedId' : repliedId ,
      'isDeleted' : isDeleted
     };
  }

}
