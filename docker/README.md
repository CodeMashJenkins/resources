# Docker Image for Jenkins Sandbox

The docker image defined here can be used as a sandbox environment to try out the provided
code samples.  Follow the instructions below for building the image and running a container
based on it.

# Building the sandbox image

After cloning the _resource_ repository, change to this folder and execute the following:

```
docker build --pull -t cmjenkins .
```

The `--pull` parameter ensures that you are using the latest Jenkins release.

NOTE: This image is based on the [official Jenkins Docker image](https://github.com/jenkinsci/docker).
It uses a script provided by the official image to load a predefined set of Jenkins plugins.
Depending on your Internet connection, this script may occasionally fail with the error message
```
Some plugins failed to download!
```
If this should occur, run the build again, potentially multiple times, until all of the plugins
have have loaded.

# Running the sandbox container

The basic command to run the container is:

```
docker run -t cmjenkins
```

This will run the sandbox with the following defaults:
- The default user will be ```admin``` with the password ```admin```.
- The default port for Jenkins will be ```8080```.
- Support for Docker-based agents will not be enabled.
- Jenkins configurations will not persist between runs.

These behaviors can be configured as described in the following sections.

## Configuring the Jenkins userid/password

Add the following parameters to the run command to configure a different admin userid/password
combination:

```
--env JENKINS_USER=_<userid>_ --env JENKINS_PASS=_<password>_
```

## Configuring the Jenkins port

Add the following parameter to the run commend to configure a different IP port for the
Jenkins application:

```
-p _<port>_:8080
```

## Enabling support for Docker-based agents

In order for the sandbox to run Docker containers, map the Docker socket on the container
to point to the host Docker socket.  This can be done using the following parameter:

```
--volume _<host Docker socket>_:/var/run/docker.sock
```

On a Linux host, for example, this parameter would be:

```
--volume /var/run/docker.sock:/var/run/docker.sock
```

See this article on running [Docker in Docker](https://jpetazzo.github.io/2015/09/03/do-not-use-docker-in-docker-for-ci/)
for further information on this approach.

## Persisting Jenkins configurations between runs

By default, ```JENKINS_HOME``` exists within the Docker container and will be reinitialized
each time the container is removed and re-run.  Consequently, any changes made to the Jenkins
configuration will be lost.  If you would like to preserve Jenkins configurations between
runs of the container, add the following parameter to the run command:

```
--volume _<host path>_:/var/jenkins_home
```

## Putting it all together

Following is an example run command that overrides all of the default behaviors:

```
docker run -p 8085:8080 --volume /var/run/docker.sock:/var/run/docker.sock --volume ~/jenkins_sandbox:/var/jenkins_home --env JENKINS_USER=code --env JENKINS_PASS=mash -t cmjenkins
```

# Additional customizations

Because this image is based on the [official Jenkins Docker image](https://github.com/jenkinsci/docker),
its behavior can be further customized as described for the official image.
