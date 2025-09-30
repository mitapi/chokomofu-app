cat config/master.key
ls -l config/master.key
exit
cd /app && ls -la
find ~ -type f -name 'master.key' 2>/dev/null
ls -l config/credentials
cd /app && ls -la
ls -l config/master.key 2>/dev/null
ls -l config/credentials 2>/dev/null
ls -l config/credentials/*.key 2>/dev/null
find /app -maxdepth 3 -type f \( -name 'master.key' -o -name '*.key' \) 2>/dev/null
EDITOR="nano" bin/rails credentials:edit || EDITOR="nano" bundle exec rails credentials:edit
bin/rails secret || bundle exec rails secret
cd /app
ls -l config/master.key config/credentials.yml.enc
EDITOR="vi" bundle exec rails credentials:edit
cd /app && ls -l Gemfile
ls -l config/master.key config/credentials.yml.enc
cp config/credentials.yml.enc config/credentials.yml.enc.bak 2>/dev/null || true
rm -f config/credentials.yml.enc
EDITOR="vi" bundle exec rails credentials:edit
bundle exec rails r 'puts Rails.application.credentials.secret_key_base.present? ? "OK" : "NG"'
cat config/master.key
exit
