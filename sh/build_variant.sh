#!/usr/bin/env bash
fvm flutter pub get
fvm flutter pub run build_variant $1
fvm flutter pub get
fvm flutter pub run flutter_launcher_icons:main