// ignore_for_file: unused_field

part of 'package:tum/UI/home/home.dart';

class Eregister extends StatefulWidget {
  const Eregister({Key? key}) : super(key: key);

  @override
  State<Eregister> createState() => _EregisterState();
}

class _EregisterState extends State<Eregister> {
  late String url;

  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    url = _rootData('Portals/eregister/initialUrl');
    _createBannerAd();
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
    final email = _rootData("Portals/eregister/email");
    final password = _rootData("Portals/eregister/password");
    final submit = _rootData("Portals/eregister/submit");
    final studentUsername = _homeData("eregister/username");
    final studentPassword = _homeData("eregister/password");

    if (_homeData('eregister/access/opened') != 'true') {
      Future.delayed(
          Duration.zero,
          () => Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => PortalWelcomeScreen(
                    password: registrationNumber.toUpperCase(),
                    username: registrationNumber.toUpperCase(),
                    title: 'eregister',
                  ))));
    }
    InAppWebViewController? controller;
    if (!provider.browserIsLoading &&
        provider.webViewController != null &&
        _homeData('eregister/access/skipped') != 'true') {
      controller = provider.webViewController!;
      log('evaluateJavascript ...');
      Future.delayed(const Duration(seconds: 3), () {
        provider.webViewController!.evaluateJavascript(source: """
                    var email = $email;
                    var password = $password;
                    email.value = "$studentUsername";
                    password.value = "$studentPassword";
                    $submit;            
                  """);
      });
    }

    if (_homeData('eregister/access/opened') != 'true') {
      // Future.delayed(
      //     Duration.zero,
      //     () => Navigator.of(context).pushReplacement(MaterialPageRoute(
      //         builder: (context) => PortalWelcomeScreen(
      //               password: registrationNumber.toUpperCase(),
      //               username: registrationNumber.toUpperCase(),
      //               title: 'eregister',
      //             ))));

      return PortalWelcomeScreen(
        password: registrationNumber.toUpperCase(),
        username: registrationNumber.toUpperCase(),
        title: 'eregister',
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
          appBar: browserAppBar(context, "Eregister"),
          drawer: const MyDrawer(),
          body: TUMBrowser(url: url, title: "Eregister"),
        ),
      );
    }
  }
}
