part of 'package:tum/Widgets/widgets.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({Key? key, this.radius = 30}) : super(key: key);

  final double radius;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FirebaseApi>(context);
    if (provider.fileDownloaded) return _imageBuilder(context, provider);
    return _imageBuilder(context, provider);
  }

  Widget _avatar({
    ImageProvider<Object>? backgroundImage =
        const AssetImage(Assets.defaultAvatar),
  }) {
    return CircleAvatar(
      radius: radius,
      child: CircleAvatar(
        radius: radius,
        backgroundImage: backgroundImage,
      ),
    );
  }

  Widget _imageBuilder(context, FirebaseApi provider) {
    final myProvider = Provider.of<FirebaseHelper>(context);

    String? value(String path) {
      return myProvider.home!.snapshot.child(path).value.toString();
    }

    final url = value('profile/profileImage/url');
    final timeStamp = value('profile/profileImage/timeStamp');
    if (url != "") {
      log('url for image is not null :$url');
      return FutureBuilder(
        future: counterStorage.localPath(),
        builder: (BuildContext _, AsyncSnapshot<String> path) {
          debugPrint('path: ${path.data}');
          if (path.connectionState == ConnectionState.done) {
            return FutureBuilder<bool>(
                future: counterStorage.directoryExists('$timeStamp.jpg'),
                builder: (BuildContext _, AsyncSnapshot<bool> exists) {
                  debugPrint('Exists: ${exists.data}');
                  if (exists.connectionState == ConnectionState.done) {
                    if (exists.data!) {
                      return _avatar(
                        backgroundImage: Image.file(
                          File('${path.data!}/$timeStamp.jpg'),
                        ).image,
                      );
                    } else {
                      debugPrint('File not found  :: Initializing download');
                      provider.downloadFile(
                          storageRef.child('profileImages/${userId()}.jpg'),
                          '$timeStamp.jpg');
                      return _avatar();
                    }
                  } else {
                    return _avatar();
                  }
                });
          }
          return _avatar();
        },
      );
    } else {
      return _avatar();
    }
  }
}
