import 'package:desafio_ziyou/injection.dart';
import 'package:desafio_ziyou/src/core/state/async_state.dart';
import 'package:desafio_ziyou/src/player/domain/entities/device_entity.dart';
import 'package:desafio_ziyou/src/player/domain/entities/device_session.dart';
import 'package:desafio_ziyou/src/player/domain/entities/media_entity.dart';
import 'package:desafio_ziyou/src/player/presentation/controllers/custom_video_player_controller.dart';
import 'package:desafio_ziyou/src/player/presentation/controllers/player_controller.dart';
import 'package:desafio_ziyou/src/player/presentation/controllers/player_state.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage>
    with SingleTickerProviderStateMixin {
  final _mediaUrl =
      'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4';
  final _contentVideoType = 'video/mp4';
  final _playerController = getIt.get<PlayerController>()
    ..handleDiscoveryDevices();
  late final _animationIconController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  );
  late final _animationIcon =
      Tween<double>(begin: 0.0, end: 1.0).animate(_animationIconController);
  late final _videoPlayerController = CustomVideoPlayerController.networkUrl(
    _mediaUrl,
    _playerController.handleSeek,
  );
  late final _initializePlayer = _videoPlayerController.initialize();

  bool _isPlayerControllerOpacity = false;

  @override
  void initState() {
    super.initState();
    _playerController.addListener(_playerControllerListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Desafio Ziyou'),
      ),
      body: FutureBuilder<void>(
          future: _initializePlayer,
          builder: (context, snapshot) {
            return switch (snapshot) {
              (AsyncSnapshot snap)
                  when snap.connectionState == ConnectionState.done =>
                Column(
                  children: [
                    _Player(
                      videoPlayerController: _videoPlayerController,
                      onTap: _handlePlay,
                      isPlayerControllerOpacity: _isPlayerControllerOpacity,
                      animationIcon: _animationIcon,
                    ),
                    const SizedBox(height: 64),
                    _ChromeCastButton(playerController: _playerController),
                  ],
                ),
              (AsyncSnapshot snap) when snap.hasError => const Center(
                  child: Text('Ocorreu um erro inesperado'),
                ),
              (_) => const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
            };
          }),
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _animationIconController.dispose();
    _playerController.removeListener(_playerControllerListener);
    _playerController.dispose();
    super.dispose();
  }

  void _handlePlay() {
    if (_videoPlayerController.value.isPlaying) {
      setState(() => _isPlayerControllerOpacity = false);
      _animationIconController.reverse();
      _videoPlayerController.pause();
      _playerController.handlePlayPause(true);
    } else {
      setState(() => _isPlayerControllerOpacity = true);
      _animationIconController.forward();
      _videoPlayerController.play();
      _playerController.handlePlayPause(false);
    }
  }

  void _playerControllerListener() {
    final state = _playerController.value;
    if (state.deviceSessionState.data == DeviceSession.connected) {
      _playerController.handleSetMedia(
        MediaEntity(
          url: _mediaUrl,
          contentType: _contentVideoType,
          isPlaying: _videoPlayerController.value.isPlaying,
          playPosition: _videoPlayerController.value.position,
        ),
      );
    }
  }
}

class _Player extends StatelessWidget {
  const _Player({
    required this.videoPlayerController,
    required this.onTap,
    required this.isPlayerControllerOpacity,
    required this.animationIcon,
  });

  final CustomVideoPlayerController videoPlayerController;
  final VoidCallback onTap;
  final bool isPlayerControllerOpacity;
  final Animation<double> animationIcon;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: videoPlayerController.value.aspectRatio,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          InkWell(
            onTap: onTap,
            child: VideoPlayer(
              videoPlayerController,
            ),
          ),
          VideoProgressIndicator(
            videoPlayerController,
            allowScrubbing: true,
          ),
          Center(
            child: AnimatedOpacity(
              opacity: isPlayerControllerOpacity ? 0 : 1,
              duration: const Duration(seconds: 1),
              child: IconButton(
                onPressed: onTap,
                icon: AnimatedIcon(
                  size: 72,
                  progress: animationIcon,
                  icon: AnimatedIcons.play_pause,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChromeCastButton extends StatelessWidget {
  const _ChromeCastButton({required this.playerController});

  final PlayerController playerController;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<PlayerState>(
      valueListenable: playerController,
      builder: (_, state, __) {
        final sessionStateData = state.deviceSessionState.data;
        var text = 'Conecte um dispositivo';
        if (sessionStateData != null) {
          switch (sessionStateData) {
            case DeviceSession.connected:
              text = 'Dispositivo Conectado - Desconectar';
              break;
            case DeviceSession.connecting:
              text = 'Conectando dispositivo';
              break;
            case DeviceSession.disconnecting:
              text = 'Desconectando dispositivo';
              break;
            case DeviceSession.disconnected:
          }
        }
        final isButtonEnabled = sessionStateData != DeviceSession.connecting &&
            sessionStateData != DeviceSession.disconnecting;
        return OutlinedButton.icon(
          onPressed: isButtonEnabled
              ? () async {
                  if (sessionStateData == DeviceSession.disconnected) {
                    final selectedDevice = await showDialog<Device?>(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text(
                            'Selecione um dispositivo',
                          ),
                          content: _DeviceList(
                            playerController: playerController,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                playerController
                                    .handleFinishConnectionWithDevice();
                                Navigator.pop(context);
                              },
                              child: const Text('Cancelar'),
                            ),
                          ],
                        );
                      },
                    );
                    if (selectedDevice != null) {
                      playerController
                        ..handleStartConnectionWithDevice(selectedDevice)
                        ..handleDeviceSession();
                    }
                    return;
                  }
                  playerController.handleFinishConnectionWithDevice();
                }
              : null,
          label: Text(text),
          icon: const Icon(Icons.cast_outlined),
        );
      },
    );
  }
}

class _DeviceList extends StatelessWidget {
  const _DeviceList({required this.playerController});

  final PlayerController playerController;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<PlayerState>(
      valueListenable: playerController,
      builder: (_, state, __) {
        final discoveryState = state.discoveryDeviceState;
        if (discoveryState is AsyncError<List<Device>>) {
          return const Center(
            child: Text('Ocorreu um erro inesperado'),
          );
        }
        final countDevices = discoveryState.data?.length ?? 0;
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: countDevices + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return const ListTile(
                  leading: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(),
                  ),
                  title: Text('Buscando dispositivos...'),
                );
              }
              final device = discoveryState.data![index - 1];
              return ListTile(
                title: Text(device.name),
                onTap: () => Navigator.pop(context, device),
              );
            },
          ),
        );
      },
    );
  }
}
