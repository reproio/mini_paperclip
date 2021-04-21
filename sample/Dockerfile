FROM ruby:3.0.1-slim-buster
WORKDIR /app

RUN apt-get update && apt-get install -y libpq-dev make g++ patch curl \
  && curl -fsSL https://deb.nodesource.com/setup_14.x | bash - \
  && apt-get update && apt-get install -y nodejs \
  && npm install -g yarn

COPY Gemfile Gemfile.lock /app/
RUN bundle install

COPY package.json yarn.lock /app/
RUN yarn install

COPY . .
