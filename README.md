# avs_sdk

Alexa Voice Service SDK

## Getting started

1. Start the docker container.
 ```
 ./docker_run.sh
 ```

## Trouble shooting

1. Raspberry-pi docker error: standard_init_linux.go:178: exec user process caused “exec format error” on Automated build of DockerHub
This is because Raspberry-pi works on ARM instead of x86 which is on DockerHub.

 - https://stackoverflow.com/questions/42885538/raspberry-pi-docker-error-standard-init-linux-go178-exec-user-process-caused
 - https://stackoverflow.com/questions/43738439/dockerhub-fails-to-build-my-dockerfile
 
This is solved by this article from resin. https://resin.io/blog/building-arm-containers-on-any-x86-machine-even-dockerhub/