part of 'package:tum/UI/home/home.dart';

class ElearningSettings extends StatefulWidget {
  const ElearningSettings({Key? key}) : super(key: key);

  @override
  State<ElearningSettings> createState() => _ElearningSettingsState();
}

class _ElearningSettingsState extends State<ElearningSettings> {
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
    final provider = Provider.of<FirebaseHelper>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    String? databaseValue(String path) {
      return provider.home!.snapshot.child(path).value.toString();
    }

    final username =
        TextEditingController(text: databaseValue('elearning/username'));
    final password =
        TextEditingController(text: databaseValue('elearning/password'));

    return Scaffold(
      bottomNavigationBar: _bannerAd == null
          ? null
          : Container(
              margin: const EdgeInsets.only(bottom: 12),
              height: 52,
              child: AdWidget(ad: _bannerAd!)),
      appBar: AppBar(title: const Txt(text: 'Elearning Settings')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            buildAutologin('elearning', provider),
            20.height,
            AppTextField(
              controller: username,
              textFieldType: TextFieldType.EMAIL,
              textStyle: TextStyle(
                  color: themeProvider.isPreDarkMode ? Colors.white : null),
              decoration: InputDecoration(
                label: const Txt(text: 'username'),
                labelStyle: secondaryTextStyle(
                  weight: FontWeight.w600,
                ),
              ),
            ).paddingSymmetric(horizontal: 16),
            16.height,
            AppTextField(
              controller: password,
              textFieldType: TextFieldType.PASSWORD,
              textStyle: TextStyle(
                  color: themeProvider.isPreDarkMode ? Colors.white : null),
              // suffixIconColor: svGetBodyColor(),
              suffixPasswordInvisibleWidget: const Txt(
                text: 'Show',
              ).paddingOnly(top: 20),
              suffixPasswordVisibleWidget: const Txt(
                text: 'Hide',
              ).paddingOnly(top: 20),
              decoration: InputDecoration(
                label: const Txt(text: 'Password'),
                contentPadding: const EdgeInsets.all(0),
                labelStyle: secondaryTextStyle(
                  weight: FontWeight.w600,
                ),
              ),
            ).paddingSymmetric(horizontal: 16),
            32.height,
            MyButton(
              text: 'Update',
              onPressed: () async {
                provider.init();
                await provider.update({
                  'elearning/username': username.text,
                  'elearning/password': password.text,
                  'elearning/access/opened': true,
                });

                if (provider.success) {
                  if (mounted) {
                    finish(context);
                    toast('Elearning settings updated successfully');
                  }
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
