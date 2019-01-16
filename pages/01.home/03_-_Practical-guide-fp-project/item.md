<!--
---
title: A practical guide to writing projects with functional programming
date: 13:40 01/13/2019
author: Jan-Gerke Salomon
header_image: image.jpg
subheading: Or how to avoid ending up with a mess that no one wants to touch anymore, not even future-you
---
-->

<style>
  .intro-header { position: relative; }

  .intro-header:before {
    content: ''; position: absolute; top: 0; left: 0; background: rgba(0,0,0,0.7); width: 100%; height: 100%; z-index: 0;
  }

  .highlighted {
    border-left: 4px solid #0366d6;
    background: #fafafa;
    padding: 20px;
  }

  .highlighted > :last-child {
    margin-bottom: 0;
  }
</style>

## How to read this article

If you've never read this article I recommend to read it from top to bottom as 
I'll  introduce a few concepts and terminology which later paragraphs will 
base on.  I've you're a returning customer, feel free to jump to any section 
you'd like to read again!

## Introduction

I guess every developer dreams of having some kind of architectural approach
that combines being modular, extensible, easy to reason about, refactorable
while yet being simple abstract enough to be applicable in all kinds of
contexts.

And I also guess that every developer with some degree of experience with
larger code bases know the pain of working with code that you'd just like
to throw away just to start again from scratch.

The whole time of my career I always tried to achieve simplicity while being
still being able to tackle the complexity of a project in a reasonable way but I
never felt happy with what I saw, produced or had to work with.

That was until I read a book about programming in clojure that contained a 
headline that just sticked in my mind and finally thrived with awesome results.
The book that I'm talking about is:
[`Clojure for the brave and true` ](https://www.braveclojure.com/foreword/),
by Daniel Higginbotham, containing the following headline:

<div class="highlighted">
Organizing Your Project: A Librarian’s Tale
</div>

[Link to the chapter]( https://www.braveclojure.com/organization/)
<br><br>
The chapter was about a project's structure, so I kept asking myself what
the codebase would look like if I approach it like I would expect a library
to be organized like. What I came up with since I first started to think about
this approach will be summarized in this article.

I will furthermore talk about how I apply this approach when using Redux with
React, RxJs and Reselect, which are - in my opinion - the foundation of a solid
web application.

I wouldn't say that my approach is perfect, but it gave me the feeling that I
can compose every unit of my code, separate business logic from data 
transformation, modelling my types and rendering of the current state.

## Mandatory familiarity with some concepts

There are a few tricks and concepts that you shouldn't just know about, but
also have understood and know how to apply in real world applications, here's
an incomplete list:

* Immutability
* Programming bottom up
* Seperation of concerns
* Functional programming in general or in the context of JavaScript
* Streams (in terms of data over time)
* The cost of recalculation and power of caching

## The library pattern

Although I call it a pattern, it's rather abstract than concrete. It basically
boils down to the following:

Every atom, unit, component, composition, and whatnot, should be stored
logically somewhere in our application so that - in theory - one is able to 
easily find it without knowing the codebase, just like in a library. So let's
have a look at how libraries are structured and how we can apply that to a 
codebase.

### A library's structure

The underlying concept of organizing physical object a library is a hierarchy 
tree. There is  one root hierarchy: The type of the medium, e. g. Books,
Newspaper, DVD, etc. The second hierarchy are general 
topics which depend on  the root hierarchy. Topics of Books can be novels,
scientific literatur, and topics of novels may contain SciFi,
Fantasy, Thriller,while topics of scientific literature might be Biology,
Information technology, Physics, Geology, Geography, you name it.

Obviously this follows a pattern which isn't clearly defined but rather 
abstract. In theory the root hierarchy could also consist of something
entirely different as long as it devides the sub hierarchies into a structure
that is exclusive. A Novel will never be a newspaper and scientific literatur
will never be a novel. So here we have the one and only rule of the library 
pattern:

<div class="highlighted">
One level of a hierarchy has to devide all containing items into exclusive
domains.
</div>
<br>
Of course this will cause some friction as some books may contain several
topics. But it's imporant to stick to the rule, there should be no exception.
So if there's a book about music and the effects on the brain (which is arguably
biology), instead of putting it in either one of them or both, we can create a
new category, e. g. "Mixed topics". That might be a little overcomplicated for
a library but when working with code, at least when following the library
pattern, it's a necessity. Luckily, we won't have to make up funny names like
"Mixed topics" as we're dealing with problem domains, so they'll have their own
names anyways.

### A project's structure

In a library the name of the root category is obvious: `Library`. In the
library architecture there can be one or more root categories. They are
the index files of our application. Let's think about a web application that
let's us both view and modify a pdf file. We'd have to entry files:

1. view.js
1. editor.js

This means that we'll have files which we'll need for the view only and files
which we'll need for the editor only. But it's 100% clear that we'll need
files/functionality for both of them, so the file structure should look like
this:

<div class="highlighted" style="padding-top: 0; padding-bottom: 0;">
<pre><code>/----------
-- editor/
-- lib/
-- view/
-- editor.js
-- view.js
</code></pre>
</div>
<br>
There should be no other file or directory on this level! It's separating our
code base into exclusive problem domains.

#### The lib folder

The name doesn't really matter, it could be `helper` or anything else that 
fits. The idea is that code inside this directory has the following purpose:

Transformation on data will be expressed in functions (which will do the
transformation on a given input, returning the calculated result), and should
be reusable. This is where the bottom up approach comes in. If we say that 
some transformations will only happen in the view domain, we're tailoring our
application towards a specific problem domain rather than abstracting the
solutions. So if there's something that needs to be done, the basic operations
on data itself should be in the library folder. Which brings me to the next two
folders.

#### The view and editor folders

Code inside these folders should have one role only: Telling the application
what needs to happen. It shouldn't contain transformations (see one chapter
above). You can think of code inside these folders as controller code (if you
are familiar with MVC).

