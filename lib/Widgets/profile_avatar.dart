part of 'package:tum/Widgets/widgets.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({Key? key, this.onPressed}) : super(key: key);

  final Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      width: 130,
      child: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.expand,
        children: [
          const CircleAvatar(
            backgroundImage: NetworkImage(
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSKPfgzu_mQU02o2kX5rn0hMGU8MQKpHsHdGQ&usqp=CAU'),
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
    );
  }
}
