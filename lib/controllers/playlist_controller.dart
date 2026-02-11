import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:manzar_flutter/models/channel.dart';
import 'package:manzar_flutter/models/playlist.dart';
import 'package:manzar_flutter/services/m3u_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PlaylistController extends GetxController {
  final _playlists = <Playlist>[].obs;
  final _selectedPlaylist = Rxn<Playlist>();
  final _favorites = <Channel>[].obs;
  final _recentChannels = <Channel>[].obs;
  final _isLoading = false.obs;

  List<Playlist> get playlists => _playlists;
  Playlist? get selectedPlaylist => _selectedPlaylist.value;
  List<Channel> get favorites => _favorites;
  List<Channel> get recentChannels => _recentChannels;
  bool get isLoading => _isLoading.value;

  final M3uService _m3uService = M3uService();

  @override
  void onInit() {
    super.onInit();
    loadPlaylists();
  }

  Future<void> addPlaylist(String url, String name) async {
    _setLoading(true);
    try {
      final content = await _m3uService.fetchM3uContent(url);
      final playlist = _m3uService.parsePlaylist(content, url, name);
      _playlists.add(playlist);
      _selectedPlaylist.value = playlist;
      await _savePlaylists();
    } catch (e) {
      debugPrint('Error adding playlist: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> refreshPlaylist(String id) async {
    final index = _playlists.indexWhere((p) => p.id == id);
    if (index == -1) return;

    _setLoading(true);
    try {
      final playlist = _playlists[index];
      // Keep the original name and URL, just update content
      final content = await _m3uService.fetchM3uContent(playlist.sourceUrl);
      final updatedPlaylist = _m3uService
          .parsePlaylist(content, playlist.sourceUrl, playlist.name)
          .copyWith(
            id: playlist.id, // Keep original ID
          );

      _playlists[index] = updatedPlaylist;
      if (_selectedPlaylist.value?.id == id) {
        _selectedPlaylist.value = updatedPlaylist;
      }
      await _savePlaylists();
    } catch (e) {
      debugPrint('Error refreshing playlist: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  void selectPlaylist(String id) {
    _selectedPlaylist.value = _playlists.firstWhere((p) => p.id == id);
  }

  void deletePlaylist(String id) {
    _playlists.removeWhere((p) => p.id == id);
    if (_selectedPlaylist.value?.id == id) {
      _selectedPlaylist.value = _playlists.isNotEmpty ? _playlists.first : null;
    }
    _savePlaylists();
  }

  void toggleFavorite(Channel channel) {
    final index = _favorites.indexWhere((c) => c.url == channel.url);
    if (index != -1) {
      _favorites.removeAt(index);
      channel.isFavorite = false;
    } else {
      channel.isFavorite = true;
      _favorites.add(channel);
    }
    _saveFavorites();
  }

  void addToHistory(Channel channel) {
    // Remove if already exists to move it to the top
    _recentChannels.removeWhere((c) => c.url == channel.url);
    // Add to start
    _recentChannels.insert(0, channel);
    // Keep only last 20
    if (_recentChannels.length > 20) {
      _recentChannels.removeLast();
    }
    _saveHistory();
  }

  Future<void> loadPlaylists() async {
    _setLoading(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final playlistsJson = prefs.getStringList('playlists') ?? [];
      _playlists.value = playlistsJson
          .map((jsonStr) => Playlist.fromJson(jsonDecode(jsonStr)))
          .toList();

      final favoritesJson = prefs.getStringList('favorites') ?? [];
      _favorites.value = favoritesJson
          .map((jsonStr) => Channel.fromJson(jsonDecode(jsonStr)))
          .toList();

      final historyJson = prefs.getStringList('history') ?? [];
      _recentChannels.value = historyJson
          .map((jsonStr) => Channel.fromJson(jsonDecode(jsonStr)))
          .toList();

      if (_playlists.isNotEmpty) {
        _selectedPlaylist.value = _playlists.first;
      }
    } catch (e) {
      debugPrint('Error loading playlists: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _savePlaylists() async {
    final prefs = await SharedPreferences.getInstance();
    final playlistsJson = _playlists
        .map((p) => jsonEncode(p.toJson()))
        .toList();
    await prefs.setStringList('playlists', playlistsJson);
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = _favorites
        .map((c) => jsonEncode(c.toJson()))
        .toList();
    await prefs.setStringList('favorites', favoritesJson);
  }

  Future<void> _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = _recentChannels
        .map((c) => jsonEncode(c.toJson()))
        .toList();
    await prefs.setStringList('history', historyJson);
  }

  void clearHistory() {
    _recentChannels.clear();
    _saveHistory();
  }

  void clearFavorites() {
    _favorites.clear();
    _saveFavorites();
  }

  void _setLoading(bool value) {
    _isLoading.value = value;
  }
}
