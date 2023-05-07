import "package:clipboard/clipboard.dart";
import "package:flutter/material.dart";

import "package:greengrocer/src/models/order_model.dart";
import "package:greengrocer/src/services/utils_services.dart";

class PaymentDialog extends StatelessWidget {
  final OrderModel order;
  final UtilsServices utilsServices = UtilsServices();

  PaymentDialog({
    super.key,
    required this.order
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Padding(
                  padding:  EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Pagamento com Pix",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                    )
                  )
                ),
                Image.memory(
                  this.utilsServices.decodeQrCodeImage(this.order.qrCodeImage),
                  width: 200,
                  height: 200
                ),
                Text(
                  "Vencimento ${this.utilsServices.formatDateTime(this.order.overdueDateTime)}",
                  style: const TextStyle(fontSize: 12)
                ),
                Text(
                  "Total ${this.utilsServices.priceToCurrency(this.order.total)}",
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold
                  )
                ),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    side: const BorderSide(width: 2, color: Colors.green)
                  ),
                  onPressed: () {
                    FlutterClipboard.copy(this.order.copyAndPaste);
                    this.utilsServices.showToast(message: "Código copiado");
                  },
                  icon: const Icon(Icons.copy, size: 15),
                  label: const Text("Copiar código Pix", style: TextStyle(fontSize: 13))
                )
              ]
            )
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close)
            )
          )
        ]
      )
    );
  }
}