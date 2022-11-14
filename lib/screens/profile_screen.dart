import 'package:eduk/models/yourCourses.dart';
import 'package:eduk/resources/auth_methods.dart';

import 'package:eduk/screens/login_screen.dart';
import 'package:eduk/screens/terms_and_conditions.dart';
import 'package:eduk/screens/upload_pdf.dart';
import 'package:eduk/screens/your_courses_screen.dart';
import 'package:eduk/screens/upload_course_sceen.dart';
import 'package:eduk/utils/colors.dart';
import 'package:eduk/utils/utils.dart';
// import 'package:eduk/widget/follow_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduk/widgets/show_course_orders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../resources/firestore_methods.dart';
import '../widgets/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;

  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLen=0;
  int followers=0;
  int following =0;
  bool isFollowing=false;
  bool isLoading=false;
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState((){
      isLoading= true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();
      postLen= postSnap.docs.length;
      userData = userSnap.data()!;
      followers= userSnap.data()!['followers'].length;
      following= userSnap.data()!['following'].length;
      isFollowing = userSnap
      .data()!['followers']
      .contains(FirebaseAuth.instance.currentUser!.uid);
     setState(() {});
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    setState((){
      isLoading= false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child:CircularProgressIndicator(),
    )
        :Scaffold(
          drawer: Drawer(
            backgroundColor: Colors.black,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical:100.0,horizontal: 8.0),
              child: ListView(
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
                children: [
                  // const DrawerHeader(
                  //   decoration: BoxDecoration(
                  //     color: Colors.blue,
                  //   ),
                  //   child: Text('Drawer Header'),
                  // ),
                  ListTile(
                    title: const Text('YourCourses'),
                    onTap: () {
                     Navigator.push(
                         context, MaterialPageRoute(builder: (context)=>
                        YourCoursesScreen()
                     ));
                    },
                  ),
                  ListTile(
                    title: const Text('Upload Course'),
                    onTap: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context)=>
                          UploadCourseScreen()
                      ));
                    },
                  ),
                  ListTile(
                    title: const Text('Terms And Conditions'),
                    onTap: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context)=>
                          TermsAndConditions()
                      ));
                    },
                  ),
                  ListTile(
                    title: const Text('Your Course Orders'),
                    onTap: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context)=>
                          ShowCourseOrders()
                      ));
                    },
                  ),
                  ListTile(
                    title: const Text('SignOut'),
                    onTap: () {
                      // Update the state of the app.
                      // ...
                    },
                  ),
                  ListTile(
                    title: const Text('Pdfs'),
                    onTap: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context)=>
                      UploadPdfsToFirestore()
                      ));
                    },
                  ),
                ],
              ),
            ),
         ),
          appBar: AppBar(

             backgroundColor: mobileBackgroundColor,
             title: Text(
            userData['username']
        ), 
            centerTitle: false,
          
      ),
          body: ListView(
            children: [
             Padding(
               padding: const EdgeInsets.all(16),
                   child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage(userData['photoUrl']),
                      radius: 40,
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              buildStatColumn(postLen, 'posts'),
                              buildStatColumn(followers, 'followers'),
                              buildStatColumn(following, 'following'),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                            FirebaseAuth.instance.currentUser!.uid==widget.uid
                                ? FollowButton(
                                borderColor: Colors.grey,
                                backgroundColor: mobileBackgroundColor,
                                text: 'Sign Out',
                                textColor: primaryColor,
                                function: () async {
                                  await AuthMethods().signOut();
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(builder: (context)=>
                                      const LoginScreen(),
                                    )
                                  );
                                },
                              ): isFollowing ?FollowButton(
                              borderColor: Colors.grey,
                              backgroundColor: Colors.white,
                              text: 'Unfollow',
                              textColor: Colors.black,
                              function: () async {
                                await FireStoreMethods().followUser(
                                  FirebaseAuth.instance.currentUser!.uid,
                                  userData['uid']
                                );
                                setState((){
                                  isFollowing=false;
                                  followers--;
                                });
                              },
                            ): FollowButton(
                              borderColor: Colors.blue,
                              backgroundColor: Colors.blue,
                              text: 'Follow',
                              textColor: Colors.white,
                              function: () async {
                                await FireStoreMethods().followUser(
                                    FirebaseAuth.instance.currentUser!.uid,
                                    userData['uid'],
                                );
                                setState((){
                                    isFollowing=true;
                                    followers++;
                                });
                              },
                            )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(top: 15),
                    child: Text(
                      userData['username'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(top: 15),
                    child: Text(
                      userData['bio'],
                    )),
              ],
            ),
          ),
          const Divider(),
          FutureBuilder(
              future: FirebaseFirestore.instance.collection('posts').where('uid',isEqualTo:widget.uid).get(),
              builder: (context,snapshot){
                if(snapshot.connectionState==ConnectionState.waiting){
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return GridView.builder(
                  shrinkWrap: true,
                    itemCount: (snapshot.data!! as dynamic).docs.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 1.5,
                    childAspectRatio: 1,
                  ),
                itemBuilder: (context,index) {
                    DocumentSnapshot snap = (snapshot.data! as dynamic).docs[index];
                    return Container(
                      child: Image(
                        image: NetworkImage(
                            snap['postUrl'],
                      ),
                  fit:BoxFit.cover,
                    ),
                    );
                    },
                );
              }
          ),
        ],
      ),
    );
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
                fontSize: 15, fontWeight: FontWeight.w400, color: Colors.grey),
          ),
        )
      ],
    );
  }
}
