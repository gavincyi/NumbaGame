import 'package:flutter/services.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  bool _isMusicEnabled = true;
  bool _isSfxEnabled = true;

  bool get isMusicEnabled => _isMusicEnabled;
  bool get isSfxEnabled => _isSfxEnabled;

  Future<void> initialize() async {
    // Using system sounds only - no external plugin needed
    print('Audio service initialized with system sounds');
  }

  Future<void> playBackgroundMusic() async {
    if (!_isMusicEnabled) return;
    // Background music disabled for now
    print('Background music would play here');
  }

  Future<void> stopBackgroundMusic() async {
    // No-op for system sounds
  }

  Future<void> pauseBackgroundMusic() async {
    // No-op for system sounds
  }

  Future<void> resumeBackgroundMusic() async {
    // No-op for system sounds
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
    // System sounds volume is controlled by device
  }

  void setSfxVolume(double volume) {
    // System sounds volume is controlled by device
  }

  Future<void> dispose() async {
    // No resources to dispose for system sounds
  }
}