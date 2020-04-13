FROM ruby:2.5.1

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /railsApp
WORKDIR /railsApp
ADD Gemfile /railsApp/Gemfile
ADD Gemfile.lock /railsApp/Gemfile.lock
RUN bundle install
ADD . /railsApp

# puma.sockを配置するディレクトリを作成
RUN mkdir -p tmp/sockets