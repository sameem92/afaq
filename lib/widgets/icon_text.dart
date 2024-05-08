import 'package:flutter/material.dart';

class IconText extends StatelessWidget {
  final Icon icon;
  final String text;

  const IconText({Key? key, required this.icon, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [


        Text(
          text,
          style: const TextStyle(fontSize: 12, color: Colors.black45),
          textDirection: TextDirection.rtl,
        ),
        const SizedBox(width: 5),
        icon,
      ],
    );
  }
}
