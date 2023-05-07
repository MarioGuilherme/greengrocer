import "package:flutter/material.dart";

import "package:greengrocer/src/config/custom_colors.dart";

class OrderStatusWidget extends StatelessWidget {
  final String status;
  final bool isOverdue;

  final Map<String, int> allStatus = <String, int>{
    "pending_payment": 0,
    "refunded": 1,
    "paid": 2,
    "preparing_purchase": 3,
    "shipping": 4,
    "delivered": 5
  };

  OrderStatusWidget({
    super.key,
    required this.status,
    required this.isOverdue
  });

  int get currentStatus => this.allStatus[this.status]!;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const _StatusDot(isActive: true, title: "Pedido Confirmado"),
        const _CustomDivider(),
        if (this.currentStatus == 1) ...<Widget>[
          const _StatusDot(
            isActive: true,
            title: "Pix estornado",
            backgroundColor: Colors.orange
          )
        ] else if (isOverdue) ...<Widget>[
          const _StatusDot(
            isActive: true,
            title: "Pagamento Pix vencido",
            backgroundColor: Colors.red
          )
        ] else ...<Widget>[
          _StatusDot(isActive: this.currentStatus >= 2, title: "Pagamento"),
          const _CustomDivider(),
          _StatusDot(isActive: this.currentStatus >= 3, title: "Preparando"),
          const _CustomDivider(),
          _StatusDot(isActive: this.currentStatus >= 4, title: "Envio"),
          const _CustomDivider(),
          _StatusDot(isActive: this.currentStatus == 5, title: "Entregue")
        ]
      ]
    );
  }
}

class _StatusDot extends StatelessWidget {
  final bool isActive;
  final String title;
  final Color? backgroundColor;

  const _StatusDot({
    required this.isActive,
    required this.title,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        ClipRRect(
          child: Container(
            alignment: Alignment.center,
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: CustomColors.customSwatchColor),
              color: this.isActive ? backgroundColor
                ?? CustomColors.customSwatchColor
                : Colors.transparent,
            ),
            child: this.isActive
              ? const Icon(Icons.check, size: 13, color: Colors.white)
              : const SizedBox.shrink()
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Text(this.title, style: const TextStyle(fontSize: 12))
        )
      ]
    );
  }
}

class _CustomDivider extends StatelessWidget {
  const _CustomDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10,
      width: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      color: Colors.grey.shade300
    );
  }
}