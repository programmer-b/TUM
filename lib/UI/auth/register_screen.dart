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
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 40, left: 15, right: 15, bottom: 20),
              child: Center(
                child: Column(
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
                            text: 'Sign up'
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
                              text: 'Continue',
                              onPressed: validEmail &&
                                      validPassword &&
                                      validConfirmPassword
                                  ? () async {
                                      debugPrint("Hello");
                                      FocusScope.of(context).unfocus();
                                      dialog.progress(context, 'Authenticating',
                                          'Please wait ...');
                                      debugPrint(
                                          "email:$email password:$password");
                                      provider.init();
                                      await provider.signUp(
                                          email.text, password.text);
                                      if (registerForm.currentState!
                                          .validate()) {
                                        if (provider.success) {
                                          debugPrint('Hello');
                                          Future.delayed(Duration.zero, () {
                                            Navigator.pushNamedAndRemoveUntil(
                                                context,
                                                '/dashboard',
                                                ModalRoute.withName('/'));
                                          });
                                        }
                                      }
                                      Navigator.of(context).pop();
                                    }
                                  : null,
                              textUpperCase: true,
                              width: MediaQuery.of(context).size.width),
                          Dimens.buttonButtonGap(),
                          TxtButton(
                            text: 'Joined us before? Login',
                            alignment: Alignment.center,
                            onPressed: () {
                              Navigator.of(context).pop();
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
