part of 'package:tum/UI/auth/auth.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> forgotPasswordForm = GlobalKey<FormState>();
  bool hidePassword = true;
  TextEditingController email = TextEditingController();
  bool validEmail = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 40, left: 15, right: 15, bottom: 20),
          child: Center(
            child: Column(
              children: [
                const AuthHeader(),
                Dimens.titleBodyGap(),
                _loginForm()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginForm() {
    return Consumer<FirebaseAuthProvider>(
      builder: (context, provider, child) {
        return Form(
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
                    'Don\'t worry! It happens. Please enter the\naddress associated with that account',
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
                  onPressed: () {},
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
        );
      },
    );
  }
}
