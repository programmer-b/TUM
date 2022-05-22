part of 'package:tum/UI/setup/setup.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({Key? key}) : super(key: key);

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  void showImagePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Wrap(
              children: [
                ListTile(
                  onTap: () {},
                  leading: const Icon(FontAwesomeIcons.images),
                  title: const Txt(
                    text: 'Gallery',
                  ),
                ),
                ListTile(
                  onTap: () {},
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
              ProfileAvatar(onPressed: () => showImagePicker(context)),
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
