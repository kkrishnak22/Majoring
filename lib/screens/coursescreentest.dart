import 'dart:convert';
import 'package:eduk/models/course_model.dart';
import 'package:eduk/services/cloudfirestore_methods.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:eduk/screens/your_courses_screen.dart';
import 'package:eduk/screens/youtube_video_player.dart';


import 'package:eduk/utils/utils.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:video_player/video_player.dart';


import '../constants/utils.dart';
import '../models/user.dart' as model_user;
import '../resources/firebase_dynamic_links.dart';
import '../resources/firestore_methods.dart';
import '../widgets/course_screen_buttons.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;

import 'package:eduk/razor_credentials.dart' as razorCredentials;



class CourseScreenTest extends StatefulWidget {
  final Map<String,dynamic> documentSnapshotOFCourse;
  final urlLandscapeVideo='';

  const CourseScreenTest({
   // required this.user,
    required this.documentSnapshotOFCourse,
    Key? key,
    //required this.videoController
  }) : super(key: key);
 // final VideoPlayerController videoController;
  @override
  State<CourseScreenTest> createState() => _CourseScreenTestState();
}

class _CourseScreenTestState extends State<CourseScreenTest> {
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children:  <Widget>[
                Text('Sucess'),
                Text('you can check your courses in your profile'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Done'),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context)=>
                        YourCoursesScreen()
                )
                );
              },
            ),
          ],
        );
      },
    );
  }

   final textController = TextEditingController(text: "urlLandscapeVideo");
   late  VideoPlayerController videoController;
   final _razorpay = Razorpay();
  @override
  void initState(){
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    });



    super.initState();



    videoController = VideoPlayerController.network(textController.text)
    ..addListener(() => setState(() { }))
    ..setLooping(true)
    ..initialize().then((_) => videoController.play());
  }


   Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
   model_user.User user= model_user.User.fromSnap(
       await FirebaseFirestore.instance
           .collection("users")
           .doc(FirebaseAuth.instance.currentUser!.uid).get()
   );
     // Do something when payment succeeds
     print(user.email);
     print(widget.documentSnapshotOFCourse);
     print("payment suc and working");
     print(response);
     showSnackBar(user.uid+user.email, context);
   print(user);
     verifySignature(
       signature: response.signature,
       paymentId: response.paymentId,
       orderId: response.orderId,
     );
     Navigator.push(context,
         MaterialPageRoute(builder: (builder)=>const YourCoursesScreen())
     );
      showSnackBar(user.uid+user.email, context);
   print(user.uid);
    try{
      await FireStoreMethods().sendCourseToYourCourses(
          user: user ,
          yourCourseDetails: widget.documentSnapshotOFCourse
      );
    }catch(e){

    }
   showSnackBar(user.uid+user.email, context);
   print(user);
     print("Course uploaded");

   }

   void _handlePaymentError(PaymentFailureResponse response) {
     print(response);
     // Do something when payment fails
     ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(
         content: Text(response.message ?? ''),
       ),
     );
   }

   void _handleExternalWallet(ExternalWalletResponse response) {
     print(response);
     // Do something when an external wallet is selected
     ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(
         content: Text(response.walletName ?? ''),
       ),
     );
   }


   void createOrder() async {
     String username = razorCredentials.keyId;
     String password = razorCredentials.keySecret;
     String basicAuth =
         'Basic ${base64Encode(utf8.encode('$username:$password'))}';

     Map<String, dynamic> body = {
       "amount": double.parse(
           widget.documentSnapshotOFCourse['courseDiscountPrice']
       ) * 100.00,
       "currency": "INR",
       "receipt": "rcptid_11"
     };
     var res = await http.post(
       Uri.https(
           "api.razorpay.com", "v1/orders"), //https://api.razorpay.com/v1/orders
       headers: <String, String>{
         "Content-Type": "application/json",
         'authorization': basicAuth,
       },
       body: jsonEncode(body),
     );

     if (res.statusCode == 200) {
       openGateway(jsonDecode(res.body)['id']);
     }
     print(res.body);
   }

   openGateway(String orderId) {
     var options = {
       'key': razorCredentials.keyId,
       'amount': 100, //in the smallest currency sub-unit.
       'name': 'Majoring ',
       'order_id': orderId, // Generate order_id using Orders API
       'description': widget.documentSnapshotOFCourse['courseDescription'],
       'timeout': 60 * 5, // in seconds // 5 minutes
       'prefill': {
         'contact': '7330637595',
         'email': 'krishnakumar.j22@gmail.com',
       }
     };
     _razorpay.open(options);
   }

   verifySignature({
     String? signature,
     String? paymentId,
     String? orderId,
   }) async {
     Map<String, dynamic> body = {
       'razorpay_signature': signature,
       'razorpay_payment_id': paymentId,
       'razorpay_order_id': orderId,
     };

     var parts = [];
     body.forEach((key, value) {
       parts.add('${Uri.encodeQueryComponent(key)}='
           '${Uri.encodeQueryComponent(value)}');
     });
     var formData = parts.join('&');
     var res = await http.post(
       Uri.https(
         "10.0.2.2", // my ip address , localhost
         "razorpay_signature_verify.php",
       ),
       headers: {
         "Content-Type": "application/x-www-form-urlencoded", // urlencoded
       },
       body: formData,
     );

     print(res.body);
     if (res.statusCode == 200) {
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
           content: Text(res.body),
         ),
       );
     }
   }




   @override
   void dispose(){
    videoController.dispose();
    _razorpay.clear();
    super.dispose();
   }
  @override
  Widget build(BuildContext context) {
  //  final User user = Provider.of<UserProvider>(context).getUser;
    return
       Scaffold(

       body: Stack(
        children: [
          Opacity(
            opacity: 0.4,
            child: Image(
              image: NetworkImage(
                  widget.documentSnapshotOFCourse['courseBackgroundImage']
              ),
            )
          ),
            //https://acache.veoh.com/file/f/h142231646.mp4?e=1667071307&rs=200&h=0d5ebc6b98c28c2d38c0481df33df811
          SingleChildScrollView(
            child: SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,  horizontal: 25,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: const Icon(
                                color:Colors.white,
                                size:30,
                                Icons.arrow_back
                            ),),
                          InkWell(
                            onTap: ()async{
                            //   FireStoreMethods().addCourseToFav(
                            //       widget.postId,
                            //       widget.uid,
                            //       widget.ifFav
                            //   );
                            //
                             },
                            child:
                            Icon(
                              color:Colors.white,
                              size:30,
                              Icons.favorite_border,
                            ),)
                        ],
                      ),
                    ),
                   const SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                  color: Colors.red.withOpacity(0.1),
                                  spreadRadius:1,
                                  blurRadius: 8,
                                )]
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                  widget.documentSnapshotOFCourse['courseThumbnail'],
                                  height:250,
                                  width: 180,
                                  fit: BoxFit.contain
                              ),
                            ),
                          ),
                          Container(
                            margin:const EdgeInsets.only(right: 50,top:70 ),
                            height: 80,
                            width: 80,
                            decoration:
                            BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                color: Colors.red,
                                boxShadow: [
                                  BoxShadow(
                                  color: Colors.red.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 6,
                                )]
                            ),
                            child:InkWell(
                              onTap: (){
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context)=>
                                      YoutubeVideoPlayer(
                                        youtubeLink:widget.documentSnapshotOFCourse['courseVideoLink']
                                      ),
                                      // CourseVideoScreen(
                                      // courseVideoLink:widget.documentSnapshotOFCourse['courseVideoLink']
                                      // ),
                                  ),
                                );
                              },

                              child: const Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                                size: 60,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),

                    Padding(
                      padding:const EdgeInsets.symmetric(vertical: 20,
                        horizontal: 10,),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                           widget.documentSnapshotOFCourse['courseTitle']
                            ,style: const TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w500
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                '\u{20B9} ${widget.documentSnapshotOFCourse['courseDiscountPrice']}'
                                ,style: const TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w500,

                              ),
                              ),
                              SizedBox(width: 40,),
                              Text(
                                '\u{20B9} ${widget.documentSnapshotOFCourse['coursePrice']}'
                                ,style: const TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.lineThrough,
                              ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15,),

                          Text(
                            widget.documentSnapshotOFCourse['courseDescription']
                            ,style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500
                            ),
                            textAlign: TextAlign.justify,
                          ),
                      const    SizedBox(height: 10,),
                          //const CourseScreenButtons(),
                          // ElevatedButton(
                          //     onPressed: () async {
                          //      String generatedDeepLink = await FirebaseDynamicLinkService.createDynamicLink(
                          //         true, widget.documentSnapshotOFCourse
                          //
                          //       );
                          //      print(generatedDeepLink);
                          //   Share.share(generatedDeepLink);
                          // },
                          //     child: Text("Share course")
                          // ),
                          // ElevatedButton(
                          //     onPressed: () async{
                          //
                          //     await  CloudFirestoreClass().addCourseToOnlineMeetingList(
                          //         snapshotOfCourse: widget.documentSnapshotOFCourse
                          //     );
                          //       },
                          //     child: const Text(
                          //   'Request to join in meeting'
                          //  )
                          //),
                        ],
                      ),

                    )
                  ],
                )),
              )

           ],
         ),
         bottomNavigationBar: BottomAppBar(
           child: Container(
             width: double.infinity,
             height: 80,
             child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white
                  ),
                 onPressed: () async{
                    createOrder();
              // await FireStoreMethods().sendCourseToYourCourses(
              //          user: user,
              //          yourCourseDetails: widget.documentSnapshotOFCourse
              //      );
             // _showMyDialog();
                 },
                 child:  Text(
                     "Enroll Now by " +",Paying \u{20B9} ${widget.documentSnapshotOFCourse['courseDiscountPrice']} " ,
                   style: const TextStyle(
                     fontSize: 22
                   ),
                 )),
           ),
         ),
       );

         }
       Widget buildVideo() => buildVideoPlayer();
       Widget buildVideoPlayer()=> 
           
           AspectRatio(
               aspectRatio: videoController.value.aspectRatio,
               child: VideoPlayer(videoController));
     }
