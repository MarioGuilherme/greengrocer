import "package:flutter/material.dart";

import "package:greengrocer/src/config/custom_colors.dart";

class AppNameWidget extends StatelessWidget {
  final Color? greenColorTile;
  final double textSize;

  const AppNameWidget({
    this.textSize = 30,
    super.key,
    this.greenColorTile
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: TextStyle(fontSize: this.textSize),
        children: <InlineSpan>[
          TextSpan(
            text: "Green",
            style: TextStyle(color: this.greenColorTile ?? CustomColors.customSwatchColor)
          ),
          TextSpan(
            text: "grocer",
            style: TextStyle(color: CustomColors.customContrastColor)
          )
        ]
      )
    );
  }
}