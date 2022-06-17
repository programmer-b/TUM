part of 'package:tum/Widgets/widgets.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FirebaseHelper>(context);
    return CachedNetworkImage(imageUrl: '');
  }
}