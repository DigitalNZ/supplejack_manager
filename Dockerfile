FROM ruby:2.3.8

RUN apt-get update -qq && apt-get install -y build-essential openssh-client libpq-dev apt-transport-https
RUN apt-get install -y libxml2-dev libxslt1-dev libxslt-dev liblzma-dev curl

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

RUN mv config/application.yml.docker config/application.yml
RUN RAILS_ENV=$RAILS_ENV bundle exec rails assets:precompile

EXPOSE 3000

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
