import "package:flutter/material.dart";
import "package:greengrocer/src/config/custom_colors.dart";

class QuantityWidget extends StatelessWidget {
  final int value;
  final String sufixText;
  final Function(int quantity) result;
  final bool isRemovable;

  const QuantityWidget({
    required this.value,
    required this.sufixText,
    required this.result,
    this.isRemovable = false,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.grey.shade300,
            spreadRadius: 1,
            blurRadius: 2
          )
        ]
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _QuantityButton(
            icon: !this.isRemovable || this.value > 1
              ? Icons.remove
              : Icons.delete_forever,
            color: !this.isRemovable || this.value > 1
              ? Colors.grey
              : Colors.red,
            onPressed: () {
              if (this.value == 1 && !this.isRemovable) return;
              int resultCount = this.value - 1;
              this.result(resultCount);
            }
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Text(
              "${this.value}${this.sufixText}",
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold
              )
            )
          ),
          _QuantityButton(
            icon: Icons.add,
            color: CustomColors.customSwatchColor,
            onPressed: () {
              int resultCount = this.value + 1;
              this.result(resultCount);
            }
          )
        ]
      )
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final Color color;
  final IconData icon;
  final VoidCallback onPressed;

  const _QuantityButton({
    required this.color,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        borderRadius: BorderRadius.circular(50),
        onTap: this.onPressed,
        child: Ink(
          height: 25,
          width: 25,
          decoration: BoxDecoration(
            color: this.color,
            shape: BoxShape.circle
          ),
          child: Icon(
            this.icon,
            color: Colors.white,
            size: 16
          )
        )
      )
    );
  }
}
