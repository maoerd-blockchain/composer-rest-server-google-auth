
# Dockerized Composer Rest Server Within MongoDB & Google OAuth2 Support
# Author: Jackie King
# License: Apache License 2.0
FROM node:8-alpine
LABEL maintainer="Wenbo Wang <jackie-1685@163.com>"

# Reset npm logging to default level.
ENV NPM_CONFIG_LOGLEVEL warn

# Install the latest version by default.
ARG VERSION=latest

# Need to install extra dependencies for native modules.
RUN deluser --remove-home node && \
    addgroup -g 1000 composer && \
    adduser -u 1000 -G composer -s /bin/sh -D composer && \
    apk add --no-cache make gcc g++ python git libc6-compat && \
    su -c "npm install npm@latest -g" - composer && \
    su -c "npm config set prefix '/home/composer/.npm-global'" - composer && \
    su -c "npm install --production -g pm2 base64-js ieee754 composer-rest-server@${VERSION} loopback-connector-mongodb passport-google-oauth2" - composer && \
    su -c "npm audit fix" - composer && \
    su -c "npm cache clean --force" - composer && \
    rm -rf /home/composer/.config /home/composer/.node-gyp /home/composer/.npm && \
apk del make gcc g++ python git

RUN ln -s node_modules .node_modules

# Run as the composer user ID.
USER composer

# Add global composer modules to the path.
ENV PATH /home/composer/.npm-global/bin:$PATH

# Run in the composer users home directory.
WORKDIR /home/composer

# Run supervisor to start the application.
CMD [ "pm2-docker", "composer-rest-server" ]

# Expose port 3000.
EXPOSE 3000