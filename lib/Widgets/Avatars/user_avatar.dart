part of 'package:tum/Widgets/widgets.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FirebaseApi>(context);
    if (provider.fileDownloaded) return _imageBuilder(provider);
    return _imageBuilder(provider);
  }

  Widget _avatar({
    ImageProvider<Object>? backgroundImage =
        const AssetImage(Assets.defaultAvatar),
  }) {
    return CircleAvatar(
      radius: 37,
      child: CircleAvatar(
        radius: 37,
        backgroundImage: backgroundImage,
      ),
    );
  }

  Widget _imageBuilder(FirebaseApi provider) {
    return FutureBuilder(
      future: counterStorage.localPath(),
      builder: (BuildContext _, AsyncSnapshot<String> path) {
        debugPrint('path: ${path.data}');
        if (path.connectionState == ConnectionState.done) {
          return FutureBuilder(
              future: counterStorage.directoryExists('${userId()}.jpg'),
              builder: (BuildContext _, AsyncSnapshot<bool> exists) {
                debugPrint('Exists: ${exists.data}');
                if (exists.connectionState == ConnectionState.done) {
                  if (exists.data!) {
                    return _avatar(
                      backgroundImage: Image.file(
                        File(path.data! + '/${userId()}.jpg'),
                      ).image,
                    );
                  } else {
                    debugPrint('File not found  :: Initializing download');
                    provider.downloadFile(
                        storageRef.child('profileImages/${userId()}.jpg'),
                        '${userId()}.jpg');
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
  }
}
