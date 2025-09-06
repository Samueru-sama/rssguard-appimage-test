#!/bin/sh

set -e

ARCH="$(uname -m)"
VERSION="$(cat ~/version)"
URUNTIME="https://raw.githubusercontent.com/pkgforge-dev/Anylinux-AppImages/refs/heads/main/useful-tools/uruntime2appimage.sh"
SHARUN="https://raw.githubusercontent.com/pkgforge-dev/Anylinux-AppImages/refs/heads/main/useful-tools/quick-sharun.sh"

export OUTNAME=rssguard-"$VERSION"-anylinux-"$ARCH".AppImage
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export DESKTOP=/usr/share/applications/io.github.martinrotter.rssguard.desktop
export ICON=/usr/share/icons/hicolor/256x256/apps/io.github.martinrotter.rssguard.png

# Deploy dependencies
wget --retry-connrefused --tries=30 "$SHARUN" -O ./quick-sharun
chmod +x ./quick-sharun
./quick-sharun /usr/bin/rssguard /usr/lib/rssguard/* /usr/lib/qt6/QtWebEngineProcess

# TODO, remove me once quick-sharun adds qtwebengine deployment
cp -rv /usr/share/qt6/resources    ./AppDir/shared/lib/qt6
cp -rv /usr/share/qt6/translations ./AppDir/shared/lib/qt6

# MAKE APPIAMGE WITH URUNTIME
wget --retry-connrefused --tries=30 "$URUNTIME" -O ./uruntime2appimage
chmod +x ./uruntime2appimage
./uruntime2appimage

mkdir -p ./dist
mv -v ./*.AppImage* ./dist
