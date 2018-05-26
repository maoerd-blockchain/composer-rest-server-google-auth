
# Dockerized Composer Rest Server Within MongoDB & Google OAuth2 Support
# Author: Jackie King
# License: Apache License 2.0
FROM hyperledger/composer-rest-server
LABEL maintainer="Wenbo Wang <jackie-1685@163.com>"

RUN npm install --production loopback-connector-mongodb passport-google-oauth2 && \
npm cache clean --force && \
ln -s node_modules .node_modules