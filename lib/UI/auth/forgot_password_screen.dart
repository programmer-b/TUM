part of 'package:tum/UI/auth/auth.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  bool validEmail = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<FirebaseAuthProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          body: Padding(
            padding:  const EdgeInsets.only(
                    top: 40, left: 15, right: 15, bottom: 20),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Logo(),
                    Dimens.titleBodyGap(),
                    Form(
                      key: formKey,
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
                                     

                                      provider.init();
                                      await provider
                                          .resetPassword(email.text.trim());
                                      if (formKey.currentState!.validate()) {
                                        if (provider.success) {
                                          if (!mounted) return;
                                          Navigator.pushReplacementNamed(
                                              context, '/login');
                                          dialog.alert(context,
                                              "A password reset email has been sent to ${email.text}",
                                              type: ArtSweetAlertType.success);
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
                              textUpperCase: true,
                              width: MediaQuery.of(context).size.width),
                          Dimens.buttonButtonGap(),
                          TxtButton(
                            text: 'Back to Login',
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
