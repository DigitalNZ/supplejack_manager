FROM ruby:2.7.2-alpine AS builder

WORKDIR /app

# install packages
ARG BUILD_PACKAGES="build-base curl-dev git"
ARG DEV_PACKAGES="yaml-dev zlib-dev libxml2-dev libxslt-dev nodejs yarn"
ARG RUBY_PACKAGES="tzdata shared-mime-info"
RUN apk add --no-cache $BUILD_PACKAGES $DEV_PACKAGES $RUBY_PACKAGES

# install rubygem
COPY Gemfile Gemfile.lock ./
COPY vendor/cache ./vendor/cache
COPY node_modules ./node_modules
COPY public/assets ./public/assets
RUN gem install bundler -v $(tail -n1 Gemfile.lock) \
    && bundler config without 'development:test' \
    && bundle config frozen 1 \
    && bundle install --path=vendor/cache --jobs=4 --retry=3 \
    # Remove unneeded files (cached *.gem, *.o, *.c)
    && rm -rf $GEM_HOME/cache/*.gem \
    && find $GEM_HOME/gems/ -name "*.c" -delete \
    && find $GEM_HOME/gems/ -name "*.o" -delete

COPY package.json yarn.lock ./
RUN yarn install --production

COPY . .

# compile the assets
ARG RAILS_ENV="production"
ENV RAILS_ENV=$RAILS_ENV
RUN bin/rails assets:precompile

RUN rm -rf tmp/cache vendor/assets spec node_modules

############### Build step done ###############

FROM ruby:2.7.2-alpine

WORKDIR /app

# install packages
ARG PACKAGES="build-base tzdata libxslt libxml2-dev libxslt-dev nodejs"
RUN apk add --no-cache $PACKAGES

COPY --from=ruby:3.0.0-buster /usr/share/mime/packages/freedesktop.org.xml /usr/share/mime/packages/

# get the application code
COPY --from=builder $GEM_HOME $GEM_HOME
COPY --from=builder /app /app

# Change TimeZone
ARG TIMEZONE="Pacific/Auckland"
ENV TIMEZONE=$TIMEZONE
ENV TZ=$TIMEZONE
ARG RAILS_ENV="production"
ENV RAILS_ENV=$RAILS_ENV
EXPOSE 3000

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
