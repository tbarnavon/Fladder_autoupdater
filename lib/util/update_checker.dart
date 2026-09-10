import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

/// GitHub repository that [UpdateChecker] fetches releases from.
/// Change these two constants when building from a different fork.
const updateRepoOwner = 'realspinelle';
const updateRepoName = 'Fladder_autoupdater';

/// Which release channel this build belongs to. Set at build time via
/// `--dart-define=UPDATE_CHANNEL=nightly` in CI; defaults to stable/release
/// behavior for any build that doesn't pass it (e.g. local `flutter run`).
const kUpdateChannel = String.fromEnvironment('UPDATE_CHANNEL', defaultValue: 'release');

const _nightlyTag = 'nightly';

class ReleaseInfo {
  final String version;
  final String changelog;
  final String url;
  final bool isNewerThanCurrent;
  final bool isPrerelease;
  final int? buildNumber;
  final Map<String, String> downloads;

  ReleaseInfo({
    required this.version,
    required this.changelog,
    required this.url,
    required this.isNewerThanCurrent,
    required this.isPrerelease,
    this.buildNumber,
    required this.downloads,
  });

  /// Identifies this specific release for "have I already seen this" purposes.
  /// [version] alone isn't enough for nightly: every nightly release reuses the
  /// same "nightly" tag, so a newer nightly would otherwise look identical to
  /// one already viewed. Folds in [buildNumber] (unique per nightly) when present.
  String get updateIdentifier => buildNumber != null ? '$version+$buildNumber' : version;

  String? downloadUrlFor(String platform) => downloads[platform];

  Map<String, String> get preferredDownloads {
    final group = _platformGroup();
    final entries = downloads.entries.where((e) => e.key.contains(group));
    return Map.fromEntries(entries);
  }

  Map<String, String> get otherDownloads {
    final group = _platformGroup();
    final entries = downloads.entries.where((e) => !e.key.contains(group));
    return Map.fromEntries(entries);
  }

  String _platformGroup() {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'android';
      case TargetPlatform.iOS:
        return 'ios';
      case TargetPlatform.windows:
        return 'windows';
      case TargetPlatform.macOS:
        return 'macos';
      case TargetPlatform.linux:
        return 'linux';
      default:
        return '';
    }
  }
}

extension DownloadLabelFormatter on String {
  String prettifyKey() {
    final parts = split('_');
    if (parts.isEmpty) return this;

    final base = parts.first.capitalize();
    if (parts.length == 1) return base;

    final variant = parts.sublist(1).join(' ').capitalize();
    return '$base ($variant)';
  }

  String capitalize() => isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}

class UpdateChecker {
  final String owner = updateRepoOwner;
  final String repo = updateRepoName;

