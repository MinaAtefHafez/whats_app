
class LastMessageModel {
  String lastMessage;
  String name;
  String profilePic;
  String contactId ;
  String dateTime;
  String time;
  String dateMonthYear ;
  String messageType ;
  int? countMessagesThatNotSeen ;
  

  LastMessageModel({
    required this.name,
    required this.lastMessage,
    required this.profilePic,
    required this.dateTime,
    required this.time,
    required this.dateMonthYear,
    required this.contactId,
    required this.messageType ,
     this.countMessagesThatNotSeen
  });

  factory LastMessageModel.fromJson(Map<String, dynamic> json) {
    return LastMessageModel(
      name: json['name'],
      lastMessage: json['lastMessage'],
      profilePic: json['profilePic'],
      dateTime: json['dateTime'],
      time: json['time'],
      dateMonthYear: json['dateMonthYear'],
      contactId: json['contactId'] ,
      messageType: json['messageType'] ,
      countMessagesThatNotSeen:  json['countMessagesThatNotSeen']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'lastMessage': lastMessage,
      'profilePic': profilePic,
      'dateTime': dateTime,
      'time': time,
      'dateMonthYear' : dateMonthYear ,
      'contactId' : contactId ,
      'messageType' : messageType ,
       'countMessagesThatNotSeen' : countMessagesThatNotSeen
    };
  }
}
