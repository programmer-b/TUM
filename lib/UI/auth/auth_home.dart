part of 'package:tum/UI/auth/auth.dart';

class AuthHome extends StatefulWidget {
  const AuthHome({
    Key? key,
  }) : super(key: key);

  @override
  State<AuthHome> createState() => _AuthHomeState();
}

class _AuthHomeState extends State<AuthHome> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage(Assets.authHomeBg), fit: BoxFit.none),
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            systemOverlayStyle: const SystemUiOverlayStyle(
                systemNavigationBarColor: Colorz.primaryGreen,
                statusBarIconBrightness: Brightness.light)),
        backgroundColor: Colorz.loginBg,
        body: Container(
          margin: const EdgeInsets.symmetric(vertical: 60, horizontal: 15),
          height: double.infinity,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Txt(
                text:
                    'Welcome to the Technical University of Mombasa mobile platform.',
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 26,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MyButton(
                    text: 'login',
                    width: double.infinity,
                    onPressed: () => const LoginScreen().launch(context,
                        pageRouteAnimation: PageRouteAnimation.Scale),
                    primaryColor: Colors.white,
                    textColor: Colors.black,
                    textUpperCase: true,
                  ),
                  const SizedBox(height: 8),
                  const Txt(
                    text: "Or new to this app?",
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  MyButton(
                    text: 'register',
                    width: double.infinity,
                    onPressed: () => const RegisterScreen().launch(context,
                        pageRouteAnimation: PageRouteAnimation.Scale),
                    primaryColor: Colors.white,
                    textColor: Colors.black,
                    textUpperCase: true,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
