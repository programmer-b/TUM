part of 'package:tum/Widgets/widgets.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({Key? key, this.onPressed, this.image}) : super(key: key);

  final Function()? onPressed;
  final XFile? image;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: SizedBox(
        height: 130,
        width: 130,
        child: Stack(
          clipBehavior: Clip.none,
          fit: StackFit.expand,
          children: [
            CircleAvatar(
              backgroundImage:
                  image == null ? null : FileImage(File(image!.path)),
              child: image == null
                  ? Icon(
                      FontAwesomeIcons.user,
                      size: Dimens.profileIconSize,
                    )
                  : null,
            ),
            Positioned(
                bottom: 0,
                right: -25,
                child: RawMaterialButton(
                  onPressed: onPressed,
                  elevation: 2.0,
                  fillColor: const Color(0xFFF5F6F9),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colorz.primaryGreen,
                  ),
                  padding: const EdgeInsets.all(15.0),
                  shape: const CircleBorder(),
                )),
          ],
        ),
      ),
    );
  }

  Future<ImageProvider<Object>> xFileToImage(XFile xFile) async {
    final Uint8List bytes = await xFile.readAsBytes();
    return Image.memory(bytes).image;
  }
}
