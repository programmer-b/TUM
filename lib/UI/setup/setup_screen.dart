part of 'package:tum/UI/setup/setup.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({Key? key}) : super(key: key);

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final ImagePicker _picker = ImagePicker();
  String? _retrieveDataError;
  XFile? _imageFile;

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
      XFile? image = await ImagePicker().pickImage(
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

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
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
                          validator: (val) {
                            if (val == '') {
                              return 'Full name cannot be blank.';
                            }
                            return null;
                          },
                          hint: 'Your full name',
                          prefixIcon: FontAwesomeIcons.user,
                          label: 'Full name',
                        ),
                        Dimens.textFieldGap(),
                        MyTextField(
                          validator: (val) {
                            if (val == '') {
                              return 'Registration number cannot be blank.';
                            }
                            return null;
                          },
                          hint: 'Your registration number',
                          prefixIcon: Icons.app_registration,
                          label: 'Registration number',
                        ),
                        Dimens.textFieldGap(),
                        MyTextField(
                          validator: (val) {
                            if (val == '') {
                              return 'Phone number cannot be blank.';
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
                          onPressed: () {
                            formKey.currentState!.validate();
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
