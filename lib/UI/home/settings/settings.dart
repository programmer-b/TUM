part of 'package:tum/UI/home/home.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    _createBannerAd();
  }

  void _createBannerAd() {
    _bannerAd = BannerAd(
        size: AdSize.fullBanner,
        adUnitId: AdMobService.bannerAdUnitId,
        listener: AdMobService.bannerListener,
        request: const AdRequest())
      ..load();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final databaseTheme = Provider.of<FirebaseHelper>(context);
    final provider = Provider.of<FirebaseHelper>(context);

    String? value(String path) {
      return provider.home!.snapshot.child(path).value.toString();
    }

    Widget buildDarkMode() => ListTile(
        onTap: () {},
        trailing: Switch(
            value: themeProvider.isDarkMode,
            onChanged: (_) {
              if (themeProvider.isDarkMode) {
                databaseTheme.update({"settings/theme": "light"});
              } else {
                databaseTheme.update({"settings/theme": "dark"});
              }
            }),
        title: const Txt(text: 'Dark Mode'),
        leading: const ApplicationIconWidget(
            color: Colors.blue, icon: Icons.dark_mode));

    Widget buildNotification() => ListTile(
        onTap: () {},
        trailing: Switch(
            value: value("notifications/enabled") == "true",
            onChanged: (value) {
              if (value) {
                provider.update({"notifications/enabled": value});
              } else {
                provider.update({"notifications/enabled": value});
              }
            }),
        title: const Txt(text: 'Enable notifications'),
        leading: const ApplicationIconWidget(
            color: Color.fromARGB(255, 175, 90, 19),
            icon: Icons.notifications));

    Widget buildEregister() {
      return ListTile(
        title: const Txt(text: 'Eregister'),
        //subtitle: const Txt(text: 'Change username, password, auto login'),
        trailing: const Icon(Icons.chevron_right),
        leading: const ApplicationIconWidget(
          icon: Icons.school_rounded,
          color: Colors.blueGrey,
        ),
        onTap: () => const EregisterSettings()
            .launch(context, pageRouteAnimation: PageRouteAnimation.Scale),
      );
    }

    Widget buildElearning() {
      return ListTile(
        title: const Txt(text: 'Elearning'),
        //subtitle: const Txt(text: 'Change username, password, auto login'),
        trailing: const Icon(Icons.chevron_right),
        leading: const ApplicationIconWidget(
          icon: Icons.laptop_chromebook,
          color: Colorz.primaryGreen,
        ),
        onTap: () => const ElearningSettings()
            .launch(context, pageRouteAnimation: PageRouteAnimation.Scale),
      );
    }

    Widget buildProfile() {
      return ListTile(
        title: const Txt(text: 'Account Settings'),
        subtitle: const Txt(text: 'Change password, Name , etc'),
        trailing: const Icon(Icons.chevron_right),
        leading: const ApplicationIconWidget(
          icon: Icons.person,
          color: Colors.green,
        ),
        onTap: () => const AccountSettings()
            .launch(context, pageRouteAnimation: PageRouteAnimation.Scale),
      );
    }

    Widget buildLogout() {
      return ListTile(
          title: const Txt(text: 'Logout'),
          leading: const ApplicationIconWidget(
            icon: Icons.logout,
            color: Colors.blueAccent,
          ),
          onTap: () async {
            await PageDialog.yesOrNoDialog(
                context, 'Logout', 'Do you wish to logout this account?',
                onPressed: () async {
              if (!mounted) return;
              Navigator.pop(context);

              toast('Logged out successfully');

              await context.read<FirebaseAuthProvider>().logOut();
              if (!mounted) return;
              Phoenix.rebirth(context);
            });
          });
    }

    Widget buildDeleteAccount() {
      return ListTile(
        title: const Txt(text: 'Delete Account'),
        // subtitle: '',
        leading: const ApplicationIconWidget(
          icon: Icons.delete,
          color: Colors.pink,
        ),
        onTap: () async {
          toast('Not currently supported');
          // await PageDialog.yesOrNoDialog(
          //     context, 'Delete Account', 'Do you wish to delete this account?',
          //     onPressed: () async => await user!.delete());
        },
      );
    }

    Widget buildReportBug() {
      return ListTile(
        title: const Txt(text: 'Report A Bug'),
        // subtitle: '',
        leading: const ApplicationIconWidget(
          icon: Icons.bug_report,
          color: Colors.teal,
        ),
        onTap: () => const ReportBug()
            .launch(context, pageRouteAnimation: PageRouteAnimation.Scale),
      );
    }

    Widget buildSendFeedback() {
      return ListTile(
        title: const Txt(text: 'Send Feedback'),
        // subtitle: '',
        leading: const ApplicationIconWidget(
          icon: Icons.feedback,
          color: Colors.purple,
        ),
        onTap: () => const SendFeedback()
            .launch(context, pageRouteAnimation: PageRouteAnimation.Scale),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        return await pushPage(context, const DashBoard());
      },
      child: Scaffold(
        bottomNavigationBar: _bannerAd == null
            ? null
            : Container(
                margin: const EdgeInsets.only(bottom: 12),
                height: 52,
                child: AdWidget(ad: _bannerAd!)),
        appBar: _appBar(context),
        drawer: const MyDrawer(),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              buildDarkMode(),
              SettingsGroup(title: 'GENERAL', children: <Widget>[
                buildProfile(),
                buildNotification(),
                buildLogout(),
                buildDeleteAccount(),
              ]),
              32.height,
              SettingsGroup(
                  title: 'PORTALS',
                  children: <Widget>[buildEregister(), buildElearning()]),
              32.height,
              SettingsGroup(
                  title: 'FEEDBACK',
                  children: <Widget>[buildReportBug(), buildSendFeedback()])
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return appBar(context,
        // actions: [
        //   MyIconButton(
        //     icon: Icons.more_vert,
        //     onPressed: () {},
        //     toolTip: "More options",
        //   )
        // ],
        title: const Txt(text: "Settings"));
  }
}
