import 'package:Afaq/models/rental_model.dart';
import 'package:Afaq/widgets/icon_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class InfoSquare extends StatelessWidget {
  final RentalModel rental;
  final double iconSize;
  final double spaceWidth;
  const InfoSquare(
      {Key? key,
      required this.rental,
      this.iconSize = 18,
      this.spaceWidth = 10})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconText(
          text: "${rental.sqft} م٢ ",
          icon: Icon(MaterialIcons.square_foot,
              color: Colors.black45, size: iconSize),
        ),
        SizedBox(width: spaceWidth),
        IconText(
          text: "${rental.baths} دورة مياه ",
          icon: Icon(MaterialIcons.bathtub,
              color: Colors.black45, size: iconSize),
        ),
        SizedBox(width: spaceWidth),
        IconText(
          text: "${rental.beds} غرفة ",
          icon: Icon(MaterialIcons.king_bed,
              color: Colors.black45, size: iconSize),
        ),
      ],
    );
  }
}
