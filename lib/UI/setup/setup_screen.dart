part of 'package:tum/UI/setup/setup.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({Key? key}) : super(key: key);

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  var _image;
  void showImagePicker(BuildContext context) {
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
      XFile? image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      debugPrint('image file: $image');

      final imageTemporary = File(image.path);
      setState(() {
        debugPrint('Image picked : ${image.path}');
        _image = File(image.path);
      });
    } on PlatformException catch (e) {
      debugPrint('Failed to pick image $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Dimens.pushCentered(scale: 1.2),
              GestureDetector(
                onTap: () async {

                  XFile? image = await ImagePicker().pickImage(
                      source: ImageSource.gallery, imageQuality: 50, preferredCameraDevice: CameraDevice.front);
                  setState(() {
                    _image = File(image!.path);
                  });
                },
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                      color: Colors.red[200]),
                  child: _image != null
                      ? Image.file(
                    _image,
                    width: 200.0,
                    height: 200.0,
                    fit: BoxFit.fitHeight,
                  )
                      : Container(
                    decoration: BoxDecoration(
                        color: Colors.red[200]),
                    width: 200,
                    height: 200,
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
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
  }
}
