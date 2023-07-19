import 'package:nhom17/consts/consts.dart';

Widget ourButton({onPress, Color? color, Color? textColor, String? title}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: color ?? redColor,
      padding: const EdgeInsets.all(12),
    ),
    onPressed: onPress,
    child:
        title?.text.color(textColor ?? Colors.white).fontFamily(bold).make() ??
            const SizedBox(),
  );
}
