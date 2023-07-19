import 'package:nhom17/consts/consts.dart';

Widget bgWidget({required Scaffold child}) {
  return Scaffold(
    body: Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imgBackground),
          fit: BoxFit.fill,
        ),
      ),
      child: child,
    ),
  );
}
