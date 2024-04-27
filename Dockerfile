FROM alpine as git
RUN apk add git git-lfs

FROM git as fetch
ARG SPT_VERSION=3.8.0
WORKDIR /repo
RUN git clone https://dev.sp-tarkov.com/SPT-AKI/Server.git . && \
    git checkout tags/$SPT_VERSION && \
    git lfs fetch  && \
    git lfs pull

FROM node:20.11.1-alpine AS builder
WORKDIR /app
RUN apk add git git-lfs
COPY --from=fetch /repo .
WORKDIR /app/project
RUN npm install -g npm@10.5.1
RUN npm install
RUN npm run build:release

FROM alpine as base
RUN apk update && \
    apk --no-cache --update add libgcc libstdc++ libc6-compat && \
    rm -rf /var/cache/apk/*

From base
WORKDIR /app
COPY --from=builder /app/project/build /app
RUN cp -R /app/Aki_Data/Server /app/Aki_Data/Server.backup
RUN mkdir -p /app/BepInEx/plugins
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh
VOLUME /app/user
VOLUME /app/Aki_Data/Server
ENTRYPOINT ["/app/entrypoint.sh"]
