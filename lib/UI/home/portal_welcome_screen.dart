part of 'package:tum/UI/home/home.dart';

class PortalWelcomeScreen extends StatefulWidget {
  const PortalWelcomeScreen(
      {Key? key,
      required this.title,
      required this.username,
      required this.password})
      : super(key: key);
  final String title;
  final String username;
  final String password;

  @override
  State<PortalWelcomeScreen> createState() => _PortalWelcomeScreenState();
}

class _PortalWelcomeScreenState extends State<PortalWelcomeScreen> {
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

  bool hidePassword = true;
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FirebaseHelper>(context);
    final myProvider = Provider.of<TUMState>(context);
    // final registrationNumber = provider.home!.snapshot
    //     .child('profile/registrationNumber')
    //     .value
    //     .toString();
    final username = TextEditingController(text: widget.username);
    final password = TextEditingController(text: widget.password);

    void onPressed(Map<String, Object?> map) async {
      provider.init();
      await provider.update(map);
      if (provider.success) {
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/${widget.title}');
      }
      if (provider.error) {
        if (!mounted) return;
        dialog.alert(context, 'Oops... Something went wrong',
            type: ArtSweetAlertType.danger);
      }
    }

    return Scaffold(
        //extendBodyBehindAppBar: true,
        bottomNavigationBar: _bannerAd == null
            ? null
            : Container(
                margin: const EdgeInsets.only(bottom: 12),
                height: 52,
                child: AdWidget(ad: _bannerAd!)),
        appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => myProvider.navidateToScreen(context, '/home', 0),
            ),
            title: Txt(
              text: widget.title,
              upperCaseFirst: true,
            ),
            actions: [
              TextButton(
                  onPressed: () => onPressed({
                        '${widget.title}/access/opened': true,
                        '${widget.title}/access/skipped': true
                      }),
                  child: const Txt(text: "SKIP", color: Colors.white))
            ],
            systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarIconBrightness: Brightness.light)),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ScrollableWidget(
            child: Column(
              children: [
                const Logo(),
                Dimens.titleBodyGap(),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Txt(
                      text: 'welcome, ',
                      upperCaseFirst: true,
                      fontSize: 34,
                    ),
                    const SizedBox(height: 8),
                    Txt(
                      text: '${widget.title} login',
                      upperCaseFirst: true,
                      fontSize: 44,
                    ),
                    const SizedBox(height: 22),
                    MyTextField(
                      controller: username,
                      prefixIcon: Icons.account_circle,
                      label: 'username',
                      hint: 'username',
                    ),
                    const SizedBox(height: 12),
                    MyTextField(
                        obscureText: hidePassword,
                        controller: password,
                        prefixIcon: Icons.lock,
                        label: 'password',
                        hint: 'password',
                        suffixIcon: IconButton(
                          onPressed: () =>
                              setState(() => hidePassword = !hidePassword),
                          icon: Icon(hidePassword
                              ? Icons.visibility
                              : Icons.visibility_off),
                        )),
                    const SizedBox(height: 24),
                    const Txt(
                        text:
                            'Note: You can update your username and password in the app settings.'),
                    const SizedBox(height: 14),
                    MyButton(
                      text: 'Continue',
                      onPressed: () => onPressed({
                        '${widget.title}/username': username.text,
                        '${widget.title}/password': password.text,
                        '${widget.title}/access/opened': true
                      }),
                    ),
                    // const SizedBox(height: 14),
                    // TxtButton(
                    //   text: 'Skip',
                    //   onPressed: () => onPressed({
                    //     '${widget.title}/access/opened': true,
                    //     '${widget.title}/access/skipped': true
                    //   }),
                    // )
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
