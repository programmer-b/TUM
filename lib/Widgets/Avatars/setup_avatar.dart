part of 'package:tum/Widgets/widgets.dart';

class SetupAvatar extends StatelessWidget {
  const SetupAvatar({Key? key, this.onPressed, this.image, this.radius = 80}) : super(key: key);

  final Function()? onPressed;
  final XFile? image;
  final double radius;
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
              radius: radius,
              backgroundImage:
                  image == null ? null : FileImage(File(image!.path)),
              child: image == null
                  ? CircleAvatar(
                      radius: radius,
                      backgroundImage: const AssetImage(Assets.defaultAvatar))
                  : null,
            ),
            Positioned(
                bottom: 0,
                right: -25,
                child: RawMaterialButton(
                  onPressed: onPressed,
                  elevation: 2.0,
                  fillColor: const Color(0xFFF5F6F9),
                  padding: const EdgeInsets.all(15.0),
                  shape: const CircleBorder(),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colorz.primaryGreen,
                  ),
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
