FROM ruby:2.3.8

RUN apt-get update -qq && apt-get install -y \
    build-essential \
    openssh-client \
    libpq-dev \
    apt-transport-https \
    libxml2-dev \
    libxslt1-dev \
    libxslt-dev \
    liblzma-dev \
    curl \
    && rm -rf /var/lib/apt/lists/*

ARG RAILS_ENV
ENV RAILS_ENV=$RAILS_ENV

ARG TIMEZONE
ENV TIMEZONE=$TIMEZONE

RUN echo $TIMEZONE > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata

WORKDIR /tmp
COPY Gemfile .
COPY Gemfile.lock .
RUN gem install bundler
RUN NOKOGIRI_USE_SYSTEM_LIBRARIES=1 bundle install

RUN groupadd -r manager && useradd -r -m -g manager manager

RUN mkdir -p /var/manager

RUN chown -R manager:manager /var/manager
USER manager

WORKDIR /var/manager

COPY --chown=manager:manager . .

RUN mv config/application.yml.docker config/application.yml
RUN RAILS_ENV=$RAILS_ENV bundle exec rails assets:precompile

EXPOSE 3000

RUN find / -perm +6000 -type f -exec chmod a-s {} \; || true

CMD bundle exec puma -C config/puma.rb
