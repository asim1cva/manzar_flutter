class Channel {
  final String id;
  final String name;
  final String url;
  final String? logoUrl;
  final String group;
  bool isFavorite;

  Channel({
    required this.id,
    required this.name,
    required this.url,
    this.logoUrl,
    this.group = 'Ungrouped',
    this.isFavorite = false,
  });

  factory Channel.fromJson(Map<String, dynamic> json) {
    return Channel(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown',
      url: json['url'] ?? '',
      logoUrl: json['logoUrl'],
      group: json['group'] ?? 'Ungrouped',
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'url': url,
      'logoUrl': logoUrl,
      'group': group,
      'isFavorite': isFavorite,
    };
  }

  Channel copyWith({
    String? id,
    String? name,
    String? url,
    String? logoUrl,
    String? group,
    bool? isFavorite,
  }) {
    return Channel(
      id: id ?? this.id,
      name: name ?? this.name,
      url: url ?? this.url,
      logoUrl: logoUrl ?? this.logoUrl,
      group: group ?? this.group,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
