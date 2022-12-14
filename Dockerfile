# Version: 11
# Builder
FROM --platform=$BUILDPLATFORM node:16-buster as builder

# Support custom branches of the react-sdk and js-sdk. This also helps us build
# images of element-web develop.
ARG USE_CUSTOM_SDKS=false
ARG REACT_SDK_REPO="https://github.com/mfshiu/vesta-react-sdk.git"
ARG REACT_SDK_BRANCH="main"
ARG JS_SDK_REPO="https://github.com/mfshiu/vesta-js-sdk.git"
ARG JS_SDK_BRANCH="main"

RUN apt-get update && apt-get install -y git dos2unix

WORKDIR /src

COPY . /src
# 執行開發環境的連結：react-sdk & js-sdk
RUN dos2unix /src/scripts/docker-link-repos.sh && bash /src/scripts/docker-link-repos.sh
RUN yarn --network-timeout=100000 install

RUN dos2unix /src/scripts/docker-package.sh && bash /src/scripts/docker-package.sh

# Copy the config now so that we don't create another layer in the app image
RUN cp /src/config.tprai.json /src/webapp/config.json
# RUN cp /src/config.sample.json /src/webapp/config.json

# RUN mv /src/webapp /webapp
# RUN rm -rf /src

# FROM ubuntu
# COPY --from=builder /src/webapp /app 
# CMD ["echo Hello_vChat"]

# App
FROM nginx:alpine

COPY --from=builder /src/webapp /app

# Override default nginx config
COPY /nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf

RUN rm -rf /usr/share/nginx/html \
  && ln -s /app /usr/share/nginx/html