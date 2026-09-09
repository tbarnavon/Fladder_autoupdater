import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:background_downloader/background_downloader.dart' as dl;
import 'package:collection/collection.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:fladder/util/update_checker.dart';
import 'package:fladder/util/update_installer.dart';

part 'update_download_provider.freezed.dart';
part 'update_download_provider.g.dart';

enum UpdateDownloadStatus {
  idle,
  downloading,
  installing,
  permissionDenied,
  error,
}

@Freezed(copyWith: true, toJson: false, fromJson: false)
abstract class UpdateDownloadModel with _$UpdateDownloadModel {
  const UpdateDownloadModel._();

  factory UpdateDownloadModel({
    @Default(UpdateDownloadStatus.idle) UpdateDownloadStatus status,
    @Default(0.0) double progress,
    String? errorMessage,
  }) = _UpdateDownloadModel;

  bool get isBusy => status == UpdateDownloadStatus.downloading || status == UpdateDownloadStatus.installing;
}

@Riverpod(keepAlive: true)
class UpdateDownload extends _$UpdateDownload {
  @override
  UpdateDownloadModel build() => UpdateDownloadModel();

  Future<void> downloadAndInstall(ReleaseInfo release) async {
    state = UpdateDownloadModel(status: UpdateDownloadStatus.downloading);

    final url = await _resolveDownloadUrl(release);
    if (url == null) {
      state = state.copyWith(
        status: UpdateDownloadStatus.error,
        errorMessage: 'No compatible download was found for this platform in the latest release.',
      );
      return;
    }

    final task = dl.DownloadTask(
      url: url,
      filename: Uri.parse(url).pathSegments.last,
      baseDirectory: dl.BaseDirectory.temporary,
      updates: dl.Updates.statusAndProgress,
    );

    final result = await dl.FileDownloader().download(
      task,
      onProgress: (progress) => state = state.copyWith(status: UpdateDownloadStatus.downloading, progress: progress),
    );

    if (result.status != dl.TaskStatus.complete) {
      state = state.copyWith(
        status: UpdateDownloadStatus.error,
        errorMessage: 'The download failed. Check your connection and available storage, then try again.',
      );
      return;
    }

    await _install(await task.filePath());
  }

  Future<void> _install(String filePath) async {
    state = state.copyWith(status: UpdateDownloadStatus.installing);

    if (defaultTargetPlatform == TargetPlatform.android) {
      switch (await installAndroidApk(filePath)) {
        case InstallResult.started:
          state = state.copyWith(status: UpdateDownloadStatus.idle);
        case InstallResult.permissionDenied:
          state = state.copyWith(status: UpdateDownloadStatus.permissionDenied);
        case InstallResult.failed:
          state = state.copyWith(
            status: UpdateDownloadStatus.error,
            errorMessage: 'Could not open the downloaded update.',
          );
      }
      return;
    }

    if (!kIsWeb && Platform.isWindows) {
      // Does not return: the app exits once the installer process has started.
      await runWindowsInstaller(filePath);
    }
  }

  Future<String?> _resolveDownloadUrl(ReleaseInfo release) async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      final abi = (await DeviceInfoPlugin().androidInfo).supportedAbis.firstOrNull;
      return release.downloadUrlFor('android_$abi') ?? release.downloadUrlFor('android');
    }
    if (!kIsWeb && Platform.isWindows) {
      return release.downloadUrlFor('windows_installer');
    }
    return null;
  }

  void reset() => state = UpdateDownloadModel();
}
