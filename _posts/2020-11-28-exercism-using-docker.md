---
layout: post
title:  "Running exercism inside a docker container"
date:   2020-11-28 21:30:00 +0000
categories:
  - "Docker"
  - "Learning"
excerpt: >-
  exercism.io is a nice project to learn programming languages. It has a command-line utility called exercism and
  in this post I will configure a docker container to run it.
cover_image_alt: "exercism_logo_on_container"  
cover_image: "post_headers/exercism_inside_a_docker_container.jpg"
image: "/assets/images/cards/exercism_inside_a_docker_container_card.jpg"  

---

## TL;DR

[exercism.io](https://www.exercism.io) is a nice place to learn programming languages. It has a command-line
tool to download and upload the exercises. In this post, I configure a docker image and run 
`exercism` inside a container.

## Docker concepts involved

Running `exercism` inside docker gives us a great opportunity to learn and practice a few docker concepts. 
I've already talked about why I'm using docker as much as possible, even when it's
overkill (like in this example). If you want to know about it, you can 
[read about it in this post]({% link _posts/2020-10-13-about-this-blog-docker.md %}).


If you follow the example, you will need to dig deeper into the following docker concepts:

* Build custom docker images using a `Dockerfile`
* Build arguments
* Differences between images and containers
* Run containers
* Bind volumes
* Bind volumes and file ownership/permissions

Explaining these docker concepts is out of the scope of this post, so I will not go into the details of any of them.

## Before you start..

You should be able to run all the commands that I use in this article in the following systems:
* Windows 10 + WSL2 (I used the Ubuntu 20.04LTS image) and Docker for Windows installed
* Any Linux distribution with Docker installed
* Mac OS and Docker for Mac installed

You will also need an account in the `exercism.io` website to be able to download an exercise.

## About `exercism.io`

Before we start, what is `exercism.io`? Developed initially by 
the one and only [Katrina Owen](http://www.kytrinyx.com), it's a 
community-driven site with the goal of helping people improve their coding skills.

> Code practice and mentorship for everyone
>
> Level up your programming skills with 3,442 exercises across 52 languages, 
> and insightful discussion with our dedicated team of welcoming mentors. 
> 
> Exercism is 100% free forever.


I was already registered at a couple of similar websites like 
[CodeWars](https://www.codewars.com/users/aalbagarcia)
or the [euler project](https://projecteuler.net) when I discovered `excercism.io`. But I fell in love with it very fast:

* I can use my computer to solve the problems so I can work offline and use whatever version I want to use 
  of the tools. 
* Since I work in my local computer, 
  [I can track my progress using git](https://github.com/aag-learn/exercism). 
  In CodeWars, for example, you have to use their interface whether you like it or not
* They have mentors that look at your code and give you meaningful feedback
* The challenges are well thought and designed with different degrees of difficulty
* The paths in which they organize the exercises make it very easy to track your progress and resume your 
  work whenever you want to

Don't get me wrong. I like CodeWars and the incredible community of people working on their challenges, but
the simplicity, clarity, and mentorship of `exercism.io` got me real fast. If you have a chance, give it a try.

## What I want to achieve

* Be able to run the `exercism` executable in my computer inside a docker container
* Be able to do the exercises of the [bash track](https://exercism.io/tracks/bash) 
  without installing bash. 

Yes, I know that any MacOS or Linux box have bash installed, but what about windows? 💁‍♂️ In this 
post I will focus on the first step.

## The `Dockerfile`

The exercism.io webpage [has a nice walkthrough](https://exercism.io/cli-walkthrough) that you can follow to install the client in Windows, Linux, and Mac OS. We will use the instructions for the Linux walkthrough
to create our `Dockerfile`:

```docker

FROM debian:stable

ARG USERID
RUN adduser --uid ${USERID:-1000} --gecos "" --disabled-password exercism && \
    apt-get update && \
    apt-get install -y curl bats vim && \
    curl -L https://github.com/exercism/cli/releases/download/v3.0.13/exercism-3.0.13-linux-x86_64.tar.gz --output exercism-3.0.13-linux-x86_64.tar.gz && \
    mkdir exercism-3.0.13-linux-x86_64 && \
    tar xfz exercism-3.0.13-linux-x86_64.tar.gz -C ./exercism-3.0.13-linux-x86_64 && \
    cp exercism-3.0.13-linux-x86_64/exercism /usr/local/bin/ && \
    mkdir /app && \
    chown exercism /app && \
    apt-get clean

WORKDIR /app
USER exercism

ENTRYPOINT ["/usr/local/bin/exercism"]

```

Let's go through the `Dockerfile` and comment on it.

```docker
FROM debian:stable
```
`debian:stable` is our base image. It has everything we need to run the `exercism` executable and an up-to-date bash version (5.0.3).

```docker
ARG USERID
RUN adduser --uid ${USERID:-1000} --gecos "" --disabled-password exercism
```
[To avoid running processes as root inside our container](https://security.stackexchange.com/questions/176206/docker-runs-container-processes-as-root-should-i-be-worried), 
we create an `exercism` user that we will use to run processes inside the containers created from this 
image. 

If you look at the `adduser` command above, you will notice that the `uid` of the user inside the container
is passed as a build argument. Later, we will pass the `uid` of the user in the host
computer so the user in the host that builds and runs the image will have the same `uid` as the user 
`exercism` inside the container. 

We do this because later we will use
bind-volumes to share files between the host and the container. Since both users (the host user and the
`exercism` user) have the same `uid`, any files created inside the container will belong to the user in the host.

```docker
RUN ...
    apt-get install -y curl && \
```
Install `curl` (we'll use it later to download the `exercism` package from github.com)

```docker
RUN ...
    curl -L https://github.com/exercism/cli/releases/download/v3.0.13/exercism-3.0.13-linux-x86_64.tar.gz --output exercism-3.0.13-linux-x86_64.tar.gz && \
    mkdir exercism-3.0.13-linux-x86_64 && \
    tar xfz exercism-3.0.13-linux-x86_64.tar.gz -C ./exercism-3.0.13-linux-x86_64 && \
    cp exercism-3.0.13-linux-x86_64/exercism /usr/local/bin/ && \
```
Download, extract, and copy the latest version of the exercism client into `/usr/local/bin`.

```docker
RUN ...
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
```
Clear the `apt` cache to make our image smaller (more info [here](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#run)).

```docker
RUN ...
    mkdir /app && \
    chown exercism /app && \
WORKDIR /app
USER exercism
```
Create the path that we'll use to mount the bind-volume later.

```docker
ENTRYPOINT ["/usr/local/bin/exercism"]
```
Prepare the container to be [run as an executable](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#entrypoint).

## The Makefile

Once the `Dockerfile` is ready, we'll use the `make` utility to help us run the docker commands. Using 
your favorite editor, create a new file called `Makefile` with the following content:

```make
USERID := $(shell id -u)

build:
      DOCKER_BUILDKIT=1 docker build -t exercism:latest --build-arg USERID=${USERID} .
```

As I mentioned in section _The Dockerfile_ above, we 
are building the image with a user (`exercism`) that will have the same user id as our user in the host
system. The first line of the `Makefile` creates a variable `USERID` to store the user id using the built-in `shell` command of the Make utility.

In the definition of the `build` target, we pass the user argument `USERID` to the build command using 
the `--build-arg` option.

Save the file. We will use it to build the image in the next step.

## Build the image

From the console run the following command:

```shell
> make build
```

The build will start and after a few seconds you should see an output similar to this one:

```text
DOCKER_BUILDKIT=1 docker build -t exercism:latest --build-arg USERID=501 .
[+] Building 31.9s (7/7) FINISHED
 => [internal] load .dockerignore
 => => transferring context: 2B
 => [internal] load build definition from Dockerfile
 => => transferring dockerfile: 746B
 => [internal] load metadata for docker.io/library/debian:stable
 => CACHED [1/3] FROM docker.io/library/debian:stable@sha256:3ac5e3f2fdd73d124e538d0a21f9fa9ba273bebed18af5f38bd87c2e69c04cb5
 => [2/3] RUN adduser --uid 501 --gecos "" --disabled-password exercism &&     apt-get update &&     apt-get install -y curl ...
 => [3/3] WORKDIR /app
 => exporting to image
 => => exporting layers
 => => writing image sha256:c91010d93b29729c2315753f7dec65d4747bdff13d5e611907b7867d2671180a
 => => naming to docker.io/library/exercism:latest
```

The last two lines are the ones we are looking for: they mean that the image was built and ready to use.

## Running the command `exercism troubleshoot`

Let's run the `exercism troubleshoot` command:

```shell
> docker run --rm exercism troubleshoot

Troubleshooting Information
===========================

Version
----------------
Current: 3.0.13
Latest:  3.0.13


Operating System
----------------
OS:           linux
Architecture: amd64


Configuration
----------------
Home:      /home/exercism
Workspace: /home/exercism/exercism (default)
Config:    /home/exercism/.config/exercism
API key:   <not configured>
Find your API key at https://exercism.io/my/settings

API Reachability
----------------

GitHub:
    * https://api.github.com
    * [connected]
    * 43.0216ms

Exercism:
    * https://api.exercism.io/v1/ping
    * [connected]
    * 485.9616ms


If you are having trouble please file a GitHub issue at
https://github.com/exercism/exercism.io/issues and include
this information.
```

If you see this output, your image is ready!

## Configure `exercism``

Looking at the output of the previous command, we can get a hint of the bind volumes that we need to be
able to run the command:

```text
Configuration
----------------
Home:      /home/exercism
Workspace: /home/exercism/exercism (default)
Config:    /home/exercism/.config/exercism
API key:   <not configured>
Find your API key at https://exercism.io/my/settings
```

We will need two bind volumes. One for `/home/exercism/exercism` and another one for `/home/exercism/.config/exercism`:
* The directory `/home/exercism/exercism` inside the container will be bound to the directory of the host in which we are running the command, i.e `$(pwd)`.
* The directory `/home/exercism/.config/exercism` inside the container, will be bound to the local
  directory of the host `$HOME/.config/exercism` so we can
  save and reuse the configuration between different executions of the container.

```shell
> docker run \
      --rm \
      -v $(pwd):/home/exercism/exercism \
      -v $HOME/.config/exercism:/home/exercism/.config/exercism \
      exercism:latest 
      configure --token=11___XXXXXX___ab --workspace=/home/exercism/exercism

You have configured the Exercism command-line client:

Config dir:                       /home/exercism/.config/exercism
Token:         (-t, --token)      11___XXXXXX___ab
Workspace:     (-w, --workspace)  /home/exercism/exercism
API Base URL:  (-a, --api)        https://api.exercism.io/v1      
```

That looks good!! Now, we should have a new file in our host computer holding the configuration of `exercism`:

```shell
> cat $HOME/.config/exercism/user.json
{
  "apibaseurl": "https://api.exercism.io/v1",
  "token": "11___XXXXXX___ab",
  "workspace": "/home/exercism/exercism"
}
```

## Create an alias

We will create an alias to save us some typing. We add the following alias to the `.bashrc`, 
`.bash_profile` or `.zshrc` (depending on your Linux distribution or Operating System):

```shell
alias exercism='docker run --rm -v $(pwd):/home/exercism/exercism -v $HOME/.config/exercism:/home/exercism/.config/exercism exercism:latest'
```

This alias will be there the next time you open a new terminal. To make it available in the current shell
you can just run the command above to create the alias.

## Get our first exercise

We are almost there. Let's start our [Groovy path](https://exercism.io/tracks/groovy) in exercism.io in [mentored mode](https://exercism.io/mentored-mode-vs-independent-mode).


To download the first exercise:

1. Create a folder `$HOME/learning/exercism` in which I will do all the exercises
  ```shell
  ~> mkdir -p learning/exercism
  ~> cd ~/learning/exercism 
  ```
1. Using the alias that we created in the previous section, we download the exercise (the command I'm using 
  is copied from its page in excersim.io)
  ```shell
  ~/learning/exercism > exercism download --exercise=hello-world --track=groovy
  ```

After solving the problem, which is out fo the scope of this article, you can submit the solution by 
running:

```shell
~/learning/exercism > exercism submit groovy/hello-world/src/main/groovy/HelloWorld.groovy
```

## Alternatives

Instead of bind mount `/home/exercism/.config/exercism`, we can store the configuration inside the
image. This would be the subject of another post since it requires a different Dockerfile and a way to
handle the token appropriately.

## References and attributions

* The container image used for the article is a [Background photo created by evening_tao - www.freepik.com](https://www.freepik.com/photos/background) (link to the photo [here](https://www.freepik.com/free-photo/harbor-freight-blue-toned-images_1175715.htm))
