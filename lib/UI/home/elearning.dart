// ignore_for_file: unused_field

part of 'package:tum/UI/home/home.dart';

class Elearning extends StatefulWidget {
  const Elearning({Key? key}) : super(key: key);

  @override
  State<Elearning> createState() => _ElearningState();
}

class _ElearningState extends State<Elearning> {
  late String url;
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    _createBannerAd();

    url = _rootData('Portals/elearning/initialUrl');
    log(url);

    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  void _createBannerAd() {
    _bannerAd = BannerAd(
        size: AdSize.fullBanner,
        adUnitId: AdMobService.bannerAdUnitId,
        listener: AdMobService.bannerListener,
        request: const AdRequest())
      ..load();
  }

  String _homeData(path) {
    return context
        .read<FirebaseHelper>()
        .home!
        .snapshot
        .child('$path')
        .value
        .toString();
  }

  String _rootData(path) {
    return context
        .read<FirebaseHelper>()
        .root!
        .snapshot
        .child('$path')
        .value
        .toString();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TUMState>(context);

    final registrationNumber = _homeData('profile/registrationNumber');
    final email = _rootData("Portals/elearning/email");
    final password = _rootData("Portals/elearning/password");
    final submit = _rootData("Portals/elearning/submit");
    final studentUsername = _homeData("elearning/username");
    final studentPassword = _homeData("elearning/password");

    //log("registrationNumber: $registrationNumber \n email: $email\n password: $password \n submit: $submit\n studentUsername: $studentUsername \n studentPassword: $studentPassword\n");

    InAppWebViewController? controller;
    if (!provider.browserIsLoading &&
        provider.webViewController != null &&
        _homeData('elearning/access/skipped') != 'true') {
      //log('evaluateJavascript ...');
      controller = provider.webViewController!;

      Future.delayed(const Duration(seconds: 1), () {
        provider.webViewController!.evaluateJavascript(source: '''
                             var email = $email;
                             var password = $password;
                             email.value = "$studentUsername";
                             password.value = "$studentPassword";
                             $submit;
                           ''');
      });
    }
    if (_homeData('elearning/access/opened') != 'true') {
      return PortalWelcomeScreen(
        password: registrationNumber.toLowerCase().replaceAll('/', ''),
        username: registrationNumber.toLowerCase().replaceAll('/', ''),
        title: 'elearning',
      );
    } else {
      return WillPopScope(
        onWillPop: () async {
          if (await controller!.canGoBack()) {
            await provider.webViewController!.goBack();
            return false;
          } else {
            return await pushPage(context, const DashBoard());
          }
        },
        child: Scaffold(
          bottomNavigationBar: null,
          appBar: browserAppBar(context, "Elearning"),
          drawer: const MyDrawer(),
          body: TUMBrowser(url: url, title: "Elearning"),
        ),
      );
    }
  }
}
