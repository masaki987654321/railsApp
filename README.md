# rails + docker + nginx + puma + mysql

## 環境構築手順

- railsの生成　
```console
$ docker-compose run --rm app rails new . --force --database=mysql --skip-bundle
```

- puma.rbの編集
```ruby:puma.rb
threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
threads threads_count, threads_count

# port        ENV.fetch("PORT") { 3000 }

environment ENV.fetch("RAILS_ENV") { "development" }

plugin :tmp_restart

bind "unix://#{Rails.root}/tmp/sockets/puma.sock"
stdout_redirect "#{Rails.root}/log/puma.stdout.log", "#{Rails.root}/log/puma.stderr.log", true
```

- database.ymlの編集
```yml:database.yml
default: &default
  adapter: mysql2
  encoding: utf8
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  username: root
  password: password
  host: db

development:
  <<: *default
  database: railsApp_development

test:
  <<: *default
  database: railsApp_test

production:
  <<: *default
  database: railsApp_production
  username: railsApp
  password: <%= ENV['RAILSAPP_DATABASE_PASSWORD'] %>
```

- イメージのビルド
```console
$ docker-compose build
```

- コンテナの起動
```console
$ docker-compose up -d
```

- DBの作成
```console
$ docker-compose exec app rails db:create
```

- [ブラウザで確認](http:localhost:3000)


### docker-compose upした際に『A server is already running.』と言われたら
 ```console
$ docker-compose exec app rm tmp/pids/server.pid
```

参考にしたもの
https://qiita.com/eighty8/items/0288ab9c127ddb683315#nginx%E8%A8%AD%E5%AE%9A%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB

https://qiita.com/paranishian/items/862ce4de104992df48e1

