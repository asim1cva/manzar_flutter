import 'package:manzar_flutter/models/channel.dart';

class Playlist {
  final String id;
  final String name;
  final String sourceUrl;
  final List<Channel> channels;
  final DateTime updatedAt;

  Playlist({
    required this.id,
    required this.name,
    required this.sourceUrl,
    required this.channels,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sourceUrl': sourceUrl,
      'channels': channels.map((c) => c.toJson()).toList(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Playlist.fromJson(Map<String, dynamic> json) {
    return Playlist(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown Playlist',
      sourceUrl: json['sourceUrl'] ?? '',
      channels:
          (json['channels'] as List<dynamic>?)
              ?.map((e) => Channel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
  Playlist copyWith({
    String? id,
    String? name,
    String? sourceUrl,
    List<Channel>? channels,
    DateTime? updatedAt,
  }) {
    return Playlist(
      id: id ?? this.id,
      name: name ?? this.name,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      channels: channels ?? this.channels,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
