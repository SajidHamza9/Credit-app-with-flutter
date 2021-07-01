import 'package:credit_app/providers/auth.dart';
import 'package:credit_app/providers/clients.dart';
import 'package:credit_app/screens/contactsScreen.dart';
import 'package:credit_app/screens/homeScreen.dart';
import 'package:credit_app/screens/landingScreen.dart';
import 'package:credit_app/screens/loginScreen.dart';
import 'package:credit_app/screens/newClientScreen.dart';
import 'package:credit_app/screens/profileScreen.dart';
import 'package:credit_app/screens/signUpScreen.dart';
import 'package:credit_app/widgets/loading.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

Map<int, Color> color1 = {
  50: Color.fromRGBO(35, 35, 67, .1),
  100: Color.fromRGBO(35, 35, 67, .2),
  200: Color.fromRGBO(35, 35, 67, .3),
  300: Color.fromRGBO(35, 35, 67, .4),
  400: Color.fromRGBO(35, 35, 67, .5),
  500: Color.fromRGBO(35, 35, 67, .6),
  600: Color.fromRGBO(35, 35, 67, .7),
  700: Color.fromRGBO(35, 35, 67, .8),
  800: Color.fromRGBO(35, 35, 67, .9),
  900: Color.fromRGBO(35, 35, 67, 1),
};

Map<int, Color> color2 = {
  50: Color.fromRGBO(118, 120, 157, .1),
  100: Color.fromRGBO(118, 120, 157, .2),
  200: Color.fromRGBO(118, 120, 157, .3),
  300: Color.fromRGBO(118, 120, 157, .4),
  400: Color.fromRGBO(118, 120, 157, .5),
  500: Color.fromRGBO(118, 120, 157, .6),
  600: Color.fromRGBO(118, 120, 157, .7),
  700: Color.fromRGBO(118, 120, 157, .8),
  800: Color.fromRGBO(118, 120, 157, .9),
  900: Color.fromRGBO(118, 120, 157, 1),
};

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Clients(),
        ),
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            primarySwatch: MaterialColor(0xFF232343, color1),
            accentColor: MaterialColor(0xFF76789D, color2)),
        home: Root(),
        routes: {
          ProfileScreen.routeName: (ctx) => ProfileScreen(),
          NewClientScreen.routeName: (ctx) => NewClientScreen(),
          ContactScreen.routeName: (ctx) => ContactScreen(),
          LoginScreen.routeName: (ctx) => LoginScreen(),
          SignUpScreen.routeName: (ctx) => SignUpScreen(),
          HomeScreen.routeName: (ctx) => HomeScreen(),
          LandingScreen.routeName: (ctx) => LandingScreen(),
        },
      ),
    );
  }
}

class Root extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Provider.of<Auth>(context, listen: false).authStateChanges,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data?.uid == null) {
            return LandingScreen();
          } else {
            return FutureBuilder(
              future: Provider.of<Auth>(context, listen: false).getUserInfo(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Scaffold(body: Loading());
                } else {
                  if (snapshot.error != null) {
                    return Text(snapshot.error.toString()); // A regler
                  } else {
                    return HomeScreen();
                  }
                }
              },
            );
          }
        } else {
          return Scaffold(body: Loading());
        }
      },
    );
  }
}
