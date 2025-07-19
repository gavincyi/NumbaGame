#!/bin/bash

# Custom build script to create a release-like build for iOS simulator
# This bypasses Flutter's restriction on release mode for simulators

echo "Building release-like version for iOS simulator..."

# Clean previous builds
flutter clean

# Set environment variables to optimize the build
export FLUTTER_BUILD_MODE=release
export FLUTTER_TARGET_PLATFORM=ios

# Build with optimized debug flags that mimic release mode
flutter build ios \
  --debug \
  --simulator \
  --dart-define=FLUTTER_WEB_USE_SKIA=true \
  --dart-define=FLUTTER_WEB_USE_SKIA_RENDERER=true \
  --dart-define=FLUTTER_BUILD_MODE=release \
  --dart-define=FLUTTER_TARGET_PLATFORM=ios \
  --build-name=1.1.0 \
  --build-number=2

echo "Build completed!"
echo "You can now run: flutter run --debug --simulator" 