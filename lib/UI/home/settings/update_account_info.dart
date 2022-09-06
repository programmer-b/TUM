part of 'package:tum/UI/home/home.dart';

class UpdateAccountInfo extends StatefulWidget {
  const UpdateAccountInfo(
      {Key? key,
      required this.title,
      this.controller1,
      this.controller2,
      this.changePassword = false,
      required this.textFieldType,
      this.onPressed,
      this.text})
      : super(key: key);

  final String title;
  final TextEditingController? controller1;
  final TextEditingController? controller2;
  final bool changePassword;
  final TextFieldType textFieldType;
  final dynamic Function()? onPressed;
  final dynamic text;

  @override
  State<UpdateAccountInfo> createState() => _UpdateAccountInfoState();
}

class _UpdateAccountInfoState extends State<UpdateAccountInfo> {
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
        appBar: AppBar(title: Txt(text: widget.title)),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              AppTextField(
                controller: widget.controller1,
                textFieldType: widget.textFieldType,
                suffixPasswordInvisibleWidget: widget.changePassword
                    ? const Txt(
                        text: 'Show',
                      ).paddingOnly(top: 20)
                    : null,
                suffixPasswordVisibleWidget: widget.changePassword
                    ? const Txt(
                        text: 'Hide',
                      ).paddingOnly(top: 20)
                    : null,
                textStyle: TextStyle(
                    color: themeProvider.isPreDarkMode ? Colors.white : null),
                decoration: InputDecoration(
                  label: Txt(text: widget.text),
                  labelStyle: secondaryTextStyle(
                    weight: FontWeight.w600,
                  ),
                ),
              ).paddingSymmetric(horizontal: 16),
              16.height,
              if (widget.changePassword)
                AppTextField(
                  controller: widget.controller2,
                  textFieldType: TextFieldType.PASSWORD,
                  suffixPasswordInvisibleWidget: const Txt(
                    text: 'Show',
                  ).paddingOnly(top: 20),
                  suffixPasswordVisibleWidget: const Txt(
                    text: 'Hide',
                  ).paddingOnly(top: 20),
                  textStyle: TextStyle(
                      color: themeProvider.isPreDarkMode ? Colors.white : null),
                  decoration: InputDecoration(
                    label: const Txt(text: 'New password'),
                    labelStyle: secondaryTextStyle(
                      weight: FontWeight.w600,
                    ),
                  ),
                ).paddingSymmetric(horizontal: 16, vertical: 16),
              MyButton(text: 'Update', onPressed: widget.onPressed)
            ],
          ),
        ));
  }
}
