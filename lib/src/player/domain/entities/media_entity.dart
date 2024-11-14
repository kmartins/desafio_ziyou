final class MediaEntity {
  MediaEntity({
    required this.url,
    required this.contentType,
    required this.isPlaying,
    required this.playPosition,
  });

  final String url;
  final String contentType;
  final bool isPlaying;
  final Duration playPosition;

  factory MediaEntity.fromJson(Map<String, dynamic> data) {
    return MediaEntity(
      url: data["url"] as String,
      contentType: data["content_type"] as String,
      isPlaying: data["is_playing"] as bool,
      playPosition: Duration(seconds: data["play_position"] as int),
    );
  }

  Map<String, dynamic> toJson() => {
        "url": url,
        "content_type": contentType,
        "is_playing": isPlaying,
        "play_position": playPosition.inSeconds,
      };

  MediaEntity copyWith({
    String? url,
    String? contentType,
    bool? isPlaying,
    Duration? playPosition,
  }) {
    return MediaEntity(
      url: url ?? this.url,
      contentType: contentType ?? this.contentType,
      isPlaying: isPlaying ?? this.isPlaying,
      playPosition: playPosition ?? this.playPosition,
    );
  }

  @override
  String toString() {
    return 'MediaEntity(url: $url, contentType: $contentType, isPlaying: $isPlaying, playPosition: $playPosition)';
  }

  @override
  bool operator ==(covariant MediaEntity other) {
    if (identical(this, other)) return true;

    return other.url == url &&
        other.contentType == contentType &&
        other.isPlaying == isPlaying &&
        other.playPosition == playPosition;
  }

  @override
  int get hashCode {
    return url.hashCode ^
        contentType.hashCode ^
        isPlaying.hashCode ^
        playPosition.hashCode;
  }
}
