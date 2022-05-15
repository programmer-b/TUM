part of 'package:tum/tum.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> registerForm = GlobalKey<FormState>();

  bool hidePassword = true;

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
                //const BackButton(),
                const Logo(),
                Dimens.titleBodyGap(),
                _registerForm()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _registerForm() {
    return Form(
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
          const MyTextField(
              label: 'Your email address',
              hint: 'Email address',
              prefixIcon: Icons.alternate_email),
          Dimens.textFieldGap(),
          MyTextField(
            obscureText: hidePassword,
            autoCorrect: false,
            isPassword: hidePassword,
            label: 'Password',
            hint: 'Password',
            prefixIcon: Icons.lock,
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  hidePassword = !hidePassword;
                });
              },
              icon: Icon(
                hidePassword ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
              ),
            ),
          ),
          Dimens.textFieldGap(),
          MyTextField(
            obscureText: hidePassword,
            autoCorrect: false,
            isPassword: hidePassword,
            label: 'Confirm password',
            hint: 'Confirm password',
            prefixIcon: Icons.lock,
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  hidePassword = !hidePassword;
                });
              },
              icon: Icon(
                hidePassword ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
              ),
            ),
          ),
          Dimens.textFieldButtonGap(),
          MyButton(
              text: 'Continue',
              onPressed: null,
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
    );
  }
}
