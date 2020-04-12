FROM node:11 as builder

COPY yapi.tar.gz /home/
RUN apt-get install -y  git python make openssl tar gcc \
    && mkdir -p /home/yapi \
    && cd /home \
    && tar xf yapi.tar.gz -C /home/yapi --strip-components 1 \
    && mkdir /api \
    && mv /home/yapi /api/vendors \
    && cd /api/vendors \
    && npm install --production --registry https://registry.npm.taobao.org

FROM node:11

MAINTAINER andrew.chen
ENV TZ="Asia/Shanghai" HOME="/"
WORKDIR ${HOME}

COPY --from=builder /api/vendors /api/vendors
COPY config.json /api/
EXPOSE 3001

COPY docker-entrypoint.sh /api/
RUN chmod 755 /api/docker-entrypoint.sh

ENTRYPOINT ["/api/docker-entrypoint.sh"]
