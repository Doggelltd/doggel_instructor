import 'package:doggel_instructor/providers/fetch_data.dart';
import 'package:doggel_instructor/screens/tabs_screen.dart';
import 'package:doggel_instructor/screens/verification_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
//import 'constants.dart';
import 'providers/auth.dart';
import 'screens/account_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/change_password.dart';
import 'screens/course_manager.dart';
import 'screens/edit_profile_screen.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  ).then((val) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => FetchData(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          title: 'Instructor App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            // ignore: deprecated_member_use
            // accentColor: kGreenColor,
            fontFamily: 'Poppins',
          ),
          debugShowCheckedModeBanner: false,
          home: const SplashScreen(),
          routes: {
            // '/home': (ctx) => const CourseManagerScreen(),
            '/home': (ctx) => TabsScreen(),
            AuthScreen.routeName: (ctx) => const AuthScreen(),
            AccountScreen.routeName: (ctx) => const AccountScreen(),
            EditProfileScreen.routeName: (ctx) => const EditProfileScreen(),
            ChangePassword.routeName: (ctx) => const ChangePassword(),
            CourseManagerScreen.routeName: (ctx) => CourseManagerScreen(),
            VerificationScreen.routeName: (ctx) => const VerificationScreen(),
          },
        ),
      ),
    );
  }
}
