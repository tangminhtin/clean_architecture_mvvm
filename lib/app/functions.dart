import 'dart:io';

import 'package:clean_architecture_mvvm/domain/model/model.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';

Future<DeviceInfo> getDeviceDetails() async {
  String name = 'Unknown';
  String identifier = 'Unknown';
  String version = 'Unknown';
  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  try {
    if (Platform.isAndroid) {
      // Return android device info
      var build = await deviceInfoPlugin.androidInfo;
      name = '${build.brand} ${build.model}';
      identifier = build.id;
      version = build.version.codename;
    } else if (Platform.isIOS) {
      // Return ios device info
      var build = await deviceInfoPlugin.iosInfo;
      name = '${build.name} ${build.model}';
      identifier = build.identifierForVendor!;
      version = build.systemVersion!;
    }
  } on PlatformException {
    // Return default data here
    return DeviceInfo(name, identifier, version);
  }

  return DeviceInfo(name, identifier, version);
}

bool isEmailValid(String email) {
  return RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);
}
