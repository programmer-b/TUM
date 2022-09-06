part of 'package:tum/UI/home/home.dart';

class ReportBug extends StatefulWidget {
  const ReportBug({Key? key}) : super(key: key);

  @override
  State<ReportBug> createState() => _ReportBugState();
}

class _ReportBugState extends State<ReportBug> {
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
    return Scaffold(
        bottomNavigationBar: _bannerAd == null
            ? null
            : Container(
                margin: const EdgeInsets.only(bottom: 12),
                height: 52,
                child: AdWidget(ad: _bannerAd!)),
        appBar: AppBar(title: const Txt(text: 'Report Bug')),
        body: Column(
          children: [
            AppTextField(
              textFieldType: TextFieldType.MULTILINE,
              textStyle: TextStyle(
                  color: themeProvider.isDarkMode ? Colors.white : null),
              decoration: const InputDecoration(
                  hintText: 'Write your bug report here',
                  label: Txt(text: 'Bug Report')),
            ),
            20.height,
            MyButton(
              text: 'Send Bug Report',
              onPressed: () {
                finish(context);
                toast('Your bug report has been sent');
              },
            )
          ],
        ).paddingAll(16));
  }
}
