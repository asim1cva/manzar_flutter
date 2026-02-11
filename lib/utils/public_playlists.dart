class PublicPlaylist {
  final String name;
  final String url;
  final String? region;
  final String? category;
  final String? icon;

  const PublicPlaylist({
    required this.name,
    required this.url,
    this.region,
    this.category,
    this.icon,
  });
}

const List<PublicPlaylist> kPublicPlaylists = [
  PublicPlaylist(
    name: 'Global Free TV',
    url: 'https://iptv-org.github.io/iptv/index.m3u',
    region: 'World',
    category: 'General',
    icon: '🌍',
  ),
  PublicPlaylist(
    name: 'Films',
    url: 'https://iptv-org.github.io/iptv/categories/movies.m3u',
    category: 'Movies',
    icon: '🎬',
  ),
  PublicPlaylist(
    name: 'Series',
    url: 'https://iptv-org.github.io/iptv/categories/series.m3u',
    category: 'Series',
    icon: '📺',
  ),
  PublicPlaylist(
    name: 'News',
    url: 'https://iptv-org.github.io/iptv/categories/news.m3u',
    category: 'News',
    icon: '📰',
  ),
  PublicPlaylist(
    name: 'Music',
    url: 'https://iptv-org.github.io/iptv/categories/music.m3u',
    category: 'Music',
    icon: '🎵',
  ),
  PublicPlaylist(
    name: 'Sports (All)',
    url: 'https://iptv-org.github.io/iptv/categories/sports.m3u',
    category: 'Sports',
    icon: '⚽',
  ),
  PublicPlaylist(
    name: 'Auto Racing',
    url: 'https://iptv-org.github.io/iptv/categories/auto.m3u',
    category: 'Sports',
    icon: '🏎️',
  ),
  PublicPlaylist(
    name: 'Cricket & International Sports',
    url: 'https://iptv-org.github.io/iptv/categories/sports.m3u',
    category: 'Cricket',
    icon: '🏏',
  ),
  PublicPlaylist(
    name: 'Willow Cricket',
    url: 'http://178.62.148.20:8080/willowEE/wil00Wo/index.m3u8',
    category: 'Cricket',
    icon: '🏏',
  ),
  PublicPlaylist(
    name: 'Willow Cricket HD',
    url: 'http://tv2.ebox.live:8080/live/willow-cric.m3u8',
    category: 'Cricket',
    icon: '🏏',
  ),
  PublicPlaylist(
    name: 'Outdoor & Extreme',
    url: 'https://iptv-org.github.io/iptv/categories/outdoor.m3u',
    category: 'Sports',
    icon: '🏂',
  ),
  PublicPlaylist(
    name: 'Documentaries',
    url: 'https://iptv-org.github.io/iptv/categories/documentary.m3u',
    category: 'Education',
    icon: '📚',
  ),
  PublicPlaylist(
    name: 'Kids',
    url: 'https://iptv-org.github.io/iptv/categories/kids.m3u',
    category: 'Kids',
    icon: '🧸',
  ),
  PublicPlaylist(
    name: 'USA',
    url: 'https://iptv-org.github.io/iptv/countries/us.m3u',
    region: 'USA',
    icon: '🇺🇸',
  ),
  PublicPlaylist(
    name: 'UK',
    url: 'https://iptv-org.github.io/iptv/countries/uk.m3u',
    region: 'UK',
    icon: '🇬🇧',
  ),
  PublicPlaylist(
    name: 'Canada',
    url: 'https://iptv-org.github.io/iptv/countries/ca.m3u',
    region: 'Canada',
    icon: '🇨🇦',
  ),
  PublicPlaylist(
    name: 'Saudi Arabia',
    url: 'https://iptv-org.github.io/iptv/countries/sa.m3u',
    region: 'KSA',
    icon: '🇸🇦',
  ),
  PublicPlaylist(
    name: 'Pakistan',
    url: 'https://iptv-org.github.io/iptv/countries/pk.m3u',
    region: 'Pakistan',
    icon: '🇵🇰',
  ),
  PublicPlaylist(
    name: 'India',
    url: 'https://iptv-org.github.io/iptv/countries/in.m3u',
    region: 'India',
    icon: '🇮🇳',
  ),
  PublicPlaylist(
    name: 'T20 World Cup Hub (Sky/Fox)',
    url:
        'https://iptv-org.github.io/iptv/index.m3u', // Filter by Sports category inside
    category: 'Cricket',
    icon: '🏆',
  ),
  PublicPlaylist(
    name: 'Ten Sports / PTV Sports',
    url: 'https://iptv-org.github.io/iptv/countries/pk.m3u',
    region: 'Pakistan',
    icon: '🏏',
  ),
  PublicPlaylist(
    name: 'Star Sports / India Hub',
    url: 'https://iptv-org.github.io/iptv/countries/in.m3u',
    region: 'India',
    icon: '🇮🇳',
  ),
  PublicPlaylist(
    name: 'Stable Test Streams',
    url:
        'https://raw.githubusercontent.com/iptv-org/iptv/master/streams/test.m3u',
    category: 'Test',
    icon: '🧪',
  ),
];
