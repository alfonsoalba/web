---
layout: post
title:  "Javascript for hobbyist"
date:   2018-12-21 13:29:47 +0000
categories: javascript
---

# Javascript for new commers

A few days ago a friend of mine asked me this question using whatsapp:

```
Algún tipo de infografic artículo esquema que se yo que me explique la whole picture de js angular jquery Ajax react nodejs. Es que hago cosillas pequnhas en js (there is no way around js) y quiero seguir pero me acojona solo el hecho de que no encuentro nada que me. De una visión global para no profesionales.
```

I know, it's in spanish... What he is asking is some sort of simple explanation of the "whole picture" of the javascript ecosystem for non professional developers.

I was about send him an audio recording via whatsapp, but I thought that a blog post would be more useful. So let's start from the beginning...

## In the beginning, there was Javascript

Javascript is a programming language, like python, ruby, or Visual Basic (to mention a few of the languages that my friend knows). Javascript is the foundation on which the rest of the things he mentioned in his message are built on. JQuery, Angular, nodejs, ajax... they are all part of or build on top of this programming language.

It's a peculiar language, with a very [special history](https://en.wikipedia.org/wiki/JavaScript)... Writen in 10 days by Brendan Eich in 1995, it's in the TOP 10 of the most popular programming lanaguages in 2018 according to the [tiobe index](https://www.tiobe.com/tiobe-index/). It started as a small language to improve web sites and has evolved into one of the [craziest and daunting language / environment](https://www.planningforaliens.com/blog/2016/04/11/why-js-development-is-crazy/) to work in. Not bad for something writen in 10 days!! 

## Ajax? The DOM? They are part of JavaScript!!

Javascript is a language that was created to make static web pages more dynamic. It was created in the context of a web browser.

To understand what Ajax or the DOM is I'll use a couple of examples. Let's travel back to 1995. We have created our first cool (and probably [terrible-looking](http://www.geocities.jp/hande_japan/RidingTrains/Shinkansen.html)) website and it rocks!! A few days after publishing it, we want to improve it. Wouldn't it be nice to be able to say hello to our visitors? Our now boring and static site will ask the user his name and then... a marquee will appear with a message!! How cool is that?

The question is, How could we do that? Well, that's what javascript was written for!

### The DOM

So, let's create a webpage in which we will show a simple text box and a button. The user fills in his name and when he clicks the button the magic happens.

How are we going to say hello to our beloved visitor? To do that, after the user clicks on the button we will add this HTML tag to our web page:

```html
<marquee>Hello, Alfonso!!</marquee>
```

We will append this tag at the end of the ```<body>``` tag.

To be able to manipulate the structure of the HTML document displayed in the web browser, we have what is called ["The DOM" (Document Object Model)](https://developer.mozilla.org/en-US/docs/Web/API/Document_Object_Model). The DOM is a tree representation of the HTML document. This tree comes with a collection of methods that allows developers to manipulate the tree and, therefore, change the structure of the HTML document. This is what we are going to do:

* We bind an [event listener](https://www.w3schools.com/js/js_htmldom_eventlistener.asp) to the click event of the button, so when the user clicks on it we call a function that will do all the magic
* Inside the function (the event listener), the first thing to do is search the DOM to find the element that contains the name of the user and store it in a variable.
* We create a new node that represents the ```<marquee>``` tag. This node will be created outside the tree, it will be like a node without a tree (a sort of orphaned node)
* Set the text content of the marquee tag to be ```Hello, [the name of the user]!```
* At this point, even though the marquee tag has been created, it is not visible because it is not attached to the tree that represents the html document, it's still orphaned!!. We need to add the node to the tree...
* ...so we append the marquee node to the ```<body>``` of the document
* Then, the web browser will notice that the tree has changed (we do not have to do anything!) 
* The web browser will parse the modified tree and will update the rendered HTML document to reflect those changes

In the next codepen you can see the code:

<p data-height="265" data-theme-id="0" data-slug-hash="vvJbqv" data-default-tab="js,result" data-user="fullstackstories" data-pen-title="A simple DOM example" class="codepen">See the Pen <a href="https://codepen.io/fullstackstories/pen/vvJbqv/">A simple DOM example</a> by fullstackstories (<a href="https://codepen.io/fullstackstories">@fullstackstories</a>) on <a href="https://codepen.io">CodePen</a>.</p>
<script async src="https://static.codepen.io/assets/embed/ei.js"></script>

That's it, the DOM is just a data structure (a tree) and a bunch of methods to manipulate that tree. Whenever we modify the tree, the HTML document is rendered again to show the modifications.

The DOM is not limited to the javascript world. You can find implementations of the Document Object Model in a lot of languages like [python](https://docs.python.org/2/library/xml.dom.html) or [java](https://docs.oracle.com/javase/tutorial/jaxp/dom/index.html)

### Ajax

Javascript and it's DOM implementation was the first step in making the web more dynamic... but it was not enough. Back in 1999, once the browser loaded an HTML document if you wanted get an update of what was on that page you needed to reload the whole page.

The people in Microsoft working on the Internet Explorer browsesr thought that instead of reloading the whole page, the browser could request the server for an updated version of the data displayed in the page. That request could be done asynchronously so the user can see the page and interact with it while the request is performerd in the background. Once the request is finished and the new data is received, the developers can use javascript and the DOM to update the page contents with the new data. 

Clever, isn't it? So instead of getting a blank page while the browser realoads the content, gets the whole HTML/javascript/CSS, parse all of them and render the new version of the page... you could just get the updated data and manipulate the DOM to display the updated content... and this is AJAX (Asynchronous JavaScript And XML).

*AJAX is a technique for getting data from or sending data to web servers from a web page asynchronously.*

I think it will be easier to understand the difference with an example. The following picture shows an e-commerce site in which I've added one item to the shopping cart. Before the AJAX technique could be used, the only possible way to update the price of the items in the shopping cart was to reload the page:

![Request without ajax](/assets/images/request_without_ajax.jpeg)

Thanks to the AJAX technique we cand send a request in the background and ask the server for the new price. Once we get the response from the server, we can parse it, find the node in the DOM that contains the price and update it. Since this process is asynchronous (it happens in the background) the user can do other things in the page like scroll down or fill a form for example.

![Request with ajax](/assets/images/request_with_ajax.jpeg)

> [XMLHttpRequest](https://developer.mozilla.org/en-US/docs/Web/API/XMLHttpRequest) is the object used in Javascript to perform asynchronous requests.

## Libraries

On top of the javascript language you can find libraries. Libraries are collections of objects, classes and methods that makes the life of developers much easier.

![javascript and libraries](/assets/images/javascript_and_libraries.jpeg)

For example, if you are writting a webpage that needs to deal with time and time zones or you need to perform date calculations, you'll probably want to use a library called [moment.js](https://momentjs.com/). Doing all that stuff in plain javascript is difficult and time consuming. 

Normally, libraries are lightweigh and very focused on solving a particular problem, like moment.js. For example, you can use [the chart.js library](https://www.chartjs.org/) if you need to display data in your application or [sortable](http://sortablejs.github.io/Sortable/) if you need to sort lists with drag and drop.

There are also libraries which are multi-porpouse, like [JQuery](https://jquery.com/). Quoting its website...

> JQuery makes things like HTML document traversal and manipulation, event handling, animation, and Ajax much simpler with an easy-to-use API that works across a multitude of browsers. With a combination of versatility and extensibility, jQuery has changed the way that millions of people write JavaScript.

Another example of a library that does multiple things is [underscore](https://underscorejs.org/).

## Frameworks

A framework is an opinionated set of tools and libraries that can be used to build software. Opinionated means that the people who wrote the framework made decissions about how things should be done to solve a particular problem or to build certain kind of software.

For example, [AngulaJs](https://angularjs.org/) is a well known and very popular javascript framework. It provides tools and libraries to write Javascript [Single Page Applications](https://en.wikipedia.org/wiki/Single-page_application). 

![](/assets/images/javascript_libraries_and_frameworks.jpeg)

If you decide to use a framework, you are choosing to do things in a particular way **since you are implicitly assuming that all the decissions made by the people who wrote the framework are good for you**. Choosing the right framework is a tough decission that should be thoroughtly researched and analyzed.

## Runtimes

Runtimes are programs that read your JavaScript code and convert then to runnable commands. For example, the Chrome web browser uses the V8 Javascript runtime. That runtime is the one that reads you javascript files, converts the to runnable instructions, runs them and tells the browser to render the page.

If you install nodejs in your computer you do not need a broser to run javascript because nodejs brings a runtime to your command line. So you can open your favorite editor, create a file hello_world.js and use nodejs to "run" it using the command line. 

> Nodejs uses the V8 Javascript runtime as well!!

## When to choose a library or a framework

It is a tough decission which would require a separate post. You have to take into account the size and complexity of the project, how easy it is to hire people who know the framework, how big is the community it, haw opinionated it is, what kind of software you can build with it, the learning curve... As I said, it is not easy.

If you are rookie programmer and you are facing your first JavaScript project, I would recommend the following:

* If you are writting a simple application and just want a few controls to improve the user experience, you are probably good with JQuery and a bunch of plugins. There are a ton of jquery plugins out there!!
* If you need to write a simple application that needs complex user interactions, I would choose vue.js or react.
* If you need to write very complex applications I would choose to use a framework.

## Conslusion

Learning javascript can be daunting, event if you are a seasoned developer in other technologies. Javascript is a peculiar language with a huge ecosystem of libraries, frameworks and runtimes built on top of it. If you are starting a side project to learn it, my recommendation would be to start with jquery and, ir your interface has some complexity, add vuejs to the mix.

I hope this post helps my friend (and any hobbyist developer in his same situation). 

