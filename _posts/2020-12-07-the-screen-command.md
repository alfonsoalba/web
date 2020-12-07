---
layout: post
title:  "The screen command"
date:   2020-12-07 09:00:00 +2000
categories:
  - "Linux"
  - "Commands"
excerpt: >-
  The screen command 
cover_image_alt: "multiple screens"  
cover_image: "post_headers/multiple_screens.jpg"
image: "/assets/images/cards/multiple_screens.jpg"   

---

## TL;DR

I discovered the `screen` command recently and it was love at first sight. Before 
knowing about `screen`, I was using `nohup` to leave commands running in the background 
after closing my SSH connection.  The rich set of options that the `screen` command has, 
made `nohup` _obsolete_ for me. In this post I show you my most common use case of `screen`.

## What is `screen`

`screen` is a [terminal multiplexer](https://en.wikipedia.org/wiki/Terminal_multiplexer). Quoting the 
[man page](https://man7.org/linux/man-pages/man1/screen.1.html):

> Screen is a full-screen window manager that multiplexes
> a physical terminal between several processes (typically 
> interactive shells). Each virtual terminal provides the 
> functions of a DEC VT100 terminal and, in addition, 
> several control functions from the ISO 6429 (ECMA 48, 
> ANSI X3.64) and ISO 2022 standards (e.g. insert/delete 
> line and support for multiple character sets). There is 
> a scrollback history buffer for each virtual terminal 
> and a copy-and-paste mechanism that allows moving text 
> regions between windows.

The [man page](https://man7.org/linux/man-pages/man1/screen.1.html) is more than 4000 lines long. And that's
because `screen` is packed with options.

You can do quite a few things with `screen`:

* Open an ssh connection, run a job in the background inside a _screen_ and close the connection. 
  You reconnect back later through ssh and open the _screen_ you left open to see how your command
  is doing.
* Open a screen with a shell in it and share it with other people connected to the 
  same machine through ssh.
* Use it to run several processes in the background using the same SSH connection. I see it as a
  replacement of the good old `jobs`, `fg`, and `bg` bash builtins.

In this post, I will describe the first use case, which is the most common for me.

## Installation

In Linux or Windows 10 with WSL, you can use the package manager of your distribution to install it. 
In Debian based distributions you can use apt:

```shell
> sudo apt install screen
```

In macOS, the best way to install it is by using homebrew:

```shell
> brew install screen
```

## Using `screen` to run long-running commands

In my current company (Platform161) we run scripts that take several hours to finish. Although
we normally use Jenkins to run them, from time to time we need to execute them manually
connecting to the machine using ssh. 

For those that are not used to work with Linux, if you run a script just by connecting to the machine
using ssh and executing it, the script will be run inside your session. If you log out or your internet 
connection fails, your session will be terminated and your job as well. It's not enough to run
the script in the background since it will be still running in your session.

If you have a backup script that lasts four hours, you don't want to have it running inside
attached to your session. Losing your internet connection 10 seconds before your 3-hout-long job finishes 
and having to run it again is something extremely infuriating.

We will run the command using `screen` instead. Let's connect through ssh to our machine:

```shell
> ssh alfonso@mymachine.com
```

Once we logged in, we run the `screen` command: 

```shell
alfonso@mymachine.com > screen
```

and we will be welcomed with a message:

```shell
Screen version 4.00.03 (FAU) 23-Oct-06

Copyright (c) 1993-2002 Juergen Weigert, Michael Schroeder
Copyright (c) 1987 Oliver Laumann

This program is free software; you can redistribute it and/or modify it under 
the terms of the GNU General Public License as published by the Free Software 
Foundation; either version 2, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY 
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A 
PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with 
this program (see the file COPYING); if not, write to the Free Software Foundation, 
Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

Send bugreports, fixes, enhancements, t-shirts, money, beer & pizza to screen@uni-erlangen.de

[Press Space or Return to end.]
```

After pressing Space or return, `screen` will run a shell. Inside that shell, we execute
our long-running command:

```shell
alfonso@mymachine.com > ./long_running_script.sh
The script starts to run...
progress: 1%...2%...
```

Let's say the script takes about 3 hours to complete. Since we are running it inside a 
`screen` session, we can now detach from the screen by pressing `CTRL+A` and then `d`. 
After doing that, we go back to the shell we opened when we logged in using ssh:

```shell
alfonso@mymachine.com > screen
[detached from 2661.pts-0.mycomputer]
alfonso@mymachine.com > _
```

Now, our script is not attached to our session but to the _screen_ we created. This way, We don't depend
on the internet connection for our script to run!

...and we can just logout and come back later to check the progress. Before logging out 
from `mymachine.com` let's have a look at the list of screens that are open:

```shell
alfonso@mymachine.com > screen -ls

There is a screen on:
	2661.pts-0.mycomputer	(12/07/20 10:54:54)	(Detached)
1 Socket in /run/screen/S-alfonso.

alfonso@mymachine.com > _
```

As you can imagine, we can re-attach later to that screen using the identifier `2661.pts-0.mycomputer`.
Since this is a command that takes a long time, we will close the ssh connection and check again later.

```shell
alfonso@mymachine.com > exit
> _
```

## Re-attaching to the screen

After a couple of hours, we want to check the progress of our long-running script. To do that,
let's connect again to our machine using ssh:

```shell
> ssh alfonso@mymachine.com
```

Let's see if our long-running script is stil there. To do that, we get a list of the available screens:

```shell
alfonso@mymachine.com > screen -ls

There is a screen on:
	2661.pts-0.mycomputer	(12/07/20 10:54:54)	(Detached)
1 Socket in /run/screen/S-alfonso.

alfonso@mymachine.com > _
```

Yes,it's still there. We re-attach to the screen `2661.pts-0.mycomputer` to see how are things going:

```shell
alfonso@mymachine.com > screen -r 2661.pts-0.mycomputer
```

after running this command, the screen will open and we can check the progress

```shell
alfonso@mymachine.com > ./long_running_script.sh
The script starts to run...
progress: ...10%...20%...30%...40%...50%...60%..
```

We can log out and check again later.

## Saving output to a file

We can continue to connect through ssh and check the progress of the script. Eventually, the script
will finish and the `screen -ls` command will return that no screens have been found:

```shell
alfonso@mymachine.com > screen -ls
No Sockets found in /tmp/uscreens/S-alfonso
```

After the script finishes running, the screen is closed and the output
of our command will be lost. Unfortunately, we don't know if the command was 
successful or not. If I want to save the output of the screen 
and keep it after the script ends, we should
use the `-L` option. We can also use the `-Logfile` option to select where to store the output:

```shell
alfonso@mymachine.com > screen -L -Logfile long_running_script_ouput.txt
```

With these options, once the script finishes, we can look
at the output of the file `long_running_script_ouput.txt` to see what happened.

## Credits

* My colleague Manuel Molina for introducing me to this command that I didn't know about. Much
  more convenient than `nohup`.