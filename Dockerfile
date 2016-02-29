FROM ruby:2.1.4
RUN apt-get update -qq && apt-get install -y build-essential nodejs npm nodejs-legacy mysql-client vim openssh-client 
RUN npm install -g phantomjs-prebuilt

RUN apt-get install -y g++

# For nokogiri
RUN apt-get install -y libxml2-dev libxslt1-dev libxslt-dev liblzma-dev curl

# capybara-webkit
RUN apt-get install -y qt5-default libqt5webkit5-dev

# Utilities
RUN apt-get install -y nmap htop

# Use libxml2, libxslt a packages from alpine for building nokogiri
RUN bundle config build.nokogiri --use-system-libraries

RUN mkdir /manager

# CMD ssh-keygen -q -t rsa -N '' -f /root/.ssh/id_rsa

# http://ilikestuffblog.com/2014/01/06/how-to-skip-bundle-install-when-deploying-a-rails-app-to-docker/
WORKDIR /tmp
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
COPY config/mongoid.yml config/mongoid.yml

# Cache bundle install
ENV BUNDLE_PATH /bundle

RUN bundle install
WORKDIR /manager
ADD . /manager