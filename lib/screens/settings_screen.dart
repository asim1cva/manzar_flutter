import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manzar_flutter/controllers/playlist_controller.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PlaylistController controller = Get.find<PlaylistController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Data Management',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Clear History'),
            subtitle: const Text('Remove all recently watched channels'),
            onTap: () {
              Get.dialog(
                AlertDialog(
                  title: const Text('Clear History?'),
                  content: const Text('This action cannot be undone.'),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        controller.clearHistory();
                        Get.back();
                        Get.snackbar(
                          'Success',
                          'History cleared',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      },
                      child: const Text(
                        'Clear',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.favorite_border),
            title: const Text('Clear Favorites'),
            subtitle: const Text('Remove all favorite channels'),
            onTap: () {
              Get.dialog(
                AlertDialog(
                  title: const Text('Clear Favorites?'),
                  content: const Text('This action cannot be undone.'),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        controller.clearFavorites();
                        Get.back();
                        Get.snackbar(
                          'Success',
                          'Favorites cleared',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      },
                      child: const Text(
                        'Clear',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'About',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('Version'),
                  subtitle: Text(
                    '${snapshot.data!.version} (${snapshot.data!.buildNumber})',
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          const ListTile(
            leading: Icon(Icons.code),
            title: Text('Developed with Flutter'),
            subtitle: Text('Powered by Manzar'),
          ),
        ],
      ),
    );
  }
}
