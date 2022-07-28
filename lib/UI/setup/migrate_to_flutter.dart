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

  Future<DataSnapshot> migrateToFlutter() async {
    final snapshot = await ref.child(refPath).get();
    return snapshot;
  }

  Future migrateData(FirebaseHelper provider) async {
    provider.init();
    final snapshot = await ref.child(refPath).get();

    Map<String, Object?> _map = {
      "profile": {
        "fullName": snapshot.child("fullName").value,
        "registrationNumber": snapshot.child("regNo").value,
        "phoneNumber": snapshot.child("phoneNo").value,
        "profileImage": {
          "url": snapshot.child("profileImage").value,
          "timeStamp": DateTime.now().millisecondsSinceEpoch,
          "name": "${userId()}.jpg",
        }
      },
      "elearning": {
        "username": "",
        "password": snapshot.child("elearningPassword").value,
        "access": {"opened": false, "skipped": false}
      },
      "eregister": {
        "username": "",
        "password": snapshot.child("eregisterPassword").value,
        "access": {"opened": false, "skipped": false}
      },
      "settings": {"notification": true, "language": "en", "theme": "system"}
    };
    log(jsonEncode(_map));

    await provider.write(_map);

    if (provider.success) {
      _goToDashboard(context);
    }
  }

  void _goToDashboard(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
        context, '/dashboard', ModalRoute.withName('/'));
  }

  void _restart(FirebaseHelper provider) {
    migrateData(provider);
  }

  @override
  void initState() {
    _restart(context.read<FirebaseHelper>());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log('Migrating to flutter: ');
    final provider = Provider.of<FirebaseHelper>(context);
    return provider.error
        ? ErrorRetry(
            onPressed: () => _restart(provider),
          )
        : Scaffold(
            appBar: appBar(context),
            body: const Center(child: MyProgressIndicator()));
  }
}