#### Folders inside the root level folders

These folder simply follow the same rule. It's ridiculously simple and yet
requires to put some thoughts into the architecture. 

### Conclusion

There's no generally applicable rule how you should devide the units of your 
application, so I can't give more advice than this and: 

practice, practice, practice!

You'll quickly notice that - when following this pattern - you'll be able to 
search your code base much quicker than before, even if you learn new concepts,
use different libraries. It's abstract enough that it works with all functional
libraries because functional programming - in contrast to design patterns in 
OOP projects - do not enforce an architectural design, there are simply no
real design patterns.

## Redux, React, Rxjs and Reselector

Let's tie the insights of the previous chapter together with currently modern
front-end technology (no one knows how long we'll be using these libraries,
especially in the JavaScript world).

We generally have the following problem domains for which we need a neat way 
to approach them.<br>
We need to:

1. define intentions that will cause the state of our application
to change.
1. define how our state - based on the intention - should be 
changed.
1. define how we handle side effect, like talking to an api.
1. handle state that depends on other state so we neither
clutter the data state with derived state nor recalculate everytime
the state needs to update.

### Composability

We need to find a way to handle these problem domains in a way that we can
define units which are composable. Then we'll be able to refactor and
extend our functionality easily, otherwise we'd end up with many
concretions which are less reusable, harder to maintain and generally
increase the cognitive load.

### Seperation of concerns

As we can see, I've separated the different things we need to do
in order to have a good overview on how we manage our application.
This is the reason why I don't like some heavily used libraries with
redux like redux-thunk. It mixes the intention domain with the IO domain.

So when looking inside the actions directory of our application, there's
no way to know which action creator returns an object or a function,
which means it's non-deterministic to know where our IO code is.
Of course this could be expressed in the name of the action creator, 
but that would violate being declarative instead of imperative.

#### Defining intentions

This is an easy one. With redux we express intentions in actions that can be
dispatched to trigger a state change

#### Changing the state

This is obviously the role of the reducers. They'll take incoming actions and
the current state to produce a new state.

#### Handling IO / Side effects

This is a bit more tricky as it's not part of the redux library by default.
There are some approaches out there, the 3 most common are: redux-thunk,
redux-saga and redux-observable.

The reason why I reject redux-thunk is mentioned above.
Then there is redux-saga which is a better approach already as we separate
IO into it's own problem domain, it's not mixed with the actions anymore.
And it's a reasonable choice until you have more complex asynchronicity
in your project.

This is where the true power of redux-observable is visible. Using RxJs
to work on a stream of actions, which will emit a new action at some point
and also moves the IO / Sideeffect into it's own problem domain.
But we can do a lot more with redux than just that. We can cancel streams,
complete streams, compose streams, intertwine streams, etc, which is
why redux-observable is my favorite!
