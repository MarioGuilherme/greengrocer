import "dart:convert";
import "dart:typed_data";

import "package:flutter/material.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:intl/date_symbol_data_local.dart";
import "package:intl/intl.dart";

class UtilsServices {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<void> saveLocalData({required String key, required String value}) async {
    await this.storage.write(key: key, value: value);
  }

  Future<String?> getLocalData({required String key}) async {
    return await this.storage.read(key: key);
  }

  Future<void> removeLocalData({required String key}) async {
    await this.storage.delete(key: key);
  }

  String priceToCurrency(double price) {
    NumberFormat formatter = NumberFormat.simpleCurrency(locale: "pt_BR",);
    return formatter.format(price);
  }

  String formatDateTime(DateTime dateTime) {
    initializeDateFormatting();
    DateFormat dateFormat = DateFormat.yMd("pt_BR").add_Hm();
    return dateFormat.format(dateTime.toLocal());
  }

  Uint8List decodeQrCodeImage(String value) {
    String base64String = value.split(",").last;
    return base64.decode(base64String);
  }

  void showToast({ required String message, bool isError = false }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: isError ? Colors.red : Colors.white,
      textColor: isError ? Colors.white : Colors.black,
      fontSize: 14
    );
  }
}