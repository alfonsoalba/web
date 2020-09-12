---
layout: post
title:  "The Raspberry Pi project: Hardware"
permalink: /:year/:month/:day/the-raspberry-pi-project-hardware.html
date:   2020-07-12 07:00:00 +0000
categories: 
  - "RaspberryPi"
excerpt: >-
  After a few years I finally decided to buy a Raspberry Pi and <em>do something</em> with it. In this post I talk about
  the hardware that I bought and what I'm building with it as the first step of my project.
---

In 2013 I went to the [iOSDevUK conference](https://www.iosdevuk.com/) that 
takes place every year in Aberystwyth (Wales). 
At that conference, I went to an Arduino Workshop where I had the chance to 
play a little bit with an Arduino board. Since then, I've been thinking about 
buying either an Arduino or a Raspberry Pi to play with them.

Well, seven years later I finally decided to buy a Raspberry Pi and 
_do something_ with it. After I made the decision, I spent a few days thinking
about what I would build with it before actually buying it. 
I didn't want it to be another thing that ends up at the bottom of the drawer 🤔. 

On April 13th this year I started a new job as a DevOps Engineer at Platform161.
A new job means new tools and new challenges so I need to get up to speed 
with Ansible, Prometheus, Packer and Google Cloud Platform. And these are just the
most important applications that are new to me. We are using Jenkins and we have 
plans to start using docker shortly (that's what they hired me for 😋) but 
learning the new staff is the big priority now.

So I decided that my first project with the Raspberry Pi was going to be:

* Buy it.
* Configure it and provision it using Ansible.
* Install and configure my Jenkins, that is now running in my laptop, in the
  Raspberry Pi.
* Use the Jenkins installed in the Raspberry Pi as master and run the 
  jobs in agents running in Google Cloud Platform.
* Install Prometheus and use it to monitor some old projects that I have still
  running.

Once I manage to get Jenkins and Prometheus up and running, which 
means actually doing it, I'd like to connect it to a WebCam so I can see my 
cat and my dog, create a VPN, and do something cool with the 
[integrated GPIO](https://www.raspberrypi.org/documentation/usage/gpio/)
(whatever "something cool" means).

But let's start with the beginning...

## The Hardware

After doing some research, this is the hardware that I bought. Disclaimer:
I'm using the links to the place where I bought the stuff. You will
see that most of them point to [PcComponentes](https://www.pccomponentes.com/), 
a well-known e-commerce site here in Spain. 
Why? They have good products at good prices, good support by phone and email, 
and mainly because it's here in Spain and I don't want Amazon to get
all my money (even though I have Amazon Prime and buying stuff in PcComponentes 
means that I have to pay a few extra Euros for shipping)

* [The Raspberry Pi Model 4 with 8GB RAM](https://www.pccomponentes.com/raspberry-pi-4-modelo-b-8gb)
* [Samsung MicroSDHC EVO Plus 32GB Clase 10 + Adapter](https://www.pccomponentes.com/samsung-microsdhc-evo-plus-32gb-clase-10-adaptador) I bought it to be able to
  install the OS in it and boot for the first time.
* [Nanocable Micro HDMI to HDMI High-Speed 0.8m](https://www.pccomponentes.com/nanocable-cable-micro-hdmi-a-hdmi-alta-velocidad-macho-macho-08m) so I can connect
  the Raspberry Pi to my HDMI flat screen.
  I'm planning on doing a headless installation (no Desktop) and everything
  I want to do can be done connecting via SSH. However, as we'll see in future 
  posts, it's not a bad idea to have a way to open the console and connect 
  to the Raspberry using the tty and a USB Keyboard.
* [A cheap and compact USB keyboard](https://www.amazon.es/gp/product/B017DNQ410/ref=ppx_yo_dt_b_asin_title_o00_s00?ie=UTF8&psc=1) I bought it for the same reason I bought the HDMI cable
* [Bruphny Raspberry Pi 4 Cage with 35mm Fan, 5V / 3A USB-C Power Supply, 4 X Disipators - Black and Blue](https://www.amazon.es/gp/product/B07X8MZPWP/ref=ppx_yo_dt_b_asin_title_o01_s00?ie=UTF8&psc=1)
  The cage. It fits perfectly, it's easy to install, it has the fan in case I
  need extra cooling and I liked the way the transparent dark blue looked.
* [Raspberry Pi 4 5V 3A 15W Power Supply White](https://www.pccomponentes.com/raspberry-fuente-de-alimentacion-usb-c-para-raspberry-pi-4-5v-3a-15w-blanca) 
  To be honest, I did not actually need this one since the cage that I bought
  includes a similar Power Supply. I realized it after I got the cage (which was 
  the last item to arrive) Anyway, I decided to keep it because [a review of 
  the cage in Amazon (in spanish)](https://www.amazon.es/gp/customer-reviews/R21LNZ2LQVACWS/ref=cm_cr_dp_d_rvw_ttl?ie=UTF8&ASIN=B07X8MZPWP) said that the user had an issue with the included 
  power supply.
* [Samsung T5 External SSD 250GB USB 3.1 Blue](https://www.pccomponentes.com/samsung-t5-ssd-externo-250gb-usb-31-azul)
  I'm going to replace the internal SSD card with an external USB 3.0 disk for
  improved performance, and this is the disk that I chose.
* [Startech USB31AC50CM Cable USB-C to USB-A 50m Black](https://www.pccomponentes.com/startech-usb31ac50cm-cable-usb-c-a-usb-a-macho-macho-50cm-negro)
  To connect the external disk to the Raspberry Pi.
* [An USB card reader/writer](https://www.amazon.es/gp/product/B07Y1SFRZB/ref=ppx_yo_dt_b_asin_title_o02_s00?ie=UTF8&psc=1)
  To be able to transfer the OS to the SD card and boot the Raspberry.


After I had all the hardware, the first thing I did was 
[follow the 
documentation](https://www.raspberrypi.org/documentation/installation/installing-images/mac.md)
to install Raspberry OS in the SD card and boot the Raspberry. But that 
will be another post...
