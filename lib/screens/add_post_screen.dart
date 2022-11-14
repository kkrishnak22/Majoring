import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduk/models/course_model.dart';
import 'package:eduk/utils/colors.dart';
import 'package:eduk/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../constants/utils.dart';
import '../models/user.dart' as firebase_auth_firebase_auth;
import '../models/user.dart' as models_user;
import '../providers/user_provider.dart';
import '../resources/firestore_methods.dart';
import '../services/cloudfirestore_methods.dart';
import '../widgets/custom_main_button.dart';
import '../widgets/text_field_input.dart';
import '../widgets/text_field_widget.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  List<int> keysForDiscount = [100];
  List<String> dropdownitems=<String>[
    'savings',
    '1','2','3'];
  var selectedType;
  Uint8List? _file;
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;
  TextEditingController titleController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController discountPriceController=TextEditingController();
  TextEditingController whoIsThisForController=TextEditingController();
  TextEditingController backgroundImageController=TextEditingController();
  TextEditingController thumbnailController=TextEditingController();
  TextEditingController coursePriceController=TextEditingController();
  bool isLoading = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  void postImage(String uid, String username, String profileImage,)async{
    setState((){_isLoading = true;});
    try{
        String res =
             await FireStoreMethods()
                 .uploadPost(
                  titleController.text,
                 priceController.text,
                  discountPriceController.text,
                  whoIsThisForController.text,
                  backgroundImageController.text,
                  thumbnailController.text,
                  _descriptionController.text,
                // Uint8List file,
                 _file!,

                 //_descriptionController.text,
                // _file!,
                 uid,
                 username,
                 profileImage

             );
        if(res == "success") {
          setState((){_isLoading = false;});
          showSnackBar('Posted!', context);
          clearImage();
        }else{
          setState((){_isLoading = false;});
          showSnackBar(res, context);
        }
      }catch(e){
        showSnackBar(e.toString(), context);
      }
  }
  _selectImage(BuildContext context) async {
    return showDialog(context:context,builder:(context){
      return SimpleDialog(
        title: const Text('Create Post'),
        children: [
          SimpleDialogOption(
            padding: const EdgeInsets.all(20),
            child: const Text('Take a photo'),
            onPressed: () async{
              Navigator.of(context).pop();
              Uint8List file = await pickImage(ImageSource.camera,);
              setState((){
                _file=file;
              });
            },
          ),
          SimpleDialogOption(
            padding: const EdgeInsets.all(20),
            child: const Text('Choose a photo'),
            onPressed: () async{
              Navigator.of(context).pop();
              Uint8List file = await pickImage(ImageSource.gallery,);
              setState((){
                _file=file;
              });
            },
          ),
         SimpleDialogOption(
           padding: const EdgeInsets.all(20.0),
           child : const Text("Cancel"),
           onPressed: (){
             Navigator.of(context).pop();
           },
         )
        ],
      );
    });
  }

  void clearImage() {
  setState((){
    _file=null;
  });
  }
  @override
  void dispose(){
    super.dispose();
    // _descriptionController.dispose();
    // coursePriceController.dispose();
    // thumbnailController.dispose();
    // backgroundImageController.dispose();
    // titleController.dispose();
    // whoIsThisForController.dispose();
    // coursePriceController.dispose();
    // discountPriceController.dispose();
  }
  @override
  Widget build(BuildContext context) {

    final firebase_auth_firebase_auth.User user = Provider.of<UserProvider>(context).getUser;

    return _file == null
        ? Scaffold(
          body: Column(


      children: [
          const SizedBox(
            height: 60,width: double.infinity,
          ),
          IconButton(
              onPressed: ()=>_selectImage(context),
              icon: const Icon(Icons.upload)
          ),
        Text("Create Post")
          
          //Upload Course

          // TextFieldInput(
          //   hintText: 'title',
          //   textInputType: TextInputType.text,
          //   textEditingController:titleController ,
          // ),
          // TextFieldInput(
          //   hintText: 'Enter the cost of the Course',
          //   textInputType: TextInputType.text,
          //   textEditingController:coursePriceController ,
          // ),
          // TextFieldInput(
          //   hintText: 'discount cost',
          //   textInputType: TextInputType.text,
          //   textEditingController:discountPriceController ,
          // ),
          // TextFieldInput(
          //   hintText: 'thumbnail',
          //   textInputType: TextInputType.text,
          //   textEditingController:thumbnailController ,
          // ),
          // TextFieldInput(
          //   hintText: 'backgrod',
          //   textInputType: TextInputType.text,
          //   textEditingController:backgroundImageController ,
          // ),
          // TextFieldInput(
          //   hintText: 'description',
          //   textInputType: TextInputType.text,
          //   textEditingController:_descriptionController ,
          // ),
          // TextFieldInput(
          //   hintText: 'who is this for',
          //   textInputType: TextInputType.text,
          //   textEditingController:whoIsThisForController ,
          // ),



          // CustomMainButton(
          //     color: Colors.deepOrange,
          //     isLoading: isLoading,
          //     onPressed: () async {
          //       String userId = await firebaseAuth.currentUser!.uid.toString();
          //       DocumentSnapshot documentSnapshot=
          //       await firebaseFirestore.collection("users").doc(userId).get();
          //       models_user.User userModel =models_user.User.getModelFromJsonOrSnap(
          //           snap: documentSnapshot);
          //         String uid = Utils().getUid();
          //       String output = await CloudFirestoreClass()
          //           .uploadCourseToDB(
          //           //currentUserId:CloudFirestoreClass().getCurrentUserId(),
          //           courseTitle: titleController.text,
          //           currentUserId:userId.toString(),
          //           courseDescription: _descriptionController.text,
          //           coursePrice:coursePriceController.text,
          //           courseBackgroundImage: backgroundImageController.text,
          //           courseDiscountPrice: discountPriceController.text,
          //           courseThumbnail: thumbnailController.text,
          //
          //           courseWhoIsThisFor: whoIsThisForController.text,
          //           courseuid: uid,
          //        // user: userModel,
          //       );
          //
          //       if (output == "success") {
          //         Utils().showSnackBar(
          //             context: context,
          //             content: "Course Uploaded");
          //       } else {
          //         Utils().showSnackBar(
          //             context: context, content: output);
          //       }
          //     },
          //     child: const Text(
          //       "Post Course",
          //       style: TextStyle(color: Colors.black),
          //     )
          // ),
          //
          //
          //
          //
          // CustomMainButton(
          //     child: Text("Test"),
          //     color: Colors.deepPurple,
          //     isLoading: isLoading,
          //     onPressed: ()async{
          //       try {
          //         String outPut =await CloudFirestoreClass().getCurrentUserId();
          //         if(outPut!=""){
          //           print('suc');
          //           print(outPut.length);
          //         }else print("not pre");
          //       }catch(e){
          //
          //       }
          //     }),

      ],
    ),
        )
        : Scaffold(
          appBar: AppBar(
            backgroundColor: mobileBackgroundColor,
            leading: IconButton(
                onPressed: clearImage,
                icon: const Icon(Icons.arrow_back),),
            title: const Text('Post to'),
            centerTitle: false,
            actions: [
              TextButton(
                  onPressed:()=> postImage(
                      user.uid,user.username,user.photoUrl),
                  child: const Text(
                    'Post',
                    style: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),))
            ],
          ),
          body: SingleChildScrollView(
           child: Column(
             children: [
           _isLoading
               ? const LinearProgressIndicator()
               : const Padding(
               padding: EdgeInsets.only(top:0),
           ),
           const Divider(),
           SingleChildScrollView(
             child: Column(
               children: [
                 Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(user.photoUrl),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width*0.3,
                        child: TextField(
                          controller: titleController,
                          decoration: const InputDecoration(
                            hintText: 'Description ',
                            border: InputBorder.none,
                          ) ,

                        ),
                      ),
                      SizedBox(
                        height:45 ,
                        width: 45,
                        child: AspectRatio(
                            aspectRatio: 487/451,
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: MemoryImage(_file!),
                                  fit: BoxFit.fill,
                                  alignment: FractionalOffset.topCenter,
                                ),
                              ),
                            ),
                        ),
                      ),
                      const  Divider(),
                    ],
                  ),
                 // SizedBox(
                 //   width: MediaQuery.of(context).size.width*0.9,
                 //   child: TextField(
                 //     controller: priceController,
                 //     decoration: const InputDecoration(
                 //       hintText: 'Price',
                 //       border: InputBorder.none,
                 //     ) ,
                 //
                 //   ),
                 // ),
                 // SizedBox(
                 //   width: MediaQuery.of(context).size.width*0.9,
                 //   child: TextField(
                 //     controller: discountPriceController,
                 //     decoration: const InputDecoration(
                 //       hintText: 'Discount Price',
                 //       border: InputBorder.none,
                 //     ) ,
                 //
                 //   ),
                 // ),
                 // SizedBox(
                 //   width: MediaQuery.of(context).size.width*0.9,
                 //   child: TextField(
                 //     controller: _descriptionController,
                 //     decoration: const InputDecoration(
                 //       hintText: 'Description',
                 //       border: InputBorder.none,
                 //     ) ,
                 //
                 //   ),
                 // ),
                 // SizedBox(
                 //   width: MediaQuery.of(context).size.width*0.9,
                 //   child: TextField(
                 //     controller: whoIsThisForController,
                 //     decoration: const InputDecoration(
                 //       hintText: 'Who is this course for',
                 //       border: InputBorder.none,
                 //     ) ,
                 //
                 //
                 //   ),
                 // ),
                 // SizedBox(
                 //   width: MediaQuery.of(context).size.width*0.9,
                 //   child: TextField(
                 //     controller: backgroundImageController,
                 //     decoration: const InputDecoration(
                 //       hintText: 'Background Image For Course link',
                 //       border: InputBorder.none,
                 //     ) ,
                 //
                 //   ),
                 // ),
                 // SizedBox(
                 //   width: MediaQuery.of(context).size.width*0.9,
                 //   child: TextField(
                 //     controller: thumbnailController,
                 //     decoration: const InputDecoration(
                 //       hintText: 'Thumbnail Link',
                 //       border: InputBorder.none,
                 //     ) ,
                 //
                 //   ),
                 // ),

               //  StreamBuilder(builder: builder)
               ],
             ),
           ),
          ],
        ),
      ),
    );
  }
}
