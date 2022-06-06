part of 'package:tum/UI/auth/auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final loginForm = GlobalKey<FormState>();
  bool hidePassword = true;
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  bool validPassword = false;
  bool validEmail = false;

  // ignore: unused_field
  late NavigatorState _navigator;

  @override
  void didChangeDependencies() {
    _navigator = Navigator.of(context);
    super.didChangeDependencies();
  }

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
                          MyButton(
                              text: 'Continue',
                              onPressed: validEmail && validPassword
                                  ? () async {
                                      dialog.progress(context, 'Authenticating',
                                          'Please wait ...');
                                      debugPrint(
                                          "email:$email password:$password");
                                      provider.init();
                                      await provider.login(
                                          email.text, password.text);
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                      loginForm.currentState!.validate();

                                      if (provider.catchError) {
                                        dialog.alert(
                                            context, provider.errorMessage,
                                            type: ArtSweetAlertType.danger);
                                      }
                                    }
                                  : null,
                              textUpperCase: true,
                              width: MediaQuery.of(context).size.width),
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
}
