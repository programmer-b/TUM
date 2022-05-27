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

  showImagePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            margin: const EdgeInsets.only(bottom: 45),
            child: Wrap(
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
            ),
          );
        });
  }

  Future pickImage(ImageSource source) async {
    debugPrint('Picking file...');
    try {
      XFile? image = await ImagePicker().pickImage(
        source: source,
        maxWidth: 600,
        maxHeight: 600,
        imageQuality: 75,
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
      _retrieveDataError = response.exception!.code;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: retrieveLostData(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          return Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Dimens.pushCentered(scale: 1.2),
                    ProfileAvatar(
                      image: _imageFile,
                      onPressed: showImagePicker(context),
                    ),
                    Dimens.titleBodyGap(scale: 3),
                    const MyTextField(
                      hint: 'Full name',
                      prefixIcon: FontAwesomeIcons.user,
                      label: 'Full name',
                    ),
                    Dimens.textFieldGap(),
                    const MyTextField(
                      hint: 'Registration number',
                      prefixIcon: Icons.app_registration,
                      label: 'Registration number',
                    ),
                    Dimens.textFieldGap(),
                    const MyTextField(
                      hint: 'Phone number',
                      prefixIcon: Icons.phone_enabled_outlined,
                      label: 'Phone number',
                    ),
                    Dimens.textFieldButtonGap(scale: 2),
                    const MyButton(text: 'Finish')
                  ],
                ),
              ),
            ),
          );
        });
  }
}
