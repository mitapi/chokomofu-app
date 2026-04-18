#!/usr/bin/env bash
set -euo pipefail

# Rails が残しがちな PID を掃除（再起動時に大事）
mkdir -p tmp/pids log
rm -f tmp/pids/server.pid

# production をデフォルトに
export RAILS_ENV="${RAILS_ENV:-production}"

# デプロイ時にseedを走らせる（これがなくて前は本番だけseedが更新されなかった）
echo "[boot] running db:migrate"
bin/rails db:migrate

echo "[boot] running db:seed"
bin/rails db:seed

# 最後にアプリを起動。CMD/引数があればそれを使い、無ければ Puma を起動
if [ "$#" -gt 0 ]; then
  echo "[boot] exec: $*"
  exec "$@"
else
  echo "[boot] exec: bundle exec puma -C config/puma.rb"
  exec bundle exec puma -C config/puma.rb
fi