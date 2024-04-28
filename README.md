# single-player-tarkov-docker
Private Dockerfile to build a docker container for Single-Player-Tarkov

[README на Русском языке](https://dev.sp-tarkov.com/Allastor/spt-docker/src/commit/cef2043b944d486d4e92639d8fc455600ef4d84a/README.ru)

## Requirements

Debian or another Linux distr\
Docker\
git [LFS](https://git-lfs.github.com/)

# Docker Support

## Volumes
Two volumes are added:
- `/app/Aki_Data/Server` contains standard `SPT-Aki.Server` database and configuration files. For example, `http.json` or `profiles.json`
    The container will copy standard Aki Server files to this volume if emty (i.e. mounted by the very first time)
- `/app/user` with the standard server configuration (will be created on first login)
    - `./profiles` contains the player profiles created
    - `./mods` installed server mods go here
    - `./logs` server logs will appear here

## Enviroment Variables
- `SPT_LOG_REQUESTS` when false, disables SPT-AKI Request Logging
- `SPT_BACKEND_IP` when present, used in `http.conf` as `backendIp` property

Feel free to play yourself with the different setups and configs.

# How to build

Update `SPT_VERSION` Dockerfile ARG with the desired tag
You can look for the most recent tag with `git describe --tags --abbrev=0`
The way SPT is organizing their release is by tags on  release branches. 3.8.0 was not released as a tag on `master` as it was done before. 
Note: It can be a good idea to evolve the Dockerfile to include SPT_VERSION for the branch and always use latest tag) 

```bash
git clone https://dev.sp-tarkov.com/Cbr/spt-docker.git
cd spt-docker
docker buildx build -f Dockerfile -t cbr/spt:latest ./
```

# Running

```bash
mkdir /opt/spt-aki && mkdir /opt/spt-aki/Server && mkdir /opt/spt-aki/user
docker run --name spt-aki -v /opt/spt-aki/Server:/app/Aki_Data/Server -v /opt/spt-aki/user:/app/user -e SPT_LOG_REQUESTS=false -e SPT_BACKEND_IP='External ip' -p 6969:6969 cbr/spt:latest -d
```
\

Where "External IP" - this is the IP address you need - your external IP, local host IP address or received in the VPN network.\

---