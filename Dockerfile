FROM ubuntu:latest
MAINTAINER hide32767 <hide.in@gmail.com>

#-------------------------------------------------------------------------------

# preconfiguration for installing MongoDB
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
ADD dockerbuild_files/mongodb-org-3.2.list /etc/apt/sources.list.d/

# updating packages
RUN apt-get -yqq update
RUN apt-get -yqq upgrade

# installing packages
RUN apt-get -yqq install apt-utils
RUN apt-get -yqq install \
  git \
  curl \
  bzip2 \
  build-essential \
  patch \
  libreadline-dev \
  libssl-dev \
  libicu-dev \
  libyaml-dev \
  libxml2-dev \
  libxslt1-dev \
  liblzma-dev \
  zlib1g-dev \
  imagemagick \
  libmagickcore-dev \
  libmagickwand-dev \
  nodejs \
  memcached \
  mongodb-org

# after installing packages
RUN apt-get -yqq clean

# trick for nodejs
RUN update-alternatives --install /usr/bin/node node /usr/bin/nodejs 10

# creating locale
RUN locale -a | grep 'ja' || locale-gen ja_JP.UTF-8

#-------------------------------------------------------------------------------

# installing rbenv and ruby-build
RUN git clone git://github.com/sstephenson/rbenv.git /opt/rbenv
RUN git clone git://github.com/sstephenson/ruby-build.git /opt/rbenv/plugins/ruby-build

# copying files for ruby
ADD dockerbuild_files/rbenv.sh /etc/profile.d/
ADD dockerbuild_files/gemrc /etc/

# building ruby
RUN bash -lc 'CONFIGURE_OPTS="--disable-install-rdoc" rbenv install 2.2.4'
RUN bash -lc 'rbenv global 2.2.4'

# installing bundler
RUN bash -lc 'gem update --quiet'
RUN bash -lc 'gem install bundler --quiet'

# creating user who execute web-app
RUN groupadd webapp && useradd -g webapp -m -s /bin/dash webapp

# copying secret files of Pit
RUN su - webapp -c 'mkdir -m 700 /home/webapp/.pit'
ADD dockerbuild_files/default.yaml /home/webapp/.pit/
ADD dockerbuild_files/pit.yaml /home/webapp/.pit/
RUN chmod 600 /home/webapp/.pit/* ; chown webapp:webapp /home/webapp/.pit/*

#-------------------------------------------------------------------------------

# creating a directory for web-app
RUN mkdir -m 755 /srv/webapp && chown webapp:webapp /srv/webapp

# installing massr
RUN su - webapp -c 'git clone https://github.com/tdtds/massr.git /srv/webapp/.'

# copying the definition file for environment of massr
ADD dockerbuild_files/.env /srv/webapp/
RUN chmod 600 /srv/webapp/.env ; chown webapp:webapp /srv/webapp/.env

# installing gems by bundler
RUN su - webapp -c 'mkdir -p /srv/webapp/vendor/bundle'
RUN su - webapp -c 'cd /srv/webapp && . ./.env; bundle install --path vendor/bundle --quiet'

# copying a script file for booting massr
ADD dockerbuild_files/massr_boot.sh /srv/
RUN chmod 700 /srv/massr_boot.sh

ENTRYPOINT ["/srv/massr_boot.sh"]
