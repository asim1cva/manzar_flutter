import 'package:flutter/material.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:manzar_flutter/models/channel.dart';
import 'package:manzar_flutter/controllers/playlist_controller.dart';
import 'package:manzar_flutter/screens/settings_screen.dart';
import 'package:manzar_flutter/screens/video_player_screen.dart';
import 'package:manzar_flutter/utils/public_playlists.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final PlaylistController controller = Get.find<PlaylistController>();
  String _searchQuery = ''; // Debounced
  String _rawSearchQuery = ''; // Immediate
  Timer? _debounce;
  String _selectedGroup = 'All';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MANZAR'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All Channels'),
            Tab(text: 'Favorites'),
            Tab(text: 'History'),
            Tab(text: 'Groups'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              final selectedId = controller.selectedPlaylist?.id;
              if (selectedId != null) {
                controller
                    .refreshPlaylist(selectedId)
                    .then((_) {
                      Get.snackbar(
                        'Success',
                        'Playlist refreshed',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.green.withOpacity(0.7),
                        colorText: Colors.white,
                      );
                    })
                    .catchError((e) {
                      Get.snackbar(
                        'Error',
                        'Failed to refresh: $e',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red.withOpacity(0.7),
                        colorText: Colors.white,
                      );
                    });
              } else {
                Get.snackbar(
                  'Info',
                  'No playlist selected',
                  snackPosition: SnackPosition.BOTTOM,
                );
              }
            },
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildChannelList(filter: 'all'),
          _buildChannelList(filter: 'favorites'),
          _buildChannelList(filter: 'history'),
          _buildGroupList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddPlaylistDialog(),
        child: const Icon(Icons.add_link),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Obx(() {
        return Column(
          children: [
            const UserAccountsDrawerHeader(
              accountName: Text('My Playlists'),
              accountEmail: Text('Select or add a playlist'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.tv, size: 40, color: Colors.deepPurple),
              ),
              decoration: BoxDecoration(color: Colors.deepPurple),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  if (controller.playlists.isNotEmpty) ...[
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'YOUR PLAYLISTS',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    ...controller.playlists.map((playlist) {
                      final isSelected =
                          controller.selectedPlaylist?.id == playlist.id;
                      return ListTile(
                        title: Text(playlist.name),
                        subtitle: Text('${playlist.channels.length} channels'),
                        selected: isSelected,
                        selectedTileColor: Colors.deepPurple.withOpacity(0.1),
                        leading: const Icon(Icons.playlist_play),
                        onTap: () {
                          controller.selectPlaylist(playlist.id);
                          Get.back(); // Close drawer
                        },
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            Get.dialog(
                              AlertDialog(
                                title: const Text('Delete Playlist'),
                                content: Text(
                                  'Are you sure you want to delete "${playlist.name}"?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Get.back(),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      controller.deletePlaylist(playlist.id);
                                      Get.back();
                                    },
                                    child: const Text(
                                      'Delete',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    }).toList(),
                  ],
                  const Divider(),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'EXPLORE',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.explore),
                    title: const Text('Browse Public Playlists'),
                    onTap: () {
                      Get.back();
                      _showAddPlaylistDialog();
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('Settings'),
                    onTap: () {
                      Get.back();
                      Get.to(() => const SettingsScreen());
                    },
                  ),
                  if (controller.selectedPlaylist != null) ...[
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'PLAYLIST STATS',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildStatRow(
                            'Total Channels',
                            controller.selectedPlaylist!.channels.length
                                .toString(),
                          ),
                          _buildStatRow(
                            'Groups',
                            _countGroups(
                              controller.selectedPlaylist!,
                            ).toString(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          Text(
            value,
            style: const TextStyle(
              color: Colors.deepPurpleAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  int _countGroups(var playlist) {
    return playlist.channels.map((c) => (c as Channel).group).toSet().length;
  }

  Widget _buildChannelList({required String filter}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search channels...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _rawSearchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _rawSearchQuery = '';
                          _searchQuery = '';
                        });
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: Colors.grey[800],
            ),
            onChanged: (value) {
              setState(() {
                _rawSearchQuery = value;
              });

              if (_debounce?.isActive ?? false) _debounce!.cancel();
              _debounce = Timer(const Duration(milliseconds: 500), () {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              });
            },
          ),
        ),
        if (filter == 'all')
          Obx(() {
            if (controller.selectedPlaylist == null) return const SizedBox();

            final groups = [
              'All',
              ...controller.selectedPlaylist!.channels
                  .map((c) => c.group)
                  .toSet()
                  .toList(),
            ]..sort();

            if (groups.length <= 1) return const SizedBox();

            return SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                itemCount: groups.length,
                itemBuilder: (context, index) {
                  final group = groups[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(group),
                      selected: _selectedGroup == group,
                      onSelected: (selected) {
                        setState(() {
                          _selectedGroup = group;
                        });
                      },
                    ),
                  );
                },
              ),
            );
          }),
        Expanded(
          child: Obx(() {
            if (controller.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            List<Channel> channels = [];
            if (filter == 'favorites') {
              channels = controller.favorites;
            } else if (filter == 'history') {
              channels = controller.recentChannels;
            } else if (controller.selectedPlaylist != null) {
              channels = controller.selectedPlaylist!.channels;
              if (filter == 'all' && _selectedGroup != 'All') {
                channels = channels
                    .where((c) => c.group == _selectedGroup)
                    .toList();
              }
            }

            if (channels.isEmpty) {
              return Center(
                child: Text(
                  filter == 'favorites'
                      ? 'No favorites yet'
                      : 'No channels found. Add a playlist!',
                  style: const TextStyle(color: Colors.grey, fontSize: 16),
                ),
              );
            }

            // Special empty state for history
            if (filter == 'history' && channels.isEmpty) {
              return const Center(child: Text('No recently watched channels'));
            }

            // Filter by search query
            final filteredChannels = channels.where((c) {
              return c.name.toLowerCase().contains(_searchQuery);
            }).toList();

            return RefreshIndicator(
              onRefresh: () async {
                if (controller.selectedPlaylist != null) {
                  await controller.refreshPlaylist(
                    controller.selectedPlaylist!.id,
                  );
                }
              },
              child: ListView.builder(
                itemCount: filteredChannels.length,
                itemBuilder: (context, index) {
                  final channel = filteredChannels[index];
                  final isFavorite = controller.favorites.any(
                    (c) => c.url == channel.url,
                  );

                  return ListTile(
                    leading:
                        channel.logoUrl != null && channel.logoUrl!.isNotEmpty
                        ? Image.network(
                            channel.logoUrl!,
                            width: 50,
                            height: 50,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.tv, size: 40),
                          )
                        : const Icon(Icons.tv, size: 40),
                    title: Text(channel.name),
                    subtitle: Text(channel.group),
                    trailing: IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : null,
                      ),
                      onPressed: () {
                        controller.toggleFavorite(channel);
                      },
                    ),
                    onTap: () {
                      Get.to(() => VideoPlayerScreen(channel: channel));
                    },
                  );
                },
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildGroupList() {
    return Obx(() {
      if (controller.selectedPlaylist == null) {
        return const Center(child: Text('Select a playlist first'));
      }

      // Group channels
      final Map<String, List<Channel>> grouped = {};
      for (var channel in controller.selectedPlaylist!.channels) {
        if (!grouped.containsKey(channel.group)) {
          grouped[channel.group] = [];
        }
        grouped[channel.group]!.add(channel);
      }

      final groups =
          grouped.keys
              .where((g) => g.toLowerCase().contains(_searchQuery))
              .toList()
            ..sort();

      return GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: groups.length,
        itemBuilder: (context, index) {
          final groupName = groups[index];
          final count = grouped[groupName]?.length ?? 0;
          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: InkWell(
              onTap: () {
                Get.to(
                  () => _GroupChannelListScreen(
                    groupName: groupName,
                    channels: grouped[groupName]!,
                  ),
                );
              },
              borderRadius: BorderRadius.circular(15),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    colors: [
                      Colors.deepPurple.shade700,
                      Colors.deepPurple.shade900,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.folder, size: 40, color: Colors.white70),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        groupName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$count Channels',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white60,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }

  Future<void> _showAddPlaylistDialog() async {
    final urlController = TextEditingController();
    final nameController = TextEditingController();

    return Get.dialog(
      AlertDialog(
        title: const Text('Add Playlist from URL'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Playlist Name'),
            ),
            TextField(
              controller: urlController,
              decoration: const InputDecoration(labelText: 'M3U URL'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () =>
                _showPublicPlaylistsDialog(nameController, urlController),
            child: const Text('Browse Public Playlists'),
          ),
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              if (urlController.text.isNotEmpty &&
                  nameController.text.isNotEmpty) {
                // Show a loading snackbar or use a local state if needed
                // For simplicity, just call the controller
                try {
                  await controller.addPlaylist(
                    urlController.text,
                    nameController.text,
                  );
                  Get.back();
                } catch (e) {
                  Get.snackbar('Error', 'Failed to add playlist: $e');
                }
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _showPublicPlaylistsDialog(
    TextEditingController nameController,
    TextEditingController urlController,
  ) async {
    return Get.dialog(
      AlertDialog(
        title: const Text('Select Public Playlist'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: kPublicPlaylists.length,
            itemBuilder: (context, index) {
              final playlist = kPublicPlaylists[index];
              return ListTile(
                leading: Text(
                  playlist.icon ?? '📺',
                  style: const TextStyle(fontSize: 24),
                ),
                title: Text(playlist.name),
                subtitle: Text(
                  playlist.category ?? playlist.region ?? 'Public',
                  style: const TextStyle(color: Colors.grey),
                ),
                onTap: () {
                  nameController.text = playlist.name;
                  urlController.text = playlist.url;
                  Get.back();
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
        ],
      ),
    );
  }
}

class _GroupChannelListScreen extends StatelessWidget {
  final String groupName;
  final List<Channel> channels;

  const _GroupChannelListScreen({
    required this.groupName,
    required this.channels,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(groupName)),
      body: ListView.builder(
        itemCount: channels.length,
        itemBuilder: (context, index) {
          final channel = channels[index];
          return ListTile(
            leading: const Icon(Icons.tv),
            title: Text(channel.name),
            onTap: () {
              Get.to(() => VideoPlayerScreen(channel: channel));
            },
          );
        },
      ),
    );
  }
}
