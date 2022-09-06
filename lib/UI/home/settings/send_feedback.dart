part of 'package:tum/UI/home/home.dart';

class SendFeedback extends StatefulWidget {
  const SendFeedback({Key? key}) : super(key: key);

  @override
  State<SendFeedback> createState() => _SendFeedbackState();
}

class _SendFeedbackState extends State<SendFeedback> {
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
        appBar: AppBar(title: const Txt(text: 'Send feedback')),
        body: Column(
          children: [
            AppTextField(
              textFieldType: TextFieldType.MULTILINE,
              textStyle: TextStyle(
                  color: themeProvider.isDarkMode ? Colors.white : null),
              decoration: const InputDecoration(
                  hintText: 'Write your feedback report here',
                  label: Txt(text: 'Feedback')),
            ),
            20.height,
            MyButton(
              text: 'Send',
              onPressed: () {
                finish(context);
                toast('Your feedback has been sent');
              },
            )
          ],
        ).paddingAll(16));
  }
}