  Future<List<ReleaseInfo>> fetchRecentReleases({int count = 5}) async {
    final info = await PackageInfo.fromPlatform();
    final currentVersion = info.version;
    final currentBuildNumber = int.tryParse(info.buildNumber);
    final isNightlyChannel = kUpdateChannel == _nightlyTag;

    final url = Uri.parse('https://api.github.com/repos/$owner/$repo/releases?per_page=$count');
    final response = await http.get(url);

    if (response.statusCode != 200) {
      print('Failed to fetch releases: ${response.statusCode}');
      return [];
    }

    final List<dynamic> releases = jsonDecode(response.body);
    return releases.map((json) {
      final tag = (json['tag_name'] as String?)?.replaceFirst(RegExp(r'^v'), '');
      final changelog = json['body'] as String? ?? '';
      final htmlUrl = json['html_url'] as String? ?? '';
      final assets = json['assets'] as List<dynamic>? ?? [];
      final isPrerelease = json['prerelease'] as bool? ?? false;
      final buildNumber = _extractBuildNumber(changelog);

      final Map<String, String> downloads = {};
      for (final asset in assets) {
        final name = asset['name'] as String? ?? '';
        final downloadUrl = asset['browser_download_url'] as String? ?? '';

        if (name.contains('Android') && name.endsWith('.apk')) {
          // Per-ABI release APKs (Fladder-Android-{version}-{abi}.apk) are keyed by ABI so the
          // right one can be picked for the running device; a nameless/universal APK falls back to 'android'.
          final abi = RegExp(r'-(arm64-v8a|armeabi-v7a|x86_64)\.apk$').firstMatch(name)?.group(1);
          downloads[abi != null ? 'android_$abi' : 'android'] = downloadUrl;
        } else if (name.contains('iOS') && name.endsWith('.ipa')) {
          downloads['ios'] = downloadUrl;
        } else if (name.contains('Windows') && name.endsWith('Setup.exe')) {
          downloads['windows_installer'] = downloadUrl;
        } else if (name.contains('Windows') && name.endsWith('.zip')) {
          downloads['windows_portable'] = downloadUrl;
        } else if (name.contains('macOS') && name.endsWith('.dmg')) {
          downloads['macos'] = downloadUrl;
        } else if (name.contains('Linux') && name.endsWith('.AppImage')) {
          downloads['linux_appimage'] = downloadUrl;
        } else if (name.contains('Linux') && name.endsWith('.flatpak')) {
          downloads['linux_flatpak'] = downloadUrl;
        } else if (name.contains('Linux') && name.endsWith('.zip')) {
          downloads['linux_zip'] = downloadUrl;
        } else if (name.contains('Linux') && name.endsWith('.zsync')) {
          downloads['linux_zsync'] = downloadUrl;
        } else if (name.contains('Web') && name.endsWith('.zip')) {
          downloads['web'] = downloadUrl;
        }
      }

      // Nightly and stable are separate channels: a nightly install only ever considers
      // the rolling "nightly" release (compared by embedded build number, since its tag
      // never changes), and a stable install ignores prereleases and only trusts tags
      // that look like a real semver (a manually-dispatched release build against a
      // branch ref would otherwise tag something like "develop").
      final isNewer = isNightlyChannel
          ? tag == _nightlyTag &&
              buildNumber != null &&
              currentBuildNumber != null &&
              buildNumber > currentBuildNumber
          : !isPrerelease &&
              tag != null &&
              RegExp(r'^\d+\.\d+\.\d+$').hasMatch(tag) &&
              _compareVersions(tag, currentVersion) > 0;

      return ReleaseInfo(
        version: tag ?? 'unknown',
        changelog: changelog.trim(),
        url: htmlUrl,
        isNewerThanCurrent: isNewer,
        isPrerelease: isPrerelease,
        buildNumber: buildNumber,
        downloads: downloads,
      );
    }).toList();
  }

  Future<bool> isUpToDate() async {
    final releases = await fetchRecentReleases(count: 1);
    if (releases.isEmpty) return true;
    return !releases.first.isNewerThanCurrent;
  }

  /// Extracts the CI-embedded `<!-- fladder-update-meta: buildNumber=123 -->` marker
  /// from a release body. Only nightly releases carry this; used to order successive
  /// nightlies since they all share the same fixed "nightly" tag and pubspec version.
  static int? _extractBuildNumber(String changelog) {
    final match = RegExp(r'fladder-update-meta:\s*buildNumber=(\d+)').firstMatch(changelog);
    return match != null ? int.tryParse(match.group(1)!) : null;
  }

  static int _compareVersions(String a, String b) {
    final aParts = a.split('.').map(int.tryParse).toList();
    final bParts = b.split('.').map(int.tryParse).toList();

    for (var i = 0; i < aParts.length || i < bParts.length; i++) {
      final aVal = i < aParts.length ? (aParts[i] ?? 0) : 0;
      final bVal = i < bParts.length ? (bParts[i] ?? 0) : 0;
      if (aVal != bVal) return aVal.compareTo(bVal);
    }
    return 0;
  }
}
