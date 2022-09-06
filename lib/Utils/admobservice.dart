part of 'package:tum/Utils/utils.dart';

class AdMobService {
   static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-5988017258715205/7961827170';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-5988017258715205/3033181543';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/3964253750';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/8673189370';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/7552160883';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static final BannerAdListener bannerListener = BannerAdListener(
    onAdLoaded: (ad) => log('Ad loaded'),
    onAdFailedToLoad: (ad,error) => log('Ad failed to load $error'),
    onAdOpened: (ad) => log('Ad opened'),
    onAdClosed: (ad) => log('Ad closed'),
  );
}
