FROM ruby:2.7

## デフォルトの環境変数にproductionを入れておく
ENV RAILS_ENV=production

## 必要ライブラリのインストール
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update -qq \
  && apt-get install -y nodejs yarn
WORKDIR /app
COPY ./src /app
## bundle config --local set path 'vendor/bundle'は、Rubyのライブラリをローカルに置いておく場所を指定？？
RUN bundle config --local set path 'vendor/bundle' \
  && bundle install

## start.shファイルのコピーをdocker側のディレクトリにも用意して
COPY start.sh /start.sh
## そのdocker側のファイルに対して実行権限を与える
RUN chmod 744 /start.sh
## 最後に、dockerfileを起動させるときにコマンド実行
CMD ["sh", "/start.sh"]