# Flutter Wayland SDK in Docker

## Preconditions

- Ubuntu 18.04 LTS

- Install docker and docker compose, and add non-root docker user. 
  - https://docs.docker.com/engine/install/ubuntu/
  - https://docs.docker.com/compose/install/
  - https://docs.docker.com/engine/install/linux-postinstall/

- execute the below command to use x11 in docker.

~~~
$ xhost +
~~~


## How to use

- If you'd like to change your work directory, please edit "setenv.sh"

- build container
~~~
$ . setenv.sh
$ docker-compose build
~~~

- start container
~~~
$ . setenv.sh
$ docker-compose up -d
~~~

- enter/re-enter container
~~~
$ docker-compose exec app /bin/bash
~~~

- stop container
~~~
$ docker-compose down
~~~

# In Docker
~~~
$ flutter_init.sh
~~~

# sample run test
~~~
$ cd work
$ git clone https://github.com/google/flutter-desktop-embedding.git
$ cd flutter-desktop-embedding/testbed
$ flutter run
~~~

# build & exec test 
~~~
$ flutter build linux
$ cd build/linux/debug/bundle/
$ ./testbed
~~~

# weston & flutter wayland
- see flutter_wayland
  https://github.com/HidetoKimura/flutter_wayland
~~~
$ weston --width 800 --height 600 &
$ layer-add-surfaces 1000 10 &
$ ./flutter_wayland ../external/asset_bundle/testbed
~~~

# Docker save & load
~~~
docker save docker_sdk_app | gzip -c > docker_sdk.tar.gz
cat docker_sdk.tar.gz | gzip -d | docker load
~~~
