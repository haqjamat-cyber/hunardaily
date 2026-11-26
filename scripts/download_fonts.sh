#!/usr/bin/env bash
# Optional helper script to download open-source Google Noto fonts (SIL OFL)
# for offline bundling if you want custom Nastaliq/Devanagari/Bengali fonts
# inside the APK in addition to Android's built-in Noto system fonts.

set -euo pipefail

FONT_DIR="assets/fonts"
mkdir -p "$FONT_DIR"

echo "Downloading open-source Noto fonts into $FONT_DIR..."
curl -fsSL "https://github.com/notofonts/noto-fonts/raw/main/hinted/ttf/NotoSans/NotoSans-Regular.ttf" -o "$FONT_DIR/NotoSans-Regular.ttf"
curl -fsSL "https://github.com/notofonts/noto-fonts/raw/main/hinted/ttf/NotoSans/NotoSans-Bold.ttf" -o "$FONT_DIR/NotoSans-Bold.ttf"
curl -fsSL "https://github.com/notofonts/noto-fonts/raw/main/hinted/ttf/NotoSansDevanagari/NotoSansDevanagari-Regular.ttf" -o "$FONT_DIR/NotoSansDevanagari-Regular.ttf"
curl -fsSL "https://github.com/notofonts/noto-fonts/raw/main/hinted/ttf/NotoSansBengali/NotoSansBengali-Regular.ttf" -o "$FONT_DIR/NotoSansBengali-Regular.ttf"
curl -fsSL "https://github.com/notofonts/noto-fonts/raw/main/hinted/ttf/NotoNaskhArabic/NotoNaskhArabic-Regular.ttf" -o "$FONT_DIR/NotoNaskhArabic-Regular.ttf"
curl -fsSL "https://github.com/notofonts/noto-fonts/raw/main/hinted/ttf/NotoNastaliqUrdu/NotoNastaliqUrdu-Regular.ttf" -o "$FONT_DIR/NotoNastaliqUrdu-Regular.ttf"

echo "Done. Remember to register downloaded fonts in pubspec.yaml if you bundle them."
