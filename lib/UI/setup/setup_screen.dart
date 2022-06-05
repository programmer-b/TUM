part of 'package:tum/UI/setup/setup.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({Key? key}) : super(key: key);

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final ImagePicker _picker = ImagePicker();
  UploadTask? task;
  XFile? _imageFile;
  String urlDownload = '';

  void _setImageFileFromFile(XFile? value) {
    _imageFile = value;
  }

  void showImagePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Wrap(
            children: [
              ListTile(
                onTap: () => pickImage(ImageSource.gallery),
                leading: const Icon(FontAwesomeIcons.images),
                title: const Txt(
                  text: 'Gallery',
                ),
              ),
              ListTile(
                onTap: () => pickImage(ImageSource.camera),
                leading: const Icon(Icons.camera_alt),
                title: const Txt(
                  text: 'Camera',
                ),
              )
            ],
          );
        });
  }

  Future pickImage(ImageSource source) async {
    debugPrint('Picking file...');
    try {
      final image = await ImagePicker().pickImage(
        source: source,
      );
      if (image == null) return;
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

  Future uploadFile() async {
    if (_imageFile == null) {
      messenger.showToast('No image selected');
      return;
    }
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final destination = 'images/$fileName';
    task = FirebaseApi.uploadFile(destination, File(_imageFile!.path));

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

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    final _fullName = TextEditingController();
    final _regNo = TextEditingController();
    final _phoneNo = TextEditingController();

    final provider = Provider.of<FirebaseHelper>(context);

    DateTime now = DateTime.now();
    DateTime dateOnly = now.getDateOnly();

    return FutureBuilder(
        future: retrieveLostData(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          return Scaffold(
            body: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ProfileAvatar(
                          image: _imageFile,
                          onPressed: () => showImagePicker(context),
                        ),
                        Dimens.titleBodyGap(scale: 3),
                        MyTextField(
                          controller: _fullName,
                          textCapitalization: TextCapitalization.characters,
                          validator: (val) {
                            if (val == '') {
                              return 'Full name cannot be blank.';
                            } else if (operations.countWords(val!) < 2) {
                              return 'Please enter your full name';
                            }
                            return null;
                          },
                          hint: 'Your full name',
                          prefixIcon: FontAwesomeIcons.user,
                          label: 'Full name',
                        ),
                        Dimens.textFieldGap(),
                        MyTextField(
                          controller: _regNo,
                          textCapitalization: TextCapitalization.characters,
                          validator: (val) {
                            if (val == '') {
                              return 'Registration number cannot be blank.';
                            } else if (!operations.validRegistrationNumber(
                                val: val!)) {
                              return 'Please enter a valid registration number';
                            }
                            return null;
                          },
                          hint: 'Your registration number',
                          prefixIcon: Icons.app_registration,
                          label: 'Registration number',
                        ),
                        Dimens.textFieldGap(),
                        MyTextField(
                          controller: _phoneNo,
                          keyboardType: TextInputType.number,
                          validator: (val) {
                            if (val == '') {
                              return 'Phone number cannot be blank.';
                            } else if (!operations.isPhoneNoValid(val)) {
                              return 'Please enter a valid phone number';
                            }
                            return null;
                          },
                          hint: 'Your phone number',
                          prefixIcon: Icons.phone_enabled_outlined,
                          label: 'Phone number',
                        ),
                        Dimens.textFieldButtonGap(scale: 2),
                        MyButton(
                          text: 'Finish',
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              dialog.progress(
                                  context, 'Submitting', 'Please wait...');
                              await uploadFile();
                              provider.init();
                              await provider.updateUser({
                                '/profile/fullName': _fullName.text,
                                '/profile/regNo': _regNo.text,
                                '/profile/phoneNo': _phoneNo.text,
                                '/profile/image': urlDownload,
                              });
                              await provider.updateAdmin(
                                  {'userId': userId(), 'date': dateOnly});
                              if (provider.error) {
                                dialog.alert(context,
                                    'Oops! Something went wrong. Please try again',
                                    type: ArtSweetAlertType.danger);
                              }
                              if (provider.success) {
                                Navigator.pushReplacementNamed(
                                    context, '/dashboard');
                              }
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
