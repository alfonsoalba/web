---
layout: post
title:  "screen vs. nohup - Which one is better?"
date:   2020-12-28 19:00:00 +2000
categories:
  - "Linux"
  - "Commands"
excerpt: >-
  A follow-up of the previous article about the screen command. Given the ton of features that screen has, when is it
  better to use nohup?
cover_image_alt: "two knights face to face"  
cover_image: "post_headers/two_knights_face_to_face.jpg"
image: "/assets/images/cards/two_knights_face_to_face.jpg"   

---

## TL;DR

A follow-up of [the previous post about the screen command]({% post_url 2020-12-07-the-screen-command %}). `nohup` uses
less memory than `screen`, that is the price to pay for all those nice features that come with `screen`.
Furthermore, `screen` must be installed as a separate package while `nohup` usually is distributed as
part of core utilities in almost any Linux distribution. However, if you need to run scripts that accept parameters then
`screen` will make your life easier. 

They are different tools and difficult to compare. The best thing to do is understand both of them and use the right one
depending on your case.

## Availability

`nohup` is a command that I've found in every Linux distribution that I've worked with. It was present also in Solaris
and BSD systems that I worked with a few years ago. You can be confident that when you open a terminal in any Linux 
box, the `nohup` command will be there. Let's have a look at some major Linux distributions:

* [Ubuntu](https://packages.ubuntu.com/bionic/coreutils) and [debian](https://packages.debian.org/buster/coreutils) 
  include the command in the `coreutils` package, which is a fundamental part of the operating system.
* [Fedora](https://fedora.pkgs.org/33/fedora-aarch64/coreutils-8.32-12.fc33.aarch64.rpm.html), 
  [Centos](https://centos.pkgs.org/8/centos-baseos-aarch64/coreutils-8.30-8.el8.aarch64.rpm.html) and 
  [OpenSuse](https://opensuse.pkgs.org/15.2/j.eng-x86_64/coreutils-8.29-lp152.8.3.i586.rpm.html) also provide
  the `nohup` command as part of their `coreutils` package.
* Even [busybox](https://busybox.net/) which is a tool that provides a fairly complete environment for any small or 
  embedded linux systems includes the `nohup` command by default.

`nohup` also comes installed in macOS, which it's not surprising at all given that macOS is based on BSD.

On the contrary, `screen` must be installed as a separate package. This means that you might stumble upon machines in 
which it's not installed. For example, I still have access to a shared hosting server that you could access using ssh. I had 
a very limited amount of linux commands available and `screen` was not one of them. But you know what? `nohup` is installed there!

For this reason, it's a good idea to know how `nohup` works and what you can and can't do with it. It will be like 
that good old friend that you know since kindergarten... it will always be there for you.

> `nohup` will always be there so my suggestion is that you should learn how to use it.

## User input

`nohup` is good for running processes in the background when those processes don't require user input. For 
example, let's make a backup of our user folder using `nohup`:

```
> nohup tar cfj /tmp/mybackup.tar.bz2 /home/myuser &
appending output to nohup.out
>
```

> Processes that don't require user input are great to use with `nohup`. 

However, if the process requires user input, then `screen` it's better for the task. As an example, 
we [still have a Jira Server intallation](https://www.atlassian.com/migration/journey-to-cloud) in my current project.
We have a documented procedure to upgrade our instances when a new Jira version is released and that procedure
involves a script that asks you different questions during the upgrade process. We use `screen` for that.

Using screen we can start the Jira upgrade process, answer whatever questions the upgrade script asks and let it work for
some time in the background while it performs the backups and other stuff. We can even close the ssh connection to the 
server. Later, we can ssh back to the server, reattach to the screen and continue with the last part of the installation.
I can't do that with `nohup`

## Terminal window manager

`screen` is good to manage multiple terminals. For example, you can open a terminal to do some backups and another 
terminal to configure your nginx server, all of this with one ssh connection. You can give them a meaningful name 
with the `-S` option and switch from one to another:

```
> screen -s backups tar cfpj /tmp/backup.tar.bz2 /home/myuser
    (detach with CTRL+A d)
> screen -s nginx_config 
    (detach with CTRL+A d)
> screen -ls
There are screens on:
	16531.nginx_config	(Detached)
	16507.backups	(Detached)  
```

It's more a terminal manager while `nohup` is a tool to run processes in the background detached from the terminal.


## Conclusion

Answering the question in the title of this post: there is no tool better than the other one. 
`nohup` and `screen` are different things and therefore difficult to compare. Being a terminal manager, `screen` is more powerfull
and it's a great add on to your toolset if you work regularly with the command line. However, the avalilability of `nohup`
makes it almost a universal tool, so it's good to know what you can and can't do with it just in case you stumble upon
a system in which no terminal manager like `screen` can be installed.