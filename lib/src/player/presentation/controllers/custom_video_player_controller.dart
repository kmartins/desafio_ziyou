import 'package:video_player/video_player.dart';

class CustomVideoPlayerController extends VideoPlayerController {
  CustomVideoPlayerController.networkUrl(String url, this.onSeekTo)
      : super.networkUrl(Uri.parse(url));

  final void Function(Duration position) onSeekTo;

  @override
  Future<void> seekTo(Duration position) async {
    await super.seekTo(position);
    onSeekTo(position);
  }
}
