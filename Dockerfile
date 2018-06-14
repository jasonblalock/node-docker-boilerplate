FROM node:8-alpine

ENV YARN_VERSION 1.7.0

RUN apk add --no-cache --virtual .build-deps-yarn curl gnupg tar \
    && for key in \
      6A010C5166006599AA17F08146C2130DFD2497F5 \
    ; do \
      gpg --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "$key" || \
      gpg --keyserver hkp://ipv4.pool.sks-keyservers.net --recv-keys "$key" || \
      gpg --keyserver hkp://pgp.mit.edu:80 --recv-keys "$key" ; \
    done \
    && curl -fSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz" \
    && curl -fSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz.asc" \
    && gpg --batch --verify yarn-v$YARN_VERSION.tar.gz.asc yarn-v$YARN_VERSION.tar.gz \
    && mkdir -p /opt \
    && rm -rf /opt/yarn* \
    && rm /usr/local/bin/yarn /usr/local/bin/yarnpkg \
    && tar -xzf yarn-v$YARN_VERSION.tar.gz -C /opt/ \
    && ln -s /opt/yarn-v$YARN_VERSION/bin/yarn /usr/local/bin/yarn \
    && ln -s /opt/yarn-v$YARN_VERSION/bin/yarnpkg /usr/local/bin/yarnpkg \
    && rm yarn-v$YARN_VERSION.tar.gz.asc yarn-v$YARN_VERSION.tar.gz \
    && apk del .build-deps-yarn

RUN apk update \
    && apk upgrade \
    && apk add --no-cache vim

ENV APP_HOME=/app \
    YARN_CACHE_FOLDER=/home/node/.cache/yarn \
    YARN_PREFIX=/home/node/.yarn-global \
    NETLIFY_FOLDER=/home/node/.netlify

ENV PATH=$PATH:$YARN_PREFIX/bin

RUN mkdir -p $APP_HOME \
    && chown -R node:node $APP_HOME \
    && chmod 755 $APP_HOME

USER node

COPY ./entrypoint.sh /home/node/

RUN mkdir -p $YARN_CACHE_FOLDER $NETLIFY_FOLDER $YARN_PREFIX

WORKDIR $APP_HOME
