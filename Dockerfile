FROM ruby:2.1.7
RUN apt-get update -qq && apt-get install -y build-essential nodejs npm nodejs-legacy mysql-client vim
RUN npm install -g phantomjs

RUN apt-get install -y g++
# for nokogiri
RUN apt-get install -y libxml2-dev libxslt1-dev

# capybara-webkit
RUN apt-get install -y qt5-default libqt5webkit5-dev

RUN mkdir /manager

# Copy over private key, 又 set permissions
ADD id_rsa /root/.ssh/id_rsa
RUN chmod 700 /root/.ssh/id_rsa
RUN chown -R root:root /root/.ssh

# Create known_hosts
RUN touch /root/.ssh/known_hosts

# Remove host checking
RUN echo "Host github.com\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config

# http://ilikestuffblog.com/2014/01/06/how-to-skip-bundle-install-when-deploying-a-rails-app-to-docker/
WORKDIR /tmp
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
COPY config/mongoid.yml config/mongoid.yml

# Cache bundle install
# ENV BUNDLE_PATH /bundle

RUN bundle install

WORKDIR /manager

ADD . /manager
# CMD bash -c '/manager/boot.sh'