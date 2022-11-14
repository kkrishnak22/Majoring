
import 'dart:io';

import 'package:eduk/providers/user_provider.dart';
import 'package:eduk/responsive/mobile_screen_layout.dart';
import 'package:eduk/responsive/responsive_layout.dart';
import 'package:eduk/responsive/web_screen_layout.dart';
import 'package:eduk/screens/login_screen.dart';
import 'package:eduk/services/notification_service.dart';
import 'package:eduk/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'lib/firebase_options.dart';

// const AndroidNotificationChannel channel= AndroidNotificationChannel(
  // 'high imp',            //id
  // 'High Imp NOt Title',  //title
  //   description: 'Description',
  //   playSound:true);

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin=
//     FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage message) async{
  await Firebase.initializeApp();
  print('A bg message just showed up : ${message.messageId}');
}

Future<void> main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final messaging = FirebaseMessaging.instance;

  await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
 //
 // await flutterLocalNotificationsPlugin
 //  .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
 //  ?.createNotificationChannel(channel);
 await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
   alert: true,
   badge: true,
   sound: true,
 );
  runApp(const MyApp());

}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // void init(){
  //   final AndroidInitializationSettings initializationSettingsAndroid =
  //   AndroidInitializationSettings('app_icon');
  //
  //   final IOSInitializationSettings initializationSettingsIOS =
  //   IOSInitializationSettings(
  //     requestSoundPermission: false,
  //     requestBadgePermission: false,
  //     requestAlertPermission: false,
  //     onDidReceiveLocalNotification: onDidReceiveLocalNotification,
  //   );
  //
  //   final InitializationSettings initializationSettings =
  //   InitializationSettings(
  //       android: initializationSettingsAndroid,
  //       iOS: initializationSettingsIOS,
  //       macOS: null);
  // }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),)
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor
        ) ,
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context,snapshot) {
                if(snapshot.connectionState == ConnectionState.active){
                  if(snapshot.hasData){
                  return const   ResponsiveLayout(
                        mobileScreenLayout: MobileScreenLayout(),
                        webScreenLayout: WebScreenLayout()
                     );
                  }else if(snapshot.hasError){
                    return Center(
                      child: Text('${snapshot.error}'),
                    );
                  }
                }
                if (snapshot.connectionState == ConnectionState.waiting){
                  return const Center(
                    child: CircularProgressIndicator(
                      color :primaryColor,
                    ),
                  );
                }
                return const LoginScreen();
            }),
        //home: SignupScreen(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  // @override void initState(){
  //   super.initState();
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message){
  //     RemoteNotification? notification=message.notification;
  //     AndroidNotification? android = message.notification?.android;
  //     if(notification !=null && android != null){
  //       flutterLocalNotificationsPlugin.show(
  //         notification.hashCode,
  //         notification.title,
  //         notification.body,
  //         NotificationDetails(
  //           android: AndroidNotificationDetails(
  //             channel.id,
  //             channel.name,
  //             color: Colors.blue,
  //             playSound:true,
  //
  //
  //           ),
  //         ),
  //       );
  //     }
  //   });
  //
  //   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //     print('A new onMessOpenedApp event was published');
  //     RemoteNotification notification=message.notification!;
  //     AndroidNotification? android = message.notification?.android;
  //     if(notification !=null && android != null){
  //       showDialog(context: context, builder:(_){
  //         return AlertDialog(
  //                  title: Text(notification.title!),
  //           content: SingleChildScrollView(
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(notification.body!)
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  //     }
  //
  //   });
  // }

  void _incrementCounter() {
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text("Vendors App"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
             Text(""),
          ],
        ),
      ),
    );
  }
}
