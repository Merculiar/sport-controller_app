import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sport_controller_app/services/encrypt_service.dart';

class SocketProvider extends ChangeNotifier {
  int _scoreA = 0;
  int get scoreA => _scoreA;
  set scoreA(int newValue) {
    if (newValue != _scoreA) {
      _scoreA = newValue;
      notifyListeners();
    }
  }

  int _scoreB = 0;
  int get scoreB => _scoreB;
  set scoreB(int newValue) {
    if (newValue != _scoreB) {
      _scoreB = newValue;
      notifyListeners();
    }
  }

  String _information = 'This is great battle between Team1 and Team2';
  String get information => _information;
  set information(String newValue) {
    if (newValue != _information) {
      _information = newValue;
      notifyListeners();
    }
  }

  Socket? socket;

  String get matchScore => '$scoreA:$scoreB';

  Future<void> connectToSocket(String ipAddress, int port) async {
    try {
      socket = await Socket.connect(
        ipAddress,
        port,
        timeout: const Duration(seconds: 5),
      );

      debugPrint('Data sent successfully');
    } catch (e) {
      debugPrint('Error');
    }
  }

  Future<void> sendData() async {
    // Send data to the server
    Map<String, dynamic> jsonData = {
      'information': information,
      'scoreA': scoreA,
      'scoreB': scoreB,
    };
    var encryptedJson = EncryptService.encryptJson(jsonData);
    socket?.write(encryptedJson);
  }
}
