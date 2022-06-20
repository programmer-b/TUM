part of 'package:tum/UI/setup/setup.dart';

class MigrateToFlutter extends StatefulWidget {
  const MigrateToFlutter({Key? key}) : super(key: key);

  @override
  State<MigrateToFlutter> createState() => _MigrateToFlutterState();
}

class _MigrateToFlutterState extends State<MigrateToFlutter> {
  Map<String, dynamic> oldData = {};
  DatabaseReference ref = FirebaseDatabase.instance.ref();
  final refPath = '/Users/Students/${userId()}';

  Future<OldData> migrateToFlutter() async {
    final snapshot = await ref.child(refPath).get();
    return OldData.fromJson(json.decode(snapshot.value.toString()));
  }

  Future<bool> migrateData(AsyncSnapshot<OldData> oldData) async {
    Map<String, Object?> newData = {};

    newData['/profile/fullName'] = oldData.data!.fullName;
    newData['/profile/phoneNo'] = oldData.data!.phoneNo;
    newData['/profile/images/profileImage'] = oldData.data!.profileImage;
    newData['/elearning/password'] = oldData.data!.elearningPassword;
    newData['/elearning/username'] = '';
    newData['/eregister/password'] = oldData.data!.eregisterPassword;
    newData['/eregister/username'] = '';
    newData['/settings/themeMode'] = 'light';

    try {
      await ref.child(refPath).set(newData);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> shouldMigrate() async {
    final snapshot = await ref.child(refPath).get();
    return snapshot.hasChild('fullName');
  }

  void _goToDashboard(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
        context, '/dashboard', ModalRoute.withName('/'));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: shouldMigrate(),
        builder: (BuildContext _, AsyncSnapshot<bool> shouldMigrate) {
          if (shouldMigrate.connectionState == ConnectionState.done &&
              shouldMigrate.hasData) {
            if (shouldMigrate.data!) {
              return FutureBuilder<OldData>(
                  future: migrateToFlutter(),
                  builder: (BuildContext _, AsyncSnapshot<OldData> oldData) {
                    if (oldData.connectionState == ConnectionState.done &&
                        oldData.hasData) {
                      return FutureBuilder(
                        future: migrateData(oldData),
                        builder:
                            (BuildContext _, AsyncSnapshot<bool> dataMigrated) {
                          if (dataMigrated.connectionState ==
                                  ConnectionState.done &&
                              dataMigrated.hasData) {
                            if (dataMigrated.data!) {
                              _goToDashboard(context);
                            } else {
                              return Scaffold(
                                body: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Txt(
                                      text: 'Oops! Something went wrong',
                                    ),
                                    SizedBox(height: Dimens.defaultPadding * 2),
                                    MyButton(
                                      text: 'Retry',
                                      width: 150,
                                      onPressed: () => initState(),
                                    )
                                  ],
                                ),
                              );
                            }
                          }
                          return scaffoldIndicator();
                        },
                      );
                    }
                    return scaffoldIndicator();
                  });
            } else {
              _goToDashboard(context);
            }
          }
          return scaffoldIndicator();
        });
  }
}
