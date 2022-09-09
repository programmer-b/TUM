import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:nb_utils/nb_utils.dart';
// import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:tum/Constants/constants.dart';
import 'package:tum/UI/home/home.dart';
import 'package:tum/UI/setup/setup.dart';
import 'package:tum/Widgets/widgets.dart';
import 'package:tum/provider/provider.dart';

import 'Firebase/firebase.dart';
import 'UI/auth/auth.dart';

class TUM extends StatefulWidget {
  const TUM({Key? key}) : super(key: key);

  @override
  State<TUM> createState() => _TUMState();
}

class _TUMState extends State<TUM> {
  final FirebaseHelper helper = FirebaseHelper();
  AppUpdateInfo? _updateInfo;

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> _checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        _updateInfo = info;
      });
    }).catchError((e) {
      // toast(e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Phoenix(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeProvider>(
            create: (_) => ThemeProvider(),
          ),
          ChangeNotifierProvider<FirebaseAuthProvider>(
              create: (_) => FirebaseAuthProvider()),
          ChangeNotifierProvider<FirebaseApi>(
            create: (_) => FirebaseApi(),
          ),
          ChangeNotifierProvider<FirebaseHelper>(
            create: (_) => FirebaseHelper(),
          ),
          ChangeNotifierProvider<TUMState>(
            create: (_) => TUMState(),
          ),
          ChangeNotifierProvider<API>(create: (_) => API())
        ],
        child: Consumer<FirebaseHelper>(
          builder: (context, provider, child) {
            final themeProvider = Provider.of<ThemeProvider>(context);
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Technical University of Mombasa',
              themeMode: themeProvider.getTheme(provider),
              theme: MyThemes.lightTheme,
              darkTheme: MyThemes.darkTheme,
              routes: {
                '/login': (context) => const LoginScreen(),
                '/register': (context) => const RegisterScreen(),
                '/forgotPassword': (context) => const ForgotPasswordScreen(),
                '/home': (context) => const DashBoard(),
                '/eregister': (context) => const Eregister(),
                '/elearning': (context) => const Elearning(),
                '/pastpapers': (context) => const PastPapers(),
                '/news': (context) => const News(),
                '/calender': (context) => const Calender(),
                '/downloads': (context) => const Downloads(),
                '/settings': (context) => const Settings(),
                '/eduroam': (context) => const Eduroam(),
                '/checkEmail': (context) => const CheckEmail(),
                '/setup': (context) => const SetupScreen(),
                '/migrateToFlutter': (context) => const MigrateToFlutter(),
                '/notifications': (context) => const NotificationData()
              },
              home: FutureBuilder(
                  future: _checkForUpdate(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (_updateInfo?.updateAvailability ==
                          UpdateAvailability.updateAvailable) {
                        InAppUpdate.startFlexibleUpdate().catchError((e) {
                          log(e.toString());
                        });
                      }
                    }
                    return AnnotatedRegion<SystemUiOverlayStyle>(
                      value: Styles.value(themeProvider),
                      child: StreamBuilder<User?>(
                          stream: Auth.instance.authStateChange(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return FutureBuilder(
                                  future: helper.rootFirebaseIsExists(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData &&
                                        snapshot.data == true) {
                                      return FutureBuilder(
                                          future: helper.shouldMigrate(),
                                          builder: (context, shouldMigrate) {
                                            if (shouldMigrate.hasData &&
                                                shouldMigrate.data == true) {
                                              return const MigrateToFlutter();
                                            } else if (shouldMigrate.hasData &&
                                                shouldMigrate.data == false) {
                                              return const DashBoard();
                                            } else {
                                              return scaffoldIndicator();
                                            }
                                          });
                                    } else if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return scaffoldIndicator();
                                    } else {
                                      return const SetupScreen();
                                    }
                                  });
                            } else if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return scaffoldIndicator();
                            } else {
                              return const AuthHome();
                            }
                          }),
                    );
                  }),
            );
          },
        ),
      ),
    );
  }
}
