# Copyright 2015 tsuru authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

FROM phusion/baseimage
RUN	locale-gen en_US.UTF-8
ENV	LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8 DEBIAN_FRONTEND=noninteractive
RUN	mkdir -p /var/lib/tsuru/base
ADD	. /var/lib/tsuru/base
RUN	/var/lib/tsuru/base/install

RUN curl -s https://packagecloud.io/install/repositories/phalcon/stable/script.deb.sh | bash

RUN	\
	apt-get update \
	&&	apt-get -y upgrade \
	&&	apt-get update --fix-missing

RUN \
  	apt-get install -y \
	    php7.0 \
	    php7.0-bcmath \
	    php7.0-cli \
	    php7.0-common \
	    php7.0-fpm \
	    php7.0-gd \
	    php7.0-gmp \
	    php7.0-intl \
	    php7.0-json \
	    php7.0-mbstring \
	    php7.0-mcrypt \
	    php7.0-mysqlnd \
	    php7.0-opcache \
	    php7.0-pdo \
	    php7.0-xml \
	    php7.0-phalcon

RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer
RUN service php7.0-fpm start

RUN \
  	apt-get install -y \
	    nodejs \
	    npm \
	    git

RUN \
  	apt-get install -y \
	    nginx-full \
	    supervisor

RUN apt-get clean
RUN apt-get autoclean

COPY build/.bashrc /root/.bashrc
COPY build/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY build/nginx.conf /etc/nginx/sites-enabled/default
COPY build/php.ini /etc/php/7.0/fpm/php.ini

RUN cp /var/lib/tsuru/base/deploy /var/lib/tsuru/deploy
EXPOSE 80 443
CMD ["php-fpm7.0", "-F"]