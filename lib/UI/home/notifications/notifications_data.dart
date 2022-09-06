part of 'package:tum/UI/home/home.dart';

class NotificationData extends StatefulWidget {
  const NotificationData({Key? key}) : super(key: key);

  @override
  State<NotificationData> createState() => _NotificationDataState();
}

class _NotificationDataState extends State<NotificationData> {
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
    return Scaffold(
      bottomNavigationBar: _bannerAd == null
          ? null
          : Container(
              margin: const EdgeInsets.only(bottom: 12),
              height: 52,
              child: AdWidget(ad: _bannerAd!)),
      appBar: AppBar(title: const Txt(text: "Notifications")),
      drawer: const MyDrawer(),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(
            Icons.notifications_off,
            size: 44,
          ),
          16.height,
          const Txt(text: 'No notifications available')
        ],
      )),
    );
  }
}
