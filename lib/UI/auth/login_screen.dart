part of 'package:tum/tum.dart';



class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> loginForm = GlobalKey<FormState>();
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
                const Logo(),
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
    return Form(
      key: loginForm,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Txt(text: 'login', upperCaseFirst: true,fontSize: 38, fontWeight: FontWeight.bold,),
          Dimens.titleTextFieldGap(),
          const MyTextField(
              label: 'Student\'s email address',
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
          Dimens.textFieldButtonGap(),
          TxtButton(text: 'forgot password?', alignment: Alignment.topRight, onPressed: (){},),
          Dimens.buttonButtonGap(),
          MyButton(text: 'continue', onPressed: null, textUpperCase: true, width: MediaQuery.of(context).size.width),
          Dimens.buttonButtonGap(),
          TxtButton(text: 'new student? register', alignment: Alignment.center, onPressed: (){Navigator.pushNamed(context, '/register');},),
        ],
      ),
    );
  }
}
