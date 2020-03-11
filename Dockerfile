FROM ruby:2.6.5-alpine AS builder

WORKDIR /app

# install packages
ARG BUILD_PACKAGES="build-base curl-dev git"
ARG DEV_PACKAGES="yaml-dev zlib-dev libxml2-dev libxslt-dev nodejs yarn"
ARG RUBY_PACKAGES="tzdata"
RUN apk add --no-cache $BUILD_PACKAGES $DEV_PACKAGES $RUBY_PACKAGES

# install rubygem
COPY Gemfile Gemfile.lock ./
COPY vendor/cache ./vendor/cache
RUN gem install bundler -v $(tail -n1 Gemfile.lock) \
    && bundle config without development:test \
    && bundle config --global frozen 1 \
    && bundle install --path=vendor/cache --jobs=4 --retry=3 \
    # Remove unneeded files (cached *.gem, *.o, *.c)
    && rm -rf $GEM_HOME/cache/*.gem \
    && find $GEM_HOME/gems/ -name "*.c" -delete \
    && find $GEM_HOME/gems/ -name "*.o" -delete

COPY . .

# compile the assets
ARG RAILS_ENV="production"
ENV RAILS_ENV=$RAILS_ENV
RUN cp config/application.yml.docker config/application.yml
RUN bin/rails assets:precompile

RUN rm -rf tmp/cache vendor/assets spec

############### Build step done ###############

FROM ruby:2.6.5-alpine

WORKDIR /app

# install packages
ARG PACKAGES="build-base tzdata libxslt libxml2-dev libxslt-dev nodejs"
RUN apk add --no-cache $PACKAGES

# get the application code
COPY --from=builder $GEM_HOME $GEM_HOME
COPY --from=builder /app /app

# Change TimeZone
ARG TIMEZONE=Pacific/Auckland
ENV TZ=$TZ
ARG RAILS_ENV="production"
ENV RAILS_ENV=$RAILS_ENV
EXPOSE 3000

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
