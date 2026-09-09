import 'dart:io';

import 'package:open_filex/open_filex.dart';
import 'package:permission_handler/permission_handler.dart';

enum InstallResult { started, permissionDenied, failed }

/// Requests the "install unknown apps" permission if needed, then opens the
/// downloaded APK via the system installer (ACTION_VIEW on the apk's FileProvider uri).
Future<InstallResult> installAndroidApk(String filePath) async {
  var status = await Permission.requestInstallPackages.status;
  if (!status.isGranted) {
    status = await Permission.requestInstallPackages.request();
  }
  if (!status.isGranted) return InstallResult.permissionDenied;

  final result = await OpenFilex.open(filePath);
  return result.type == ResultType.done ? InstallResult.started : InstallResult.failed;
}

/// Launches the downloaded Inno Setup installer silently (as the current, non-admin
/// user, matching the installer's /CURRENTUSER-style PrivilegesRequired=lowest setup)
/// and exits this process so the installer can overwrite the running executable.
Future<void> runWindowsInstaller(String filePath) async {
  await Process.start(
    filePath,
    ['/VERYSILENT', '/SUPPRESSMSGBOXES', '/NORESTART'],
    mode: ProcessStartMode.detached,
  );
  await Future.delayed(const Duration(milliseconds: 500));
  exit(0);
}
