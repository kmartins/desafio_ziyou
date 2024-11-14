import 'package:desafio_ziyou/src/player/domain/services/streaming_device_service.dart';
import 'package:desafio_ziyou/src/player/domain/usecases/usecases.dart';
import 'package:desafio_ziyou/src/player/external/drivers/chrome_cast_driver.dart';
import 'package:desafio_ziyou/src/player/infra/services/streaming_device_service_impl.dart';
import 'package:desafio_ziyou/src/player/presentation/controllers/player_controller.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

const String _chromeCastPlayerChannelName = 'br.com.ziyou/player_chrome_cast';
const String _sessionChromeCastChannelName = 'br.com.ziyou/chrome_cast_session';
const String _discoveryChromeCastChannelName =
    'br.com.ziyou/discovery_chrome_cast';

void injection() {
  getIt.registerLazySingleton<ChromeCastDriver>(
    () => const ChromeCastDriver(
      playerChromeCastChannel: MethodChannel(_chromeCastPlayerChannelName),
      sessionChromeCastEventChannel:
          EventChannel(_sessionChromeCastChannelName),
      discoveryChromeCastEventChannel:
          EventChannel(_discoveryChromeCastChannelName),
    ),
  );
  getIt.registerLazySingleton<StreamingDeviceService>(
    () =>
        StreamingDeviceServiceImpl(chromeCastDriver: getIt<ChromeCastDriver>()),
  );
  getIt.registerLazySingleton<ConnectDevice>(
    () => ConnectDevice(getIt<StreamingDeviceService>()),
  );
  getIt.registerLazySingleton<DiscoveryDevice>(
    () => DiscoveryDevice(getIt<StreamingDeviceService>()),
  );
  getIt.registerLazySingleton<EndConnectionDevice>(
    () => EndConnectionDevice(getIt<StreamingDeviceService>()),
  );
  getIt.registerLazySingleton<PlayPauseMedia>(
    () => PlayPauseMedia(getIt<StreamingDeviceService>()),
  );
  getIt.registerLazySingleton<SeekTo>(
      () => SeekTo(getIt<StreamingDeviceService>()));
  getIt.registerLazySingleton<SendMediaToDevice>(
    () => SendMediaToDevice(getIt<StreamingDeviceService>()),
  );
  getIt.registerLazySingleton<ListenSession>(
    () => ListenSession(getIt<StreamingDeviceService>()),
  );
  getIt.registerFactory<PlayerController>(
    () => PlayerController(
      connectDevice: getIt.get<ConnectDevice>(),
      discoveryDevice: getIt.get<DiscoveryDevice>(),
      endConnectionDevice: getIt.get<EndConnectionDevice>(),
      playPauseMedia: getIt.get<PlayPauseMedia>(),
      seekTo: getIt.get<SeekTo>(),
      sendMediaToDevice: getIt.get<SendMediaToDevice>(),
      listenSession: getIt.get<ListenSession>(),
    ),
  );
}
