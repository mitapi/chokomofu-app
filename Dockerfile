FROM ruby:3.2.2
ENV LANG=C.UTF-8 
ENV TZ=Asia/Tokyo

RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
&& apt-get update -qq \
&& apt-get install -y --no-install-recommends build-essential nodejs \
&& npm i -g yarn \
&& apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle config set without 'production' \
&& bundle install

COPY package.json yarn.lock ./
RUN [ -f package.json ] && yarn install --frozen-lockfile || true

COPY . .

RUN gem install foreman -N

#CMDは書かない（compose の command で bin/dev を実行）
