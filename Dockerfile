FROM ruby:2.6.5-alpine AS builder

# install packages
ARG RAILS_ENV='production'
ARG BUILD_PACKAGES='build-base curl-dev git'
ARG DEV_PACKAGES='yaml-dev zlib-dev nodejs yarn'
ARG RUBY_PACKAGES='tzdata'
RUN apk add --no-cache $BUILD_PACKAGES $DEV_PACKAGES $RUBY_PACKAGES

# install rubygem
WORKDIR /app
RUN bundle config set without 'development:test'
COPY Gemfile Gemfile.lock ./
RUN gem install bundler -v $(tail -n1 Gemfile.lock) \
    && bundle config --global frozen 1 \
    && bundle install --jobs=4 --retry=3 \
    # Remove unneeded files (cached *.gem, *.o, *.c)
    && rm -rf $GEM_HOME/cache/*.gem \
    && find $GEM_HOME/gems/ -name '*.c' -delete \
    && find $GEM_HOME/gems/ -name '*.o' -delete

# compile assets
COPY . .
RUN cp config/application.yml.docker config/application.yml
ARG RAILS_ENV='production'
ENV RAILS_ENV=$RAILS_ENV
RUN bundle exec rails assets:precompile

# Remove folders not needed in resulting image
RUN rm -rf tmp/cache vendor/assets spec package.json yarn.lock

############### Build step done ###############

FROM ruby:2.6.5-alpine

# install packages
ARG PACKAGES='tzdata nodejs ncurses'
RUN apk add --no-cache $PACKAGES

# copy files from builder
WORKDIR /app
COPY --from=builder $GEM_HOME $GEM_HOME
COPY --from=builder /app /app

# set environment variables
ARG RAILS_ENV='production'
ENV RAILS_ENV=$RAILS_ENV
ARG TZ='Pacific/Auckland'
ENV TZ=$TZ

EXPOSE 3000

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
