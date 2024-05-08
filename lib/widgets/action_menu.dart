import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

class ActionMenu extends StatelessWidget {
  const ActionMenu({
    Key? key,
    required this.text,
    required this.icon,
    required this.press,
  }) : super(key: key);

  final String text;
  final Icon icon;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(

        children: [
          TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.all(20),
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              backgroundColor: Colors.white,
              shadowColor: Colors.white70,
              elevation: 0.5,
            ),
            onPressed: press,
            child: Row(
              children: [
                const Icon(FontAwesome.chevron_left, size: 15,color: Color(0xD74297AA),),



                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(color:Colors.black87),
                    textDirection: TextDirection.rtl,
                  ),
                ),
                const SizedBox(width: 20),
                icon,
              ],
            ),
          ),

        ],
      ),
    );
  }
}
