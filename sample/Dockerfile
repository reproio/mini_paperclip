FROM ruby:3.0.1-slim-buster
WORKDIR /mini_paperclip/app

RUN apt-get update && apt-get install -y libpq-dev make g++ git curl shared-mime-info \
  && curl -fsSL https://deb.nodesource.com/setup_14.x | bash - \
  && apt-get update && apt-get install -y nodejs \
  && npm install -g yarn

COPY mini_paperclip.gemspec /mini_paperclip/
COPY lib /mini_paperclip/lib/
COPY sample/Gemfile sample/Gemfile.lock /mini_paperclip/app/
RUN bundle install

COPY sample/package.json sample/yarn.lock /mini_paperclip/app/
RUN yarn install

COPY sample .
