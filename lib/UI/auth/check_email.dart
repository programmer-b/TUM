part of 'package:tum/UI/auth/auth.dart';

class CheckEmail extends StatefulWidget {
  const CheckEmail({Key? key}) : super(key: key);

  @override
  State<CheckEmail> createState() => _CheckEmailState();
}

class _CheckEmailState extends State<CheckEmail> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10)),
                  child: const IconWidget(
                    icon: FontAwesomeIcons.envelopeOpenText,
                    size: 40,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Txt(
                  text: 'Check your email',
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(
                  height: 25,
                ),
                const Txt(
                  text:
                      'We have sent a password recover instructions to your email.',
                  textAlign: TextAlign.center,
                  fontSize: 19,
                ),
                const SizedBox(
                  height: 50,
                ),
                MyButton(
                  text: 'Open email app',
                  onPressed: () {
                  },
                  width: 200,
                ),
                const SizedBox(
                  height: 15,
                ),
                TxtButton(
                  text: 'Skip, I\'ll confirm later.',
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: SizedBox(
          height: MediaQuery.of(context).size.height * 0.18,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Txt(
                text: 'Did not receive email? Check your spam ',
                fontSize: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Txt(text: 'filter, or'),
                  TextButton(
                    child: Txt(
                      text: 'try another email address',
                      color: themeProvider.isDarkMode
                          ? Colors.white70
                          : Colorz.primaryGreen,
                    ),
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, '/forgotPassword');
                    },
                  ),
                ],
              )
            ],
          ),
        ));
  }

}
