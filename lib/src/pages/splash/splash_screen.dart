import "package:flutter/material.dart";

import "package:greengrocer/src/config/custom_colors.dart";
import "package:greengrocer/src/pages/widgets/app_name_widget.dart";

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              CustomColors.customSwatchColor,
              CustomColors.customSwatchColor.shade700
            ]
          )
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const <Widget>[
            AppNameWidget(
              greenColorTile: Colors.white,
              textSize: 40
            ),
            SizedBox(height: 10),
            CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color?>(Colors.white))
          ]
        )
      )
    );
  }
}