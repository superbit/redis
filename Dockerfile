FROM ubuntu:18.04
MAINTAINER Daniil Pichikin <d.v.pichikin@gmail.com>

## Install wget
RUN apt-get install wget

# Install and configure Redis 3.0
RUN cd /tmp && \
    wget http://download.redis.io/releases/redis-5.0.8.tar.gz && \
    tar xzvf redis-5.0.8.tar.gz && \
    cd redis-5.0.8 && \
    make && \
    make install && \
    mkdir -p /etc/redis && \
    cp -f *.conf /etc/redis && \

    sed -i 's/^\(dir .*\)$/# \1\ndir \/data/' /etc/redis/redis.conf && \

    apt-get install --yes runit && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

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
