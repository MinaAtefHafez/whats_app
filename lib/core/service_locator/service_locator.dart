import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_it/get_it.dart';
import 'package:whats_app/core/services/dio_helper.dart';
import 'package:whats_app/view_models/auth_view_model.dart';
import 'package:whats_app/view_models/call_view_model.dart';
import 'package:whats_app/view_models/chat_view_model.dart';
import 'package:whats_app/view_models/group_view_model.dart';
import 'package:whats_app/view_models/home_view_model.dart';
import 'package:whats_app/view_models/setting_view_model.dart';
import 'package:whats_app/view_models/status_view_model.dart';
import 'package:whats_app/view_models/upload_storage_view_model.dart';

final serviceLocator = GetIt.instance;

class ServicesLocator {
   void init()  {
    serviceLocator.registerLazySingleton<BaseAuthViewModel>(() =>
        AuthViewModel(serviceLocator(), serviceLocator() , serviceLocator()));

    serviceLocator.registerLazySingleton(() => FirebaseAuth.instance);

    serviceLocator.registerLazySingleton(() => FirebaseFirestore.instance);

    serviceLocator.registerLazySingleton(() => FirebaseMessaging.instance );

      serviceLocator.registerLazySingleton<BaseUploadStorageViewModel>(() => UploadStorageViewModel()  );

        serviceLocator.registerLazySingleton<BaseHomeViewModel>(
        () => HomeViewModel(serviceLocator() ,serviceLocator() ));

        serviceLocator.registerLazySingleton<BaseChatViewModel>(
        () => ChatViewModel(serviceLocator() , serviceLocator() , serviceLocator() , serviceLocator()));

       

        serviceLocator.registerLazySingleton<BaseStatusViewModel>(() => StatusViewModel(
          auth: serviceLocator(),
           firestore: serviceLocator() , 
            uploadStorageViewModel: serviceLocator() ) );

            serviceLocator.registerLazySingleton<BaseGroupViewModel>(() => GroupViewModel(uploadStorageViewModel: serviceLocator()) );
              serviceLocator.registerLazySingleton<BaseCallViewModel>(() => CallViewModel(auth: serviceLocator() , fireStore: serviceLocator()) );
              
              serviceLocator.registerLazySingleton<BaseDioHelper>(() => DioHelper() );

              serviceLocator.registerLazySingleton<BaseSettingViewModel>(() => SettingViewModel(serviceLocator(), serviceLocator() , serviceLocator() ) );
  
  }
}
