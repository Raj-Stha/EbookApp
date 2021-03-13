import 'package:Ebook_App/screens/client/client_dashboard.dart';
import 'package:Ebook_App/screens/login_screen.dart';
import 'package:Ebook_App/screens/signup_screen.dart';
import 'package:Ebook_App/services/ebook_function.dart';
import 'package:Ebook_App/services/users_function.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:Ebook_App/screens/splash_screen.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:provider/provider.dart';
import 'screens/admin/admin_dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FlutterDownloader.initialize();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserFunction(),
        ),
        ChangeNotifierProvider(
          create: (context) => EBookFunction(),
        ),
      ],
      child: MaterialApp(
        title: 'EbookApp',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        routes: {
          '/': (context) => SplashScreen(),
          LoginScreen.routeName: (context) => LoginScreen(),
          SignUp.routeName: (context) => SignUp(),
          AdminDashboard.routeName: (context) => AdminDashboard(),
          ClientDashboard.routeName: (context) => ClientDashboard(),
        },
      ),
    );
  }
}
