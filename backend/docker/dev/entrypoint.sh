#!/bin/sh
set -u

SOURCES="/app/backend/routes /app/backend/lib /app/backend/main.dart /app/backend/pubspec.yaml /app/core/lib /app/core/pubspec.yaml"

fingerprint() {
  find $SOURCES -type f \( -name '*.dart' -o -name 'pubspec.yaml' \) 2>/dev/null \
    | sort | xargs md5sum | md5sum
}

stop_server() {
  kill -INT "$1" 2>/dev/null
  wait "$1" 2>/dev/null
  pkill -f '.dart_frog/server.dart' 2>/dev/null
}

trap 'stop_server "${server:-0}"; exit 0' INT TERM

cd /app/backend
while true; do
  dart pub get >/dev/null || echo "✗ dart pub get failed"
  dart_frog dev --hostname 0.0.0.0 --port 8080 &
  server=$!
  current=$(fingerprint)
  while [ "$(fingerprint)" = "$current" ]; do
    sleep 1
  done
  echo "↻ source changed, restarting the server"
  stop_server "$server"
done
