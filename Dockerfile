FROM ruby:3.1.3-alpine3.16

ARG INSTALL_PATH=/app
ARG RAILS_ENV=production
ARG DATABASE_URL=postgresql://user:pass@127.0.0.1/dbname
ARG SECRET_TOKEN=dummytoken

RUN mkdir -p $INSTALL_PATH

WORKDIR $INSTALL_PATH

COPY . .

RUN apk add --update build-base git libpq-dev && \
    apk add gcompat && \
    gem install bundler && \
    bundle install && \
    bundle binstubs --all && \
    bundle exec rake assets:precompile && \
    rm -rf tmp && \
    apk del build-base git && \
    rm -rf /var/cache/apk/*

ENV PORT 8080

EXPOSE 8080

CMD puma -C /app/config/puma.rb
