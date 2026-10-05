import 'package:audio_session/audio_session.dart';
import 'package:injectable/injectable.dart';
import 'package:just_audio/just_audio.dart';

@lazySingleton
class MetronomeAudioService {
  MetronomeAudioService();

  final AudioPlayer _player = AudioPlayer();
  String _soundType = 'click';
  bool _ready = false;

  static const _assets = {
    'click': 'assets/sounds/click.wav',
    'wood': 'assets/sounds/wood.wav',
    'digital': 'assets/sounds/digital.wav',
  };

  Future<void> initialize() async {
    if (_ready) return;
    final session = await AudioSession.instance;
    await session.configure(
      const AudioSessionConfiguration(
        avAudioSessionCategory: AVAudioSessionCategory.playback,
        avAudioSessionCategoryOptions:
            AVAudioSessionCategoryOptions.mixWithOthers,
        avAudioSessionMode: AVAudioSessionMode.defaultMode,
        androidAudioAttributes: AndroidAudioAttributes(
          contentType: AndroidAudioContentType.sonification,
          usage: AndroidAudioUsage.media,
        ),
        androidAudioFocusGainType:
            AndroidAudioFocusGainType.gainTransientMayDuck,
      ),
    );
    await setSoundType(_soundType);
    _ready = true;
  }

  Future<void> setSoundType(String soundType) async {
    final asset = _assets[soundType] ?? _assets['click']!;
    _soundType = soundType;
    await _player.setAsset(asset);
  }

  Future<void> playTick({required bool accent}) async {
    try {
      if (!_ready) await initialize();
      await _player.seek(Duration.zero);
      await _player.setVolume(accent ? 1 : 0.65);
      await _player.play();
    } on Object {
      // Audio must never crash the metronome visualizer.
    }
  }

  Future<void> dispose() async {
    await _player.dispose();
  }
}
