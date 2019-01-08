# FROM ruby:2.3.1
#
# RUN apt-get update -qq && apt-get install -y build-essential openssh-client libpq-dev apt-transport-https
# RUN apt-get install -y libxml2-dev libxslt1-dev libxslt-dev liblzma-dev curl
#
# ARG RAILS_ENV
# ENV RAILS_ENV=$RAILS_ENV
#
# ARG TIMEZONE
# ENV TIMEZONE=$TIMEZONE
#
# RUN echo $TIMEZONE > /etc/timezone
# RUN dpkg-reconfigure -f noninteractive tzdata
#
# RUN mkdir -p /var/tmp
# WORKDIR /var/tmp
# COPY Gemfile .
# COPY Gemfile.lock .
# RUN gem install bundler
# RUN NOKOGIRI_USE_SYSTEM_LIBRARIES=1 bundle install
#
# RUN mkdir -p /var/manager
# WORKDIR /var/manager
# COPY . .
#
# RUN mv config/application.yml.docker config/application.yml
# RUN RAILS_ENV=$RAILS_ENV bundle exec rails assets:precompile
#
# EXPOSE 3000
#
# CMD bundle exec puma -C config/puma.rb

FROM phusion/passenger-ruby23

RUN apt-get update -qq && apt-get install -y build-essential openssh-client libpq-dev apt-transport-https
RUN apt-get install -y libxml2-dev libxslt1-dev libxslt-dev liblzma-dev curl tzdata

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Start Nginx / Passenger
RUN rm -f /etc/service/nginx/down

# Remove the default site
RUN rm /etc/nginx/sites-enabled/default

# Expose NGINX HTTP service
EXPOSE 80

ADD nginx.conf /etc/nginx/sites-enabled/webapp.conf
ADD rails-env.conf /etc/nginx/main.d/rails-env.conf

ARG RAILS_ENV
ENV RAILS_ENV=$RAILS_ENV

ARG TIMEZONE
ENV TIMEZONE=$TIMEZONE

RUN echo $TIMEZONE > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata

RUN mkdir -p /var/tmp
WORKDIR /var/tmp
COPY Gemfile .
COPY Gemfile.lock .
RUN gem install bundler
RUN NOKOGIRI_USE_SYSTEM_LIBRARIES=1 bundle install

RUN mkdir -p /var/manager
WORKDIR /var/manager
COPY . .

# RUN chown -R app:app /var/manager

RUN mv config/application.yml.docker config/application.yml
RUN RAILS_ENV=$RAILS_ENV bundle exec rails assets:precompile

# Clean up APT and bundler when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
