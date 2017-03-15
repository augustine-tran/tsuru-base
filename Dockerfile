# Copyright 2015 tsuru authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

FROM phusion/baseimage
RUN	locale-gen en_US.UTF-8
ENV	LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8 DEBIAN_FRONTEND=noninteractive
RUN	mkdir -p /var/lib/tsuru/base
ADD	. /var/lib/tsuru/base
RUN	/var/lib/tsuru/base/install

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