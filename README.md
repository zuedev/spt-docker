# single-player-tarkov-docker
Private Dockerfile to build a docker container for Single-Player-Tarkov

# Dependencies

None

Note: SPT-AKI does not work as a subtree (can be used as a .gitmodule) because of lfs. I've decided to pull in the image (with a builder) instead of forking / adding the submodule to this repo, as it is standarized in Dockerfiles as per 2024-04

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
docker build -t cbr/spt:latest -t cbr/spt:your-tag-version-here
```

---


# Old Documentation

Some old documentation if moving to local submodule is desired
## Add a submodule for SPT-Aki
```bash
git submodule add https://dev.sp-tarkov.com/SPT-AKI/Server.git SPT-Server
```

## Retrieve after adding
```bash
git submodule update --init --recursive
```
Note: Needs LFS!
