
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covidcapstone/Pages/landing_page.dart';
import 'package:covidcapstone/Pages/notification_page.dart';
import 'package:covidcapstone/Pages/on_boarding_components/getting_started_screen.dart';
import 'package:covidcapstone/Pages/on_boarding_components/onboarding.dart';
import 'package:covidcapstone/models/citizen.dart';
import 'package:covidcapstone/models/health_declaration.dart';
import 'package:covidcapstone/pages/check_status_page.dart';
import 'package:covidcapstone/pages/report/confirm_success.dart';
import 'package:covidcapstone/pages/health_declaration_page.dart';
import 'package:covidcapstone/pages/home_page.dart';
import 'package:covidcapstone/Widgets/scaffold_adaptive.dart';
import 'package:covidcapstone/pages/qr_registration_page.dart';
import 'package:covidcapstone/pages/qr_scan_page.dart';
import 'package:covidcapstone/pages/report/confirm_report_view.dart';
import 'package:covidcapstone/pages/report/test_report_view.dart';
import 'package:covidcapstone/pages/scan_again_page.dart';
import 'package:covidcapstone/pages/scanning_registration_page.dart';
import 'package:covidcapstone/pages/sign_in/sign_in.dart';
import 'package:covidcapstone/pages/success_page.dart';
import 'package:covidcapstone/pages/thankyou_page.dart';
import 'package:covidcapstone/pages/verify.dart';
import 'package:covidcapstone/pages/visited.dart';
import 'package:covidcapstone/services/constants.dart';
import 'package:covidcapstone/services/page_route/page_route.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show TargetPlatform;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Pages/phone_number_page.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/foundation.dart' as foundation;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

final String title = "Naggapwam App";
final String initialRoute = "/";

bool get isIoss => foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  static final navKey = new GlobalKey<NavigatorState>();

  dynamic buildTheme(TargetPlatform platform, BuildContext context) {
    if(platform == TargetPlatform.iOS) {
      return CupertinoThemeData(
        scaffoldBackgroundColor: backgroundColor,
        primaryColor: CupertinoColors.activeBlue,
        barBackgroundColor: CupertinoColors.extraLightBackgroundGray,
      );
    }else {
      return ThemeData(
        backgroundColor: backgroundColor,
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
      );
    }
  }

  Widget buildApp(TargetPlatform platform, BuildContext context) {
    if(platform == TargetPlatform.iOS) {
      return CupertinoApp(
        title: title,
        initialRoute: initialRoute,
        onGenerateRoute: Router(platform).generateRoute,
        theme: buildTheme(platform, context),
      );
    }else {
      return OverlaySupport(
        child: MaterialApp(
          title: title,
          initialRoute: initialRoute,
          onGenerateRoute: Router(platform).generateRoute,
          theme: buildTheme(platform, context),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var platform = Theme.of(context).platform;
    return buildApp(platform, context);
  }
}

class Router {

  final TargetPlatform platform;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  FirebaseMessaging _firebaseMessaging;

  Router(this.platform);

  void setUpFirebaseMessaging() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _firebaseMessaging = FirebaseMessaging.instance;
    initState();
  }

  Future _showNotification(RemoteNotification message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'channel id',
      'channel name',
      'channel desc',
      importance: Importance.max,
      priority: Priority.high,
    );
    var platformChannelSpecifics =
    new NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      message.title,
      message.body,
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }

  getTokenz() async {
    String token = await _firebaseMessaging.getToken();
    addStringToSF("token", token);
    if(!isIoss) {
      FirebaseFirestore.instance.collection("fcmTokens").doc(token).set({
        'timestamp': FieldValue.serverTimestamp()
      })
          .then((value) => print("Fcm token has been added"))
          .catchError((error) => print("Failed to add fcm token"));
    }
    print(token);
  }

  Future selectNotification(String payload) async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  void initState() {
    var initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    if(isAndroid) {
      var initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
      flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onSelectNotification: selectNotification);
    }

    FirebaseMessaging.onBackgroundMessage((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      return _showNotification(notification);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;

      if (notification != null && android != null) {
        _showNotification(notification);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
    });

    getTokenz();
  }

  Widget _fbInitializer(Widget page) {
    final Future _fbApp = Firebase.initializeApp();

    return FutureBuilder(
      future: _fbApp,
      builder: (context, snapshot) {
        if(snapshot.hasError) {
          print("Value: " + snapshot.toString());
          print("You have an error! ${snapshot.error.toString()}");
          return Text("Some went wrong");
        }else if(snapshot.hasData) {
          setUpFirebaseMessaging();
          return page;
        }else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Route<dynamic> generateRoute(RouteSettings settings) {
    PageRouting routing = PageRouting(platform);
    switch (settings.name) {
      case '/':
        if(isDeveloping) {
          // Development
          return routing.pageRoute(nextScreen: _fbInitializer(ScanAgainPage()));
        }else {
          // Production
          if(kIsWeb) {
            return routing.pageRoute(nextScreen: _fbInitializer(LandingPage()));
          }else {
            return routing.pageRoute(nextScreen: _fbInitializer(OnboardingScreen()));
          }
        }
        break;
      case '/onBoarding':
        return routing.pageRoute(nextScreen: OnboardingScreen());
      case '/landing':
        return routing.pageRoute(nextScreen: LandingPage());
      case '/phoneNumber':
        return routing.pageRoute(nextScreen: PhoneNumberPage());
      case '/getStarted':
        return routing.pageRoute(nextScreen: GettingStarted());
      case '/thankYou':
        return routing.pageRoute(nextScreen: ThankYouPage());
      case '/homePage':
        return routing.pageRoute(nextScreen: HomePage());
      case '/individualRegistration':
        return routing.pageRoute(nextScreen: QrRegistrationPage());
      case '/notification':
        return routing.pageRoute(nextScreen: NotificationPage());
      case '/healthDeclaration':
        return routing.pageRoute(nextScreen: HealthDeclarationPage(citizen: settings.arguments, hdf: HealthDeclaration(), formKey: GlobalKey<FormState>()));
      case '/successPage':
        return routing.pageRoute(nextScreen: SuccessPage(arguments: settings.arguments,));
      case '/checkStatus':
        return routing.pageRoute(nextScreen: CheckStatusPage());
      case '/scanningRegistration':
        return routing.pageRoute(nextScreen: ScanningRegistrationPage());
      case '/signIn':
        return routing.pageRoute(nextScreen: SignIn());
      case '/qrScan':
        return routing.pageRoute(nextScreen: QrScanPage());
      case '/verify':
        return routing.pageRoute(nextScreen: PhoneAuthVerify(phoneNumber: settings.arguments.toString(),));
      case '/report':
        return routing.pageRoute(nextScreen: TestReportView());
      case '/confirmReport':
        return routing.pageRoute(nextScreen: ConfirmReportView());
      case '/confirmSuccess':
        return routing.pageRoute(nextScreen: ConfirmSuccess());
      case '/placesVisited':
        return routing.pageRoute(nextScreen: VisitedPage());
      case '/scanAgain':
        return routing.pageRoute(nextScreen: ScanAgainPage());
      default:
        return routing.pageRoute(
            nextScreen: ScaffoldAdaptive(
              isIncludeBottomBarAndroid: false,
              child: Center(
                  child: Text('No route defined for ${settings.name}')),
            )
        );
    }
  }

}
