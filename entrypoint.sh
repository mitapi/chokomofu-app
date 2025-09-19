#!/usr/bin/env bash
set -e

# Rails が残しがちな PID を掃除（再起動時に大事）
mkdir -p tmp/pids log
rm -f tmp/pids/server.pid

# （必要になったら前処理をここに足せる）
exec "$@"