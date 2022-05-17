part of 'package:tum/tum.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> loginForm = GlobalKey<FormState>();
  bool hidePassword = true;
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  bool validPassword = false;
  bool validEmail = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<FirebaseAuthProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 40, left: 15, right: 15, bottom: 20),
              child: Center(
                child: Column(
                  children: [
                    const Logo(),
                    Dimens.titleBodyGap(),
                    Form(
                      key: loginForm,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Txt(
                            text: 'login',
                            upperCaseFirst: true,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                          Dimens.titleTextFieldGap(),
                          formField.emailField(
                            email,
                            provider,
                            onChanged: (value) {
                              if (value.length > 2) {
                                setState(() {
                                  validEmail = true;
                                });
                              }
                            },
                          ),
                          Dimens.textFieldGap(),
                          formField.passwordField(
                              context, password, provider, hidePassword,
                              onChanged: (value) {
                            if (value.length > 2) {
                              setState(() {
                                validPassword = true;
                              });
                            }
                          },
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    hidePassword = !hidePassword;
                                  });
                                },
                                icon: Icon(
                                  hidePassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                              )),
                          const SizedBox(
                            height: 10,
                          ),
                          TxtButton(
                            text: 'Forgot Password?',
                            alignment: Alignment.topRight,
                            onPressed: () {
                              Navigator.pushNamed(context, '/forgotPassword');
                            },
                          ),
                          Dimens.buttonButtonGap(),
                          _loginButton(email.text, password.text, provider),
                          Dimens.buttonButtonGap(),
                          TxtButton(
                            text: 'New student? Register',
                            alignment: Alignment.center,
                            onPressed: () {
                              Navigator.pushNamed(context, '/register');
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  _loginButton(String email, String password, FirebaseAuthProvider provider) {
    return MyButton(
        text: 'Continue',
        onPressed: validEmail && validPassword
            ? () async {
                FocusScope.of(context).unfocus();
                dialog.progress(context, 'Authenticating', 'Please wait ...');
                debugPrint("email:$email password:$password");
                provider.init();
                await provider.login(email, password);
                if(loginForm.currentState!.validate()){
                  if (provider.success) {
                    debugPrint('Hello');
                    Future.delayed(Duration.zero, () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                              const DashBoard(
                                  title: 'TUM demo')));
                    });
                  }
                }
                Navigator.of(context).pop();
              }
            : null,
        textUpperCase: true,
        width: MediaQuery.of(context).size.width);
  }
}
