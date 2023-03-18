


class ReactModel {
  int? reactType ;
  String? senderId ;
  String? nameSender ;
  String? imageSender ;
  String? dateTime ;
  
  ReactModel ({
    this.reactType ,
    this.senderId ,
    this.nameSender ,
    this.imageSender ,
    this.dateTime ,
  });

 factory ReactModel.fromJson ( Map <String ,dynamic> json ) {
    return ReactModel(
      reactType: json['reactType'] ,
      senderId: json['senderId'] ,
      nameSender: json['nameSender'] ,
      imageSender: json['imageSender'] ,
      dateTime: json['dateTime'] ,
    );
  }


  Map < String ,dynamic> toMap () {
    return {
      'reactType' : reactType ,
      'senderId' : senderId ,
      'nameSender' : nameSender ,
      'imageSender' : imageSender ,
      'dateTime' : dateTime ,
    };
  }
}