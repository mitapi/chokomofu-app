#!/usr/bin/env bash
set -euo pipefail

# Rails が残しがちな PID を掃除（再起動時に大事）
mkdir -p tmp/pids log
rm -f tmp/pids/server.pid

# production をデフォルトに
export RAILS_ENV="${RAILS_ENV:-production}"

echo "[boot] db:migrate..."
bin/rails db:migrate

# 種データは冪等（find_or_create_by!/update!）と伺っているので毎回でも安全
echo "[boot] db:seed..."
bin/rails db:seed

echo "[boot] assets:precompile..."
bin/rails assets:precompile

# 最後にアプリを起動。CMD/引数があればそれを使い、無ければ Puma を起動
if [ "$#" -gt 0 ]; then
  echo "[boot] exec: $*"
  exec "$@"
else
  echo "[boot] exec: bundle exec puma -C config/puma.rb"
  exec bundle exec puma -C config/puma.rb
fi