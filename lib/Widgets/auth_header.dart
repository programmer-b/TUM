part of 'package:tum/Widgets/widgets.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 18),
            child: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              icon: const Icon(FontAwesomeIcons.angleLeft),
              color: Colorz.primaryGreen,
              splashColor: Colors.grey,
            ),
          ),
          const Logo(),
        ],
      ),
    );
  }
}
