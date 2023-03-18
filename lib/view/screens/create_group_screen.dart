
// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:get/get.dart';
import 'package:whats_app/core/constants/colors.dart';
import 'package:whats_app/core/constants/constants.dart';
import 'package:whats_app/view/components/custom_text_form_field.dart';
import 'package:whats_app/view/components/dialog_show_loading.dart';
import 'package:whats_app/view/components/snack_bar_fun.dart';
import 'package:whats_app/view/controllers/group_controller.dart';

class CreateGroupScreen extends StatefulWidget {
  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  TextEditingController textController = TextEditingController(); 
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) { 
    return  GetBuilder<GroupController>(

      builder: (groupController) {
      SchedulerBinding.instance.addPostFrameCallback((_){
          if ( groupController.createGroupState == LoadState.loading ) {
             dialogToShowLoading(showText: 'Waiting to create Group ...' );
          } else if ( groupController.createGroupState == LoadState.loaded ) {
            Get.back();
            Get.back();
            showSnackBar(title: 'The group has been created successfully', message: '');
            groupController.createGroupState = LoadState.stable;
          }
      });

      return Scaffold(
      backgroundColor: AppColors.mainColor,
      appBar: appBar ,
      floatingActionButton: FloatingActionButton( 
        onPressed: (){
           if ( formKey.currentState!.validate() ) {
                  groupController.createGroup(
                    groupName: textController.text.trim() ,
                   lastMessage: '' ,
                    file: groupController.groupPic! ,
                     senderId: FirebaseAuth.instance.currentUser!.uid ,
                      membersUid: groupController.membersUid()
                      );
           }
        } ,
         backgroundColor: AppColors.tabColor,
        child: const Icon(Icons.done),
       ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric( horizontal: 20 ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:  [
               const SizedBox(height: 40),
               Center(
                 child: Stack(
                   children:[ 
                    CircleAvatar(
                    radius: 70 ,
                    backgroundImage: groupController.defaultGroupPic( file: groupController.groupPic ) ,
                   ),
                   Positioned(
                            left: 80,
                            bottom: -10,
                            child: IconButton(
                                onPressed: () {
                                      groupController.pickGroupPic();
                                },
                                icon: const Icon(
                                  Icons.add_a_photo,
                                  color: AppColors.tabColor,
                                  size: 30,
                                )),
                          ),
                   ],
                 ),
               ),
                const SizedBox(height: 20 ,) ,
                Form(
                  key: formKey ,
                  child: CustomTextFormField(hint: 'Enter Group Name', isCenter: false, 
                   controller: textController ,
                   validator: (value) {
                    if ( value.isEmpty ) {
                      return 'Enter Group Name !' ;
                    }

                    return null ;
                   } ,
                   ),
                ),
                 const SizedBox(height: 15 ),
                 const Text('Select Contacts' , style: TextStyle( color: AppColors.tabColor , fontSize: 20 , fontWeight: FontWeight.w600  ), ),
                 const SizedBox(height: 15 ,),
                  showAllContacts(groupController: groupController),
            ],
          ),
        ),
      ),
    );
    } );
  }

  AppBar appBar = AppBar(
    backgroundColor: AppColors.appBarColor,
    leading: IconButton(
      onPressed: (){
      Get.back();
    } , icon: const Icon(Icons.arrow_back_ios)),
    title: const Text('Create Group') ,
    centerTitle: true ,
    titleSpacing: 0.0 ,
  );

  Widget showAllContacts ({
     required GroupController groupController ,
  })
   {
    return FutureBuilder<List<Contact>>(
      future: groupController.getContacts() ,
      builder: (context , snapshot) {
          if ( snapshot.hasData ) {
             if ( snapshot.data!.isNotEmpty ) {
                 return Expanded(
                   child: ListView.builder(
                    itemBuilder: (context,index) {
                      
                    return Padding(
                      padding: const EdgeInsets.symmetric( vertical: 15 , horizontal: 5 ), 
                      child: InkWell(
                        onTap: () {
                         groupController.selectContactToCreateGroup(selectedContact: snapshot.data![index]);
                         setState(() {});
                        } ,
                        child: Row(
                          children: [
                            Builder(builder: (_) {
                                 if ( groupController.isContactSelected(selectedContact: snapshot.data![index]) ) {
                                    return const Padding(
                                        padding: EdgeInsets.only( right:  15 ),
                                        child: Icon(Icons.done , color: AppColors.tabColor, ),
                                      );
                                 } else {
                                  return Container();
                                 }
                            } ),
                            
                            Text( snapshot.data![index].displayName ,style: TextStyle( color: AppColors.greyWhiteColor , fontSize: 18   ) , ),
                          ],
                        ),
                      ),
                    );
                   } ,
                    itemCount: snapshot.data!.length,
                    ),
                 );   
             } else {
              return Container();
             }
          } else if ( snapshot.connectionState == ConnectionState.waiting ) {
               return Expanded(
                 child: Container(
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(color: AppColors.tabColor,),
                  ),
               );
          } else {
            return Container();
          }
      } ,
      );
  }

  

}