import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:network_info_plus/network_info_plus.dart';

class Utils {
  static bool get isMobile => Platform.isAndroid || Platform.isIOS;

  static bool get isDesktop =>
      Platform.isMacOS || Platform.isWindows || Platform.isLinux;

  static Future<String?> getIPAddress() async {
    return NetworkInfo().getWifiIP();
  }

  static Tuple2<String, int> parseIPAddress(String rawInput) {
    void error(String msg) {
      throw FormatException('Illegal IPv4 address, $msg');
    }

    if (rawInput.isEmpty || !rawInput.contains(':')) {
      error('IP is empty or wrong input format');
    }

    final addressParts = rawInput.split(':');
    final ip = addressParts[0];
    final port = addressParts[1];

    final ipBlocks = ip.split('.');
    if (ipBlocks.length != 4) {
      error('IP address should contain exactly 4 parts');
    }
    for (var e in ipBlocks) {
      int? byte = int.tryParse(e);
      if (null == byte) {
        error('one of IP part is not an integer');
      }
      if (byte! < 0 || byte > 255) {
        error('each part must be in the range of `0..255`');
      }
    }
    int? intPort = int.tryParse(port);
    if (null == intPort) {
      error('port is not an integer');
    }
    return Tuple2(ip, intPort!);
  }
}
