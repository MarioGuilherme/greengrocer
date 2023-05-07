import "package:flutter/material.dart";

import "package:greengrocer/src/config/custom_colors.dart";

class CategoryTile extends StatelessWidget {
  final String category;
  final bool isSelected;
  final VoidCallback onPressed;

  const CategoryTile({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: this.onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: this.isSelected
              ? CustomColors.customContrastColor
              : Colors.transparent
          ),
          child: Text(
            this.category,
            style: TextStyle(
              color: this.isSelected
                ? Colors.white
                : CustomColors.customContrastColor,
              fontSize: this.isSelected
                ? 16
                : 14,
              fontWeight: FontWeight.bold
            )
          )
        )
      )
    );
  }
}