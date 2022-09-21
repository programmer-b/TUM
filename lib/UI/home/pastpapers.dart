// ignore_for_file: unused_field

part of 'package:tum/UI/home/home.dart';

class PastPapers extends StatefulWidget {
  const PastPapers({Key? key}) : super(key: key);

  @override
  State<PastPapers> createState() => _PastPapersState();
}

class _PastPapersState extends State<PastPapers> {
  late String url;
  String _rootData(path) {
    return context
        .read<FirebaseHelper>()
        .root!
        .snapshot
        .child('$path')
        .value
        .toString();
  }

  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;

  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: AdMobService.interstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) => _interstitialAd = ad,
          onAdFailedToLoad: (LoadAdError error) => _interstitialAd = null,
        ));
  }

  void _showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback =
          FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _createInterstitialAd();
      }, onAdFailedToShowFullScreenContent: (ad, error) {
        log('$error');
        ad.dispose();
        _createInterstitialAd();
      });
      _interstitialAd!.show();
      _interstitialAd = null;
    }
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
  void initState() {
    super.initState();
    _createBannerAd();
    _createInterstitialAd();
    url = _rootData('PastPapers/initialUrl');

    init();
  }

  Future init() async {
    await 120.seconds.delay;

    _showInterstitialAd();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await pushPage(context, const DashBoard());
      },
      child: Scaffold(
        bottomNavigationBar: null,
        appBar: browserAppBar(context, "Past papers"),
        drawer: const MyDrawer(),
        body: TUMBrowser(url: url, title: "Past papers"),
      ),
    );
  }
}
