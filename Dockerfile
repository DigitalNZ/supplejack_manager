FROM ruby:2.6.5

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

# Add yarn to the packages list
RUN curl -sSL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# Add node to the packages list
RUN curl -sSL https://deb.nodesource.com/setup_12.x | bash -

# Install external packages
RUN apt-get update -qq && apt-get install -y \
    yarn \
    nodejs \
    && rm -rf /var/lib/apt/lists/*

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
