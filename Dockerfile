FROM ubuntu:18.04
MAINTAINER Daniil Pichikin <d.v.pichikin@gmail.com>

## Install wget
RUN apt-get install wget build-essential -y

# Install and configure Redis 5.0
RUN cd /tmp
RUN wget http://download.redis.io/releases/redis-5.0.8.tar.gz
RUN tar xzvf redis-5.0.8.tar.gz
RUN cd redis-5.0.8
RUN make
RUN make install
RUN mkdir -p /etc/redis
RUN cp -f *.conf /etc/redis

RUN sed -i 's/^\(dir .*\)$/# \1\ndir \/data/' /etc/redis/redis.conf

RUN apt-get install --yes runit
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

## remove wget
RUN apt-get remove wget -y

# Add scripts
ADD scripts /scripts
RUN chmod +x /scripts/*.sh
RUN touch /.firstrun

# Command to run
ENTRYPOINT ["/scripts/run.sh"]
CMD [""]

# Expose listen port
EXPOSE 6379

# Expose our data
VOLUME ["/data"]

