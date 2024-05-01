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
RUN apk add git git-lfs
WORKDIR /app
COPY --from=fetch /repo .
WORKDIR /app/project
RUN npm install -g npm@10.5.1
RUN npm install
RUN npm run build:release

FROM alpine as base
RUN apk update && \
    apk --no-cache --update add libgcc libstdc++ libc6-compat wget && \
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

# install fika
RUN wget https://cdn.discordapp.com/attachments/1190050801083760670/1235245300663455864/MPT_HOTFIX_2_0.9.8876.41975.zip?ex=6633ab55&is=663259d5&hm=7a7bdda4309c41ffbfd21f2be1267eefc0fa61aad648bfe88f08be3070380269&
RUN unzip MPT_HOTFIX_2_0.9.8876.41975.zip -d /app/

ENTRYPOINT ["/app/entrypoint.sh"]
