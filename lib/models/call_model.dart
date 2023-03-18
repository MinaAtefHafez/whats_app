

class CallModel {
  String callerId; 
  String callerName ;
  String callerPic ;
  String receiverId ;
  String receiverName ;
  String receiverPic ;
  String callId ;
  bool hasDialled ;

  CallModel ({
    required this.callerId ,
    required this.callerName ,
    required this.callerPic ,
    required this.receiverId ,
    required this.receiverName ,
    required this.receiverPic ,
    required this.callId ,
    required this.hasDialled ,
  });


 factory CallModel.fromJson ( Map <String ,dynamic> json ) { 
      return CallModel(
        callerId: json['callerId'] ,
       callerName: json['callerName'] ,
        callerPic: json['callerPic'] ,
         receiverId: json['receiverId'] , 
         receiverName: json['receiverName'] ,
          receiverPic: json['receiverPic'] ,
           callId: json['callId']  ,
           hasDialled: json['hasDialled']  ,
           );
  }

  Map <String,dynamic> toMap () {
    return {
      'callerId' :callerId ,
      'callerName' :callerName ,
      'callerPic' :callerPic ,
      'receiverId' : receiverId,
      'receiverName' :receiverName ,
      'receiverPic' : receiverPic,
      'callId' : callId,
      'hasDialled' : hasDialled
    };
  }
}