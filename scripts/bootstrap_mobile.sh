#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../mobile"
flutter pub get
flutter create --platforms=android,ios,web .
