import 'dart:async';

import 'package:dupe/app/widgets/dupe_logo.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:material_ui/material_ui.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// App name, version, data sources (with the attributions they require),
/// licenses.
class AboutScreen extends StatelessWidget {
  const new({super.key});

  static final Uri _sourceCode = Uri.parse('https://github.com/BenJneB/Dupe');
  static final Uri _comicVine = Uri.parse('https://comicvine.gamespot.com/');

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.moreAbout)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              const DupeLogo(),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.appTitle, style: text.headlineSmall),
                    FutureBuilder(
                      future: PackageInfo.fromPlatform(),
                      builder: (context, info) => Text(
                        l10n.aboutVersion(switch (info.data) {
                          final i? => '${i.version}+${i.buildNumber}',
                          null => '…',
                        }),
                        key: const Key('aboutVersion'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(l10n.aboutDescription),
          const SizedBox(height: 24),
          Text(l10n.aboutSources, style: text.titleSmall),
          const SizedBox(height: 4),
          Text(l10n.aboutSourcesText),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.open_in_new),
            title: Text(l10n.aboutComicVine),
            onTap: () => unawaited(launchUrl(_comicVine)),
          ),
          const Divider(),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.code),
            title: Text(l10n.aboutSourceCode),
            subtitle: Text(_sourceCode.toString()),
            onTap: () => unawaited(launchUrl(_sourceCode)),
          ),
          ListTile(
            key: const Key('licensesTile'),
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.description_outlined),
            title: Text(l10n.aboutLicenses),
            onTap: () => showLicensePage(
              context: context,
              applicationName: l10n.appTitle,
            ),
          ),
        ],
      ),
    );
  }
}
