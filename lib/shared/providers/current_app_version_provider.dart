import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class CurrentAppVersionProvider extends ChangeNotifier {
  String currentAppVersion = 'WorkBuddy • Free-BASIC-Version 0.001';

  String get appVersion => currentAppVersion;

  CurrentAppVersionProvider() {
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    currentAppVersion = 'WorkBuddy • Free-BASIC-Version ${packageInfo.version}';
    notifyListeners();
  }
}
