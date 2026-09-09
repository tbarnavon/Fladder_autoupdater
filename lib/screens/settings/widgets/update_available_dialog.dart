import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown_widget/widget/markdown.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:fladder/providers/update_download_provider.dart';
import 'package:fladder/screens/shared/fladder_notification_overlay.dart';
import 'package:fladder/util/localization_helper.dart';
import 'package:fladder/util/update_checker.dart';

Future<void> showUpdateAvailableDialog(BuildContext context, ReleaseInfo release) {
  return showDialog(
    context: context,
    builder: (context) => UpdateAvailableDialog(release: release),
  );
}

class UpdateAvailableDialog extends ConsumerWidget {
  final ReleaseInfo release;
  const UpdateAvailableDialog({required this.release, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final download = ref.watch(updateDownloadProvider);

    ref.listen(updateDownloadProvider, (previous, next) {
      if (next.status == UpdateDownloadStatus.permissionDenied) {
        FladderSnack.show(
          context.localized.installPermissionRequiredMessage,
          context: context,
          actionLabel: context.localized.openSettings,
          onActionPressed: () => openAppSettings(),
        );
      } else if (next.status == UpdateDownloadStatus.error && next.errorMessage != null) {
        FladderSnack.show(next.errorMessage!, context: context);
      } else if (previous?.status == UpdateDownloadStatus.installing && next.status == UpdateDownloadStatus.idle) {
        // Android handed off to the system installer sheet; nothing left to do here.
        Navigator.of(context).maybePop();
      }
    });

    return AlertDialog(
      title: Text(context.localized.newReleaseFoundTitle(release.version)),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 300),
              child: SingleChildScrollView(
                child: MarkdownWidget(
                  data: release.changelog,
                  shrinkWrap: true,
                ),
              ),
            ),
            if (download.isBusy) ...[
              const SizedBox(height: 16),
              LinearProgressIndicator(value: download.progress > 0 ? download.progress : null),
              const SizedBox(height: 8),
              Text(
                download.status == UpdateDownloadStatus.installing
                    ? context.localized.installingUpdate
                    : context.localized.downloadingUpdate,
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: download.isBusy ? null : () => Navigator.of(context).pop(),
          child: Text(context.localized.updateDialogLaterButton),
        ),
        FilledButton(
          onPressed:
              download.isBusy ? null : () => ref.read(updateDownloadProvider.notifier).downloadAndInstall(release),
          child: Text(context.localized.updateDialogUpdateButton),
        ),
      ],
    );
  }
}
