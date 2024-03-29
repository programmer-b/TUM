part of 'package:tum/UI/auth/auth.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> registerForm = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  bool hidePassword = true;
  bool hideConfirmPassword = true;
  bool validPassword = false;
  bool validConfirmPassword = false;
  bool validEmail = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<FirebaseAuthProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: appBar(context),
          extendBodyBehindAppBar: true,
          body: Padding(
            padding:
                const EdgeInsets.only(top: 40, left: 15, right: 15, bottom: 20),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //const BackButton(),
                    const Logo(),
                    Dimens.titleBodyGap(),
                    Form(
                      key: registerForm,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Txt(
                            text: 'Register'
                                '',
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
                          Dimens.textFieldGap(),
                          formField.passwordField(
                              context,
                              confirmPassword,
                              provider,
                              hideConfirmPassword, onChanged: (value) {
                            if (value.length > 2) {
                              setState(() {
                                validConfirmPassword = true;
                              });
                            }
                          },
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    hideConfirmPassword = !hideConfirmPassword;
                                  });
                                },
                                icon: Icon(
                                  hideConfirmPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                              ),
                              confirmPassword: password.text,
                              confirm: true),
                          Dimens.textFieldButtonGap(),
                          MyButton(
                            text: 'Register',
                            onPressed: validEmail &&
                                    validPassword &&
                                    validConfirmPassword
                                ? () async {
                                    debugPrint(
                                        "email:$email password:$password");
                                    provider.init();

                                    await provider.signUp(email.text.trim(),
                                        password.text.trim());

                                    if (registerForm.currentState!.validate()) {
                                      if (provider.success) {
                                        if (!mounted) return;
                                        debugPrint('success registration');
                                        Navigator.of(context)
                                            .pushNamedAndRemoveUntil(
                                                '/setup',
                                                (Route<dynamic> route) =>
                                                    false);
                                      }
                                    }
                                    if (provider.catchError) {
                                      if (!mounted) return;
                                      dialog.alert(
                                          context, provider.errorMessage,
                                          type: ArtSweetAlertType.danger);
                                    }
                                  }
                                : null,
                            width: MediaQuery.of(context).size.width,
                          ),
                          Dimens.buttonButtonGap(),
                          TxtButton(
                            text: 'Joined us before? Login',
                            alignment: Alignment.center,
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, '/login');
                            },
                          ),
                        ],
                      ),
                    ),
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
