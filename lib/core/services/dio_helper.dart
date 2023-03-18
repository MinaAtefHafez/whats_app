



import 'dart:io';
import 'package:dio/dio.dart';
import 'package:whats_app/view/components/snack_bar_fun.dart';

abstract class BaseDioHelper {
  Future <void> postData ({
     required String url ,
     required Map <String ,dynamic > data
  }) ;
}



class DioHelper implements BaseDioHelper {
  @override
  Future<void> postData ({
    required String url ,
    required Map <String, dynamic> data
  }) async 
  {


        try {
        Response response =  await Dio().post(
              url ,
             data: data , 
             options: Options(
              headers: {
                'Content-Type' : 'application/json' ,
                 'Authorization' : 'key=AAAAclmcJa8:APA91bEJ1RWvOxeP4A2oVEMF3S4iP1bwhyn1RY-bk-tKPzrQtMznDlbBh36hsrwZ7YEIGKXxHWFGgtkaNdFHR27QrLJurY8xvNPN6xcgrJtF019FibRIVT7wY1Fhj2MV3iINjBsc3IBm' ,
              }
             )
        );

         if ( response.statusCode != 200 ) {
           showSnackBar(title: 'Error $response.statusCode' , message: response.statusMessage.toString() ); 
        }
        
        } on SocketException {
             showSnackBar(title: '' , message:  'check your internet connect !' );
        } catch (e) {
           showSnackBar(title: '', message: 'error , try later' );
        }

  }



    

}