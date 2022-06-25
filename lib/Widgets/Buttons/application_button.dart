part of 'package:tum/Widgets/widgets.dart';

class ApplicationButton extends StatelessWidget {
  const ApplicationButton(
      {Key? key,
      this.selected = false,
      this.tooltip,
      this.onTap,
      this.icon,
      required this.text})
      : super(key: key);

  final bool selected;
  final String? tooltip;
  final Function()? onTap;
  final IconData? icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          padding: const EdgeInsets.all(3),
          height: 110,
          width: 130,
          decoration: BoxDecoration(
            color: selected
                ? Colors.green.withOpacity(0.42)
                : Colors.grey.withOpacity(0.3),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                size: 34,
                color: selected ? Colors.green : null,
              ),
              const SizedBox(
                height: 7,
              ),
              Txt(
                text: text,
                upperCaseFirst: true,
                textAlign: TextAlign.center,
              )
            ],
          )),
    );
  }
}
