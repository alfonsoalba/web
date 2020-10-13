---
layout: post
title:  "About this blog: Docker"
date:   2020-10-13 09:00:00 +0000
categories:
  - "Docker"
excerpt: >-
  What will you find in the blog related to docker? I've made a decision about
  how I'm going to use docker and I share with you in this post. 
cover_image_alt: "containers"  
cover_image: "post_headers/containers.jpg"
image: "/assets/images/cards/containers.jpg"  

---

## TL;DR

In this blog, you will find plenty of articles where I use docker, even for simple tasks that you could easily do by 
installing software with your package manager. This way of doing things might seem a little overkill, but there is a 
reason behind it: I wanted to push myself to use docker as much as possible, and it worked quite well for me. If you 
want the longer version, you can continue reading.

## Starting with docker

A few years ago, around 2017, I started to get serious about docker. After attending
[a talk from Laura Morillo at the Madrid ruby users group](https://www.madridrb.com/topics/tu-aplicacion-rails-en-kubernetes-544), 
I decided to stop reading about docker and start using it. 

<blockquote class="twitter-tweet"><p lang="es" dir="ltr">Este finde he migrado a docker el entorno de desarrollo de nuestro nuevo proyecto en rails ¡gracias <a href="https://twitter.com/Laura_Morillo?ref_src=twsrc%5Etfw">@Laura_Morillo</a> por tu charla! <a href="https://twitter.com/madridrb?ref_src=twsrc%5Etfw">@madridrb</a></p>&mdash; Alfonso Alba García (@aalbagarcia) <a href="https://twitter.com/aalbagarcia/status/881747710063280130?ref_src=twsrc%5Etfw">July 3, 2017</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

Laura gave a talk that really inspired me and pushed me to get my hands
dirty. I remember dockerizing one the projects I was working on at the time. 
It was during the weekend following the talk and it was so much fun!!.

This was in 2017. Fast forward to the second half of 2019, and I had:

* dockerized the development environments of all the projects I was working at
* ockerized the production environments of two of those projects
* On top of that, I was confident enough to start giving docker courses 
  (you can find the slides [here](https://github.com/Be-Core-Code))

## The big decision: to use docker as much as possible

How did I do it? The first step was to stop using `homebrew`. Don't get me wrong,
I think that homebrew is a great tool and it really makes our life easier when using 
OS X. But I wanted to force myself to use docker, to understand it. That's why
I decided to remove all the packages I had installed with `homebrew` and start with a 
clean installation. This is the list of brew packages that I have installed now
in my development box:

```bash
 % brew list
ack		gdbm		libidn2		pcre2		telnet
bash-completion	gettext		libunistring	python@3.8	unrar
bvi		git		ncurses		readline	vagrant-completion
dos2unix	git-lfs		nvm		sqlite		wget
ext4fuse	htop		openssl@1.1	sshpass		xz
```

Just 25 packages. From that list, only git, ansible, and python are relevant. No ruby or node.js. 
No trace of any of the databases that I use in my projects like PostgresQL, MySQL, Elasticsearch, Monogodb, Redis... 

If I need to do something that requires a database, I used docker. I needed to learn 
groovy to write those badass Jenkins pipelines... it's fine as long as I do it
inside a container. Want to have a local instance of Jenkins? Ok, but run it with 
`docker-compose`. This blog is written using Jekyll inside a docker container. 
**I forced myself to use docker for almost everything that I wanted to do.**

There were times when it was too complicated, though. I remember I got stuck with ansible
and the Google Cloud Console and things were taking 
too much time. Other times I didn't have enough knowledge of the stack to make it work
in a container. In those few cases, I went back to `homebrew` or virtual machines
with `Vagrant`. 

This way of pushing things was a good decision. Just trying to use a new technology
inside docker made me stop and ask myself a lot of questions like how that technology 
worked or how I should persist data. Questions about file permissions, networking, 
credentials, security, and a plethora of other things that you don't think about 
when you use `homebrew` or `apt`.

In this blog you will see a lot of posts in which I use docker. You will see
long docker commands instead of simple shell commands that you can install with 
homebrew or apt. Now you know the reason.

## Conclusion

Remove all my `homebrew` packages and force myself to use docker even for
simple things it might seem a rather extreme way of getting to learn docker. However,
it helped me a lot to understand all that "docker black magic". Volumes, 
persistence, secrets, images, layers, caching... everything started to make sense 
once I decided to not take shortcuts and face all those new concepts almost daily.

This is not the first time I've done something like this. It's
a way of doing things that works very well for me. In 
1998 I discovered Unix while starting to do some research work at my university. 
I used one of those 
[Alpha workstations](https://en.wikipedia.org/wiki/AlphaStation) and I fell in love
with the operating system. I decided that the best way 
to learn Unix was to use it, so I reformatted my home computer 
and replaced Windows98 with RedHat 3. But that story is worth another post.


Copyright: <a href='http://www.stockunlimited.com'>Image by StockUnlimited</a>