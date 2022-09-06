part of 'package:tum/UI/home/home.dart';

class AccountSettings extends StatefulWidget {
  const AccountSettings({Key? key}) : super(key: key);

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
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

  final ImagePicker _picker = ImagePicker();
  UploadTask? task;
  XFile? _imageFile;
  String urlDownload = '';
  bool loading = false;

  void _setImageFileFromFile(XFile? value) {
    _imageFile = value;
  }

  void showImagePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding:
                const EdgeInsets.only(bottom: 30, left: 25, right: 10, top: 10),
            child: Wrap(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        onPressed: () => deleteImage(context),
                        icon: const Icon(Icons.delete))
                  ],
                ),
                15.height,
                Row(
                  children: [
                    InkWell(
                      onTap: () async => pickImage(ImageSource.gallery),
                      child: Column(
                        children: [
                          const ApplicationIconWidget(
                              color: Colors.blue, icon: Icons.browse_gallery),
                          6.height,
                          const Txt(text: 'Gallery')
                        ],
                      ),
                    ),
                    20.width,
                    InkWell(
                      onTap: () async => pickImage(ImageSource.camera),
                      child: Column(
                        children: [
                          const ApplicationIconWidget(
                              color: Colors.red, icon: Icons.photo_camera),
                          6.height,
                          const Txt(text: 'Camera')
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  Future<void> delete(String timeStamp, FirebaseHelper provider) async {
    log("Deleting");
    try {
      if (timeStamp != "") {
        final image = await storage.localFile('$timeStamp.jpg');
        await image.delete();
      }
      provider.update({
        "profile/profileImage": {
          "url": "",
          "timeStamp": "",
          "name": "",
        },
      });
      setState(() => _imageFile = null);

      toast('Image deleted successfully');
    } catch (e) {
      toast('image delete failed');
    }
    if (mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> deleteImage(context) async {
    Navigator.pop(context);
    final provider = Provider.of<FirebaseHelper>(context, listen: false);

    String? value(String path) {
      return provider.home!.snapshot.child(path).value.toString();
    }

    final timeStamp = value('profile/profileImage/timeStamp');

    if (_imageFile == null && timeStamp == "") {
      toast("No image to delete");
      return;
    }

    try {
      await PageDialog.yesOrNoDialog(
          context, 'Delete Image', 'Do you want to delete this image?',
          onPressed: () async => await delete(timeStamp ?? "", provider));
    } catch (e) {
      toast('image delete failed');
    }
  }

  Future pickImage(ImageSource source) async {
    Navigator.of(context).pop();
    debugPrint('Picking file...');
    try {
      final image = await ImagePicker().pickImage(
        source: source,
      );
      if (image == null) return;
      if (mounted) {
        Provider.of<TUMState>(context, listen: false).setupLostData();
      }
      // context.read<TUMState>().setupLostData();

      // final bytes = File(image.path).readAsBytesSync();
      // setState((() => _base64Image = base64Encode(bytes)));
      debugPrint('image file: $image');

      setState(() {
        debugPrint('Image picked : ${image.path}');

        _imageFile = image;
      });
    } on PlatformException catch (e) {
      debugPrint('Failed to pick image $e');
    }
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        if (response.file == null) {
          _setImageFileFromFile(response.file);
        } else {
          _imageFile = response.file;
        }
      });
    } else {
      messenger.showToast(response.exception!.code);
    }
  }

  Future _uploadFile() async {
    // if (_imageFile == null) {
    //   messenger.showToast('No image selected');
    //   return;
    // }
    final fileName = '${userId()}.jpg';
    final destination = 'profileImages/$fileName';
    task = context
        .read<FirebaseApi>()
        .uploadFile(destination, File(_imageFile!.path));

    if (task == null) {
      messenger.showToast('Failed to upload image');
      return;
    }

    final snapshot = await task!.whenComplete(() {
      debugPrint('Upload complete');
    });
    final url = await snapshot.ref.getDownloadURL();

    setState(() => urlDownload = url);
  }

  Future<bool> _changePassword(
      String currentPassword, String newPassword) async {
    bool success = false;

    //Create an instance of the current user.

    User? user = FirebaseAuth.instance.currentUser;
    //Must re-authenticate user before updating the password. Otherwise it may fail or user get signed out.

    final cred = EmailAuthProvider.credential(
        email: user!.email!, password: currentPassword);
    await user.reauthenticateWithCredential(cred).then((value) async {
      await user.updatePassword(newPassword).then((_) {
        success = true;
        if (!mounted) return;
        Navigator.pop(context);
        dialog.alert(context, "Your new password has been updated successfully",
            type: ArtSweetAlertType.success);
      }).catchError((error) {
        toast(error);
      });
    }).catchError((err) {
      toast(err);
    });

    return success;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final provider = Provider.of<FirebaseHelper>(context);

    String? value(String path) {
      return provider.home!.snapshot.child(path).value.toString();
    }

    final timeStamp = value('profile/profileImage/timeStamp');

    Future<File?> preparePath() async {
      File fileImage = await storage.localFile('$timeStamp.jpg');
      log('IMAGE: $fileImage');
      return timeStamp == "" ? null : fileImage;
    }

    final fullName = TextEditingController(
      text: value('profile/fullName'),
    );

    final registrationNumber =
        TextEditingController(text: value('profile/registrationNumber'));
    final phoneNumber =
        TextEditingController(text: value('profile/phoneNumber'));
    final currentPassword = TextEditingController();
    final newPassword = TextEditingController();

    Future<void> update(Map<String, Object?> map) async {
      await provider.update(map);
      if (mounted) {
        Navigator.pop(context);
      }
      toast('Information updated successfully');
    }

    return FutureBuilder<void>(
        future: retrieveLostData(),
        builder: (context, snapshot) {
          return Scaffold(
              bottomNavigationBar: _bannerAd == null
                  ? null
                  : Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      height: 52,
                      child: AdWidget(ad: _bannerAd!)),
              appBar: AppBar(
                title: const Txt(text: "Account settings"),
              ),
              body: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                children: [
                  Center(
                      child: FutureBuilder<File?>(
                          future: preparePath(),
                          builder: (context, AsyncSnapshot<File?> snapshot) {
                            if (_imageFile != null) {
                              _uploadFile();

                              provider.update({
                                "profile/profileImage": {
                                  "url": urlDownload,
                                  "timeStamp": _imageFile != null
                                      ? DateTime.now().millisecondsSinceEpoch
                                      : "",
                                  "name": "${userId()}.jpg",
                                },
                              });
                              if (provider.success) {
                                toast('Profile photo updated successfully');
                              }
                            }
                            if (snapshot.connectionState ==
                                    ConnectionState.done &&
                                snapshot.data != null) {
                              log('image previous = ${snapshot.data} \n image new = $_imageFile');
                              return SetupAvatar(
                                image: _imageFile,
                                imageFile: snapshot.data,
                                onPressed: () => showImagePicker(context),
                              );
                            }
                            return SetupAvatar(
                              onPressed: () => showImagePicker(context),
                              image: _imageFile,
                            );
                          })),
                  20.height,
                  AppTextField(
                    onTap: () => UpdateAccountInfo(
                      text: 'Your full name',
                      title: 'Change full name',
                      textFieldType: TextFieldType.NAME,
                      controller1: fullName,
                      onPressed: () async =>
                          await update({'profile/fullName': fullName.text}),
                    ).launch(context,
                        pageRouteAnimation: PageRouteAnimation.Scale),
                    controller: fullName,
                    textFieldType: TextFieldType.NAME,
                    suffix: const Icon(Icons.chevron_right),
                    textStyle: TextStyle(
                        color: themeProvider.isDarkMode ? Colors.white : null),
                    readOnly: true,
                    decoration: const InputDecoration(
                        hintText: 'Full name', label: Txt(text: 'Full name')),
                  ),
                  10.height,
                  AppTextField(
                    onTap: () => UpdateAccountInfo(
                      text: 'Your registration number',
                      title: 'Update registration number',
                      textFieldType: TextFieldType.NAME,
                      controller1: registrationNumber,
                      onPressed: () async => await update({
                        'profile/registrationNumber': registrationNumber.text
                      }),
                    ).launch(context,
                        pageRouteAnimation: PageRouteAnimation.Scale),
                    controller: registrationNumber,
                    textFieldType: TextFieldType.NAME,
                    suffix: const Icon(Icons.chevron_right),
                    textStyle: TextStyle(
                        color: themeProvider.isDarkMode ? Colors.white : null),
                    readOnly: true,
                    decoration: const InputDecoration(
                        hintText: 'Registration number',
                        label: Txt(text: 'Registration number')),
                  ),
                  10.height,
                  AppTextField(
                    onTap: () => UpdateAccountInfo(
                      text: 'Your phone number',
                      title: 'Update phone number',
                      textFieldType: TextFieldType.NUMBER,
                      controller1: phoneNumber,
                      onPressed: () async => await update(
                          {'profile/phoneNumber': phoneNumber.text}),
                    ).launch(context,
                        pageRouteAnimation: PageRouteAnimation.Scale),
                    controller: phoneNumber,
                    textFieldType: TextFieldType.NUMBER,
                    suffix: const Icon(Icons.chevron_right),
                    textStyle: TextStyle(
                        color: themeProvider.isDarkMode ? Colors.white : null),
                    readOnly: true,
                    decoration: const InputDecoration(
                        hintText: 'Phone number',
                        label: Txt(text: 'Phone number')),
                  ),
                  20.height,
                  ListTile(
                    onTap: () => UpdateAccountInfo(
                        text: 'Current password',
                        title: 'Update your password',
                        textFieldType: TextFieldType.PASSWORD,
                        changePassword: true,
                        controller1: currentPassword,
                        controller2: newPassword,
                        onPressed: () async => await _changePassword(
                            currentPassword.text, newPassword.text)).launch(
                        context,
                        pageRouteAnimation: PageRouteAnimation.Scale),
                    trailing: const Icon(Icons.chevron_right),
                    title: const Txt(text: 'Change password'),
                    leading: const ApplicationIconWidget(
                        color: Colors.purple, icon: Icons.password),
                  ),
                ],
              ));
        });
  }
}
