import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _backgroundPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();

  bool _isMusicEnabled = true;
  bool _isSfxEnabled = true;
  bool _audioInitialized = false;

  bool get isMusicEnabled => _isMusicEnabled;
  bool get isSfxEnabled => _isSfxEnabled;

  Future<void> initialize() async {
    try {
      await _backgroundPlayer.setReleaseMode(ReleaseMode.loop);
      await _sfxPlayer.setReleaseMode(ReleaseMode.stop);
      _audioInitialized = true;
    } catch (e) {
      print('Audio initialization failed: $e');
      _audioInitialized = false;
    }
  }

  Future<void> playBackgroundMusic() async {
    if (!_isMusicEnabled || !_audioInitialized) return;
    
    // For now, we'll skip background music to avoid errors
    // In a real app, you would add actual music files to assets/audio/
    print('Background music would play here');
  }

  Future<void> stopBackgroundMusic() async {
    if (!_audioInitialized) return;
    try {
      await _backgroundPlayer.stop();
    } catch (e) {
      print('Failed to stop background music: $e');
    }
  }

  Future<void> pauseBackgroundMusic() async {
    if (!_audioInitialized) return;
    try {
      await _backgroundPlayer.pause();
    } catch (e) {
      print('Failed to pause background music: $e');
    }
  }

  Future<void> resumeBackgroundMusic() async {
    if (!_isMusicEnabled || !_audioInitialized) return;
    try {
      await _backgroundPlayer.resume();
    } catch (e) {
      print('Failed to resume background music: $e');
    }
  }

  Future<void> playCardSound() async {
    if (!_isSfxEnabled) return;
    
    // Use system sound instead of custom audio file
    try {
      await SystemSound.play(SystemSoundType.click);
    } catch (e) {
      print('Failed to play card sound: $e');
    }
  }

  Future<void> playDrawSound() async {
    if (!_isSfxEnabled) return;
    
    try {
      await SystemSound.play(SystemSoundType.click);
    } catch (e) {
      print('Failed to play draw sound: $e');
    }
  }

  Future<void> playWinSound() async {
    if (!_isSfxEnabled) return;
    
    try {
      // Use a different system sound for winning
      await SystemSound.play(SystemSoundType.alert);
    } catch (e) {
      print('Failed to play win sound: $e');
    }
  }

  void toggleMusic() {
    _isMusicEnabled = !_isMusicEnabled;
    if (_isMusicEnabled) {
      playBackgroundMusic();
    } else {
      pauseBackgroundMusic();
    }
  }

  void toggleSfx() {
    _isSfxEnabled = !_isSfxEnabled;
  }

  void setMusicVolume(double volume) {
    if (_audioInitialized) {
      _backgroundPlayer.setVolume(volume);
    }
  }

  void setSfxVolume(double volume) {
    if (_audioInitialized) {
      _sfxPlayer.setVolume(volume);
    }
  }

  Future<void> dispose() async {
    if (_audioInitialized) {
      try {
        await _backgroundPlayer.dispose();
        await _sfxPlayer.dispose();
      } catch (e) {
        print('Failed to dispose audio players: $e');
      }
    }
  }
}