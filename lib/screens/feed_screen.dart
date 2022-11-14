import 'package:carousel_slider/carousel_slider.dart';
import 'package:eduk/models/carouselmodel.dart';
import 'package:eduk/resources/firebase_dynamic_links.dart';
import 'package:eduk/services/banner_service.dart';
import 'package:eduk/utils/colors.dart';
import 'package:eduk/utils/global_variable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../resources/firebase_dynamic_links.dart';
import '../utils/data.dart';
import '../widgets/city_item.dart';
import '../widgets/feature_item.dart';
import '../widgets/recommend_item.dart';
import '../widgets/single_course_widget.dart';

// const AndroidNotificationChannel channel = AndroidNotificationChannel(
//     'high imp', //id
//     'High Imp NOt Title', //title
//     description: 'Description',
//     playSound: true);

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  // FlutterLocalNotificationsPlugin();
  Position? _position;
  String? currentAddress;
  bool isLoading = false;
  List<CarouselModel> carouselItemList =
      List<CarouselModel>.empty(growable: true);
  List<Widget>? allCourses;
  Future getCarouselSlider() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("banners").get();
    return querySnapshot;
  }

  @override
  void initState() {
    // FirebaseDynamicLinkService.initDynamicLink(context);

    super.initState();

    void initState() {
      super.initState();
      FirebaseDynamicLinkService.initDynamicLink(context);
    }
    // getFeature();
    // getData();
    // setState(() {
    //
    // });
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   RemoteNotification notification = message.notification!;
    //   AndroidNotification? android = message.notification?.android;
    //   if (notification != null && android != null) {
    //     flutterLocalNotificationsPlugin.show(
    //       notification.hashCode,
    //       notification.title,
    //       notification.body,
    //       NotificationDetails(
    //         android: AndroidNotificationDetails(
    //           channel.id,
    //           channel.name,
    //           channelDescription: channel.description,
    //           color: Colors.blue,
    //           playSound: true,
    //         ),
    //       ),
    //     );
    //   }
    // });
    //
    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   print('A new onMessOpenedApp event was published');
    //   RemoteNotification notification = message.notification!;
    //   AndroidNotification? android = message.notification?.android;
    //   if (notification != null && android != null) {
    //     showDialog(
    //         context: context,
    //         builder: (_) {
    //           return AlertDialog(
    //             title: Text(notification.title.toString()),
    //             content: SingleChildScrollView(
    //               child: Column(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [Text(notification.body.toString())],
    //               ),
    //             ),
    //           );
    //         });
    //   }
    // });
  }

  // void getData()async{
  //   List<Widget> allCoursesFromDb = await CloudFirestoreClass().getCoursesFromDb(100);
  //
  //   setState((){
  //    try{
  //      allCourses=allCoursesFromDb;
  //    }catch(e){
  //      showSnackBar(e.toString(), context);
  //    }
  //     print(allCourses);
  //   });
  // }
  // void showNotification() {
  //   setState(() {
  //     IconButton(
  //       onPressed: showNotification,
  //       icon: const Icon(Icons.messenger_sharp),
  //     );
  //   });
  //   flutterLocalNotificationsPlugin.show(
  //       0,
  //       "testing 2",
  //       "HOw u doing?",
  //       NotificationDetails(
  //           android: AndroidNotificationDetails(
  //         channel.id,
  //         channel.name,
  //         channelDescription: 'this is drs',
  //         color: Colors.blue,
  //         playSound: true,
  //       )));
  // }
  Future<Position> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error('Allow Location');
      }
    } else {
      var p = await Geolocator.getCurrentPosition();
      print(p);
      print('Location Not Available');
    }
    return await Geolocator.getCurrentPosition();
  }

  void _getAddress(longitude, latitude) async {
    try {
      List<Placemark> placemark = await GeocodingPlatform.instance
          .placemarkFromCoordinates(latitude, longitude);
      Placemark place = placemark[0];
      setState(() {
        currentAddress =
            '${place.locality},${place.postalCode},${place.country}';
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      // drawer: Drawer(
      //   child: ListView(
      //     padding: EdgeInsets.zero,
      //     children: [
      //       DrawerHeader(
      //           child: Text('Drawer Header'),
      //           decoration: BoxDecoration(
      //             color: Colors.black,
      //           )),
      //       ListTile(
      //         title: Text('Community'),
      //         onTap: () {
      //           // Update the state of the app
      //           // ...
      //           // Then close the drawer
      //           Navigator.pop(context);
      //         },
      //       ),
      //     ],
      //   ),
      // ),
      backgroundColor:
          width > webScreenSize ? webBackgroundColor : mobileBackgroundColor,
      appBar: width > webScreenSize
          ? null
          : AppBar(
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[Colors.pink, Colors.blue]),
                ),
              ),
              backgroundColor: mobileBackgroundColor,
              centerTitle: false,
              title: const Text(
                  'Find Courses',
                style: TextStyle(
                  fontSize: 18
                ),

              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      splashRadius: 60,
                        tooltip:isLoading
                            ? currentAddress!
                            :"wait! Loading",
                        onPressed: () async {
                          setState(() {});
                          _position = await _getCurrentLocation();
                          _getAddress(_position!.longitude, _position!.latitude);
                          setState(() {
                            isLoading = true;
                          });
                          print(currentAddress);
                        },

                      icon: Icon(Icons.location_on_outlined,),
                        // icon: isLoading
                        //     ? Text(
                        //       currentAddress!,
                        //     )
                        //     : Container(
                        //       width: 90,
                        //       child: Icon(
                        //       Icons.location_on_outlined,
                        //         size: 30,
                        // ),
                        //     )
                    ),
                   isLoading? Text(
                       "Long press Icon"
                   )
                       :Text("Tap Icon for..")
                  ],
                ),
              ],
            ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: [
            /////////// BAnner/////////////////
            //     SizedBox(
            //      child: InkWell(
            //          onTap:() async{
            //            setState((){
            //
            //            });
            //            _position = await _getCurrentLocation();
            //            _getAddress(_position!.longitude,_position!. latitude);
            //            setState((){
            //             isLoading=true;
            //            });
            //           print(currentAddress);
            //          },
            //          child: Text('get location')),
            // ),
            SizedBox(
              child: FutureBuilder(
                  future: FirebaseFirestore.instance.collection('baner').get(),
                  builder: (context, snapshot) {
                    return CarouselSlider.builder(
                      itemCount: (snapshot.data!! as dynamic).docs.length,
                      itemBuilder: (context, index, one) {
                        DocumentSnapshot snap =
                            (snapshot.data! as dynamic).docs[index];
                        return Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.red,
                              image: DecorationImage(
                                image: NetworkImage(
                                  snap['image'],
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                            margin: const EdgeInsets.all(5),
                            child: Text(""));
                      },
                      options: CarouselOptions(
                        autoPlay: true,
                      ),
                    );
                  }),
            ),

            //getFeature(),
            /////////// //RECOMMENDED/////////////
            const Padding(
              padding:
                  EdgeInsets.only(right: 250, top: 10, bottom: 10, left: 0),
              child: Text(
                "Recommended",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('recommendedCourses')
                    .snapshots(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.builder(
                      //scrollDirection : Axis.horizontal,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (ctx, index) {
                        final Map<String, dynamic> documentSnapshotOFCourse =
                            snapshot.data!.docs[index].data();
                        return Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: width > webScreenSize ? width * 0.3 : 0,
                            vertical: width > webScreenSize ? 15 : 0,
                          ),
                          child: RecommendItem(
                            courseSnapShot: documentSnapshotOFCourse,
                            data: recommends[index],
                            // user: user,
                            //data: null,
                          ),
                        );
                      });
                },
              ),
            ),
            // getRecommend(),
            const Padding(
              padding:
                  EdgeInsets.only(right: 250, top: 10, bottom: 10, left: 0),
              child: Text(
                "All Courses",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            //ALL Courses/////////////////////
            SizedBox(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('allCourses')
                    .snapshots(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.builder(
                      //    scrollDirection : Axis.horizontal,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (ctx, index) {
                        final Map<String, dynamic> documentSnapshotOFCourse =
                            snapshot.data!.docs[index].data();
                        return Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: width > webScreenSize ? width * 0.3 : 0,
                            vertical: width > webScreenSize ? 15 : 0,
                          ),
                          child: SingleCourseWidget(
                            courseSnapShot: documentSnapshotOFCourse,
                            // user: user,
                            //data: null,
                          ),
                        );
                      });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  getFiltersOnHomePage() {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(15, 5, 0, 10),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          cities.length,
          (index) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: CityItem(
              data: cities[index],
              onTap: () {},
            ),
          ),
        ),
      ),
    );
  }

  // getRecommend() {
  //   return SingleChildScrollView(
  //     padding: EdgeInsets.fromLTRB(15, 5, 0, 5),
  //     scrollDirection: Axis.horizontal,
  //     child: Row(
  //       children: List.generate(
  //         recommends.length,
  //             (index) => Padding(
  //           padding: const EdgeInsets.only(right: 10),
  //           child: RecommendItem(
  //             data: recommends[index],
  //             onTap: () {},
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

}
