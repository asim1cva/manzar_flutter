import 'package:http/http.dart' as http;
import 'package:manzar_flutter/models/channel.dart';
import 'package:manzar_flutter/models/playlist.dart';
import 'dart:convert';
import 'package:uuid/uuid.dart';

class M3uService {
  final Uuid _uuid = const Uuid();

  Future<String> fetchM3uContent(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return utf8.decode(response.bodyBytes);
      } else {
        throw Exception('Failed to load playlist');
      }
    } catch (e) {
      throw Exception('Error fetching playlist: $e');
    }
  }

  Playlist parsePlaylist(
    String content,
    String sourceUrl,
    String playlistName,
  ) {
    List<Channel> channels = [];
    List<String> lines = LineSplitter.split(content).toList();

    String? currentName;
    String? currentLogo;
    String? currentGroup;
    String? currentId;

    // Simple parser state
    // EXTINF:-1 tvg-id="" tvg-name="Channel Name" tvg-logo="http://logo.png" group-title="Sports",Channel Name Display
    // http://stream.url

    for (int i = 0; i < lines.length; i++) {
      String line = lines[i].trim();

      if (line.isEmpty) continue;

      if (line.startsWith('#EXTINF:')) {
        // Parse metadata
        // Extract attributes
        currentGroup = _extractAttribute(line, 'group-title');
        currentLogo = _extractAttribute(line, 'tvg-logo');

        // Extract Name (after the last comma)
        int lastCommaIndex = line.lastIndexOf(',');
        if (lastCommaIndex != -1 && lastCommaIndex < line.length - 1) {
          currentName = line.substring(lastCommaIndex + 1).trim();
        } else {
          // Fallback if no comma or name after comma
          currentName = 'Unknown Channel';
        }
      } else if (!line.startsWith('#')) {
        // This is likely the URL
        if (currentName != null) {
          channels.add(
            Channel(
              id: currentId ?? _uuid.v4(),
              name: currentName,
              url: line,
              logoUrl: currentLogo,
              group: currentGroup ?? 'Uncategorized',
            ),
          );

          // Reset for next
          currentName = null;
          currentLogo = null;
          currentGroup = null;
          currentId = null;
        }
      }
    }

    // If no channels were found, it might be a single channel link (.m3u8)
    if (channels.isEmpty &&
        (sourceUrl.endsWith('.m3u8') ||
            sourceUrl.endsWith('.ts') ||
            sourceUrl.endsWith('.mp4'))) {
      channels.add(
        Channel(
          id: _uuid.v4(),
          name: playlistName,
          url: sourceUrl,
          group: 'Direct Link',
        ),
      );
    }

    return Playlist(
      id: _uuid.v4(),
      name: playlistName,
      sourceUrl: sourceUrl,
      channels: channels,
      updatedAt: DateTime.now(),
    );
  }

  String? _extractAttribute(String line, String attribute) {
    RegExp regex = RegExp('$attribute="([^"]*)"');
    Match? match = regex.firstMatch(line);
    return match?.group(1);
  }
}
