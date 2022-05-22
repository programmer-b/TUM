part of 'package:tum/UI/auth/auth.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> forgotPasswordForm = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
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
                      key: forgotPasswordForm,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Txt(
                            text: 'Forgot\nPassword?',
                            upperCaseFirst: true,
                            fontSize: 38,
                            fontWeight: FontWeight.bold,
                          ),
                          Dimens.textToTextGap(),
                          const Txt(
                            text:
                                'Enter the email associated with your account and we\'ll send an email with instructions to reset your password',
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
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
                          const SizedBox(
                            height: 10,
                          ),
                          MyButton(
                              text: 'Submit',
                              onPressed: validEmail
                                  ? () async {
                                      dialog.progress(context, 'Submitting',
                                          'please wait ...');

                                      provider.init();
                                      await provider
                                          .resetPassword(email.text.trim());
                                      Navigator.pop(context);
                                      if (forgotPasswordForm.currentState!
                                          .validate()) {
                                        if (provider.success) {
                                          Navigator.pushNamed(context, '/login');
                                          ArtSweetAlert.show(
                                              context: context,
                                              artDialogArgs: ArtDialogArgs(
                                                type: ArtSweetAlertType.success,
                                                title:
                                                "A password reset email has been sent to ${email.text}",
                                              ));
                                        }
                                      }
                                      if (provider.catchError) {
                                        ArtSweetAlert.show(
                                            context: context,
                                            artDialogArgs: ArtDialogArgs(
                                              type: ArtSweetAlertType.danger,
                                              title: provider.errorMessage,
                                            ));
                                      }
                                    }
                                  : null,
                              textUpperCase: true,
                              width: MediaQuery.of(context).size.width),
                          Dimens.buttonButtonGap(),
                          TxtButton(
                            text: 'Back to Login',
                            alignment: Alignment.center,
                            onPressed: () {
                              Navigator.pushNamed(context, '/login');
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
