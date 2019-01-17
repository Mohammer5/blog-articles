---
title: The library pattern
date: 15:30 01/17/2019
author: Jan-Gerke Salomon
header_image: image.jpg
subheading: A practical guide to organizing projects with functional programming
---

<style>
/*
  .intro-header { position: relative; }

  .intro-header:before {
    content: ''; position: absolute; top: 0; left: 0; background: rgba(0,0,0,0.7); width: 100%; height: 100%; z-index: 0;
  }
*/
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
base on.  I've you're a returning visitor, feel free to jump to any section 
you'd like to read again!

## Introduction

I guess every developer dreams of having some kind of architectural approach
that combines being modular, extensible, easy to reason about, refactorable
and contains many composable units
while yet being simple abstract enough to be applicable in all kinds of
contexts.

And I also guess that every developer with some degree of experience with
larger code bases knows the pain of working with code that you'd just like
to throw away just to start again from scratch.

During my career I always tried to achieve simplicity while
still being able to tackle the complexity of a project in a reasonable way.
But I never felt happy with what I saw, came up or had to work with.

That was until I read a book about programming in clojure containing a 
headline that just stuck in my mind.
The book that I'm talking about is:
[`Clojure for the brave and true` ](https://www.braveclojure.com/foreword/),
by Daniel Higginbotham, containing the following headline:

<div class="highlighted">
Organizing Your Project: A Librarian’s Tale
</div>

[Link to the chapter]( https://www.braveclojure.com/organization/)
<br><br>
The chapter is about the tools clojure provides to structure your project,
so I kept asking myself what
a codebase would look like if I approach it like I would expect a library
to be organized like. What I came up with since I first started to think about
this approach is summarized in this article.

I will furthermore talk about how I apply this approach when using Redux with
React, RxJs and Reselect, which are - in my opinion - the 
good foundation of a solid web application.

This approach is not perfect nor will satisfy all needs,
but it gave me the feeling that I
can compose most units of my code, separate business logic from data 
transformation, modelling of types and rendering of the current state.

## Mandatory familiarity with some concepts

There are a few tricks and concepts you should know about,
understand and know how to apply in real world applications:

* Immutability
* Programming bottom up
* Separation of concerns
* Functional programming in general or in the context of JavaScript
* Streams (in terms of data over time)
* The cost of unnecessary recalculation and power of caching

## The library pattern

Although I call it a pattern, it's rather abstract than concrete.
It basically boils down to the following:

Every atom, unit, component, composition, and whatnot, should be stored
logically somewhere in our application, so that - in theory - one is able to 
easily find it with ease, without knowing the codebase, just like in a library.
So let's have a look at how libraries are structured physically
and how we can apply the findings to a codebase.

### A library's structure

The underlying concept of organizing physical objects in a library
is a hierarchy. There is one root hierarchy, containing several categories:
The type of the medium, e. g. Books, Newspaper, DVD, etc.
The second hierarchy consists of general topics which depend on their
parent category. Topics of Books can be novels,
scientific literature, and topics of novels may contain SciFi,
Fantasy, Thriller, while topics of scientific literature might be Biology,
Information technology, Physics, Geology, Geography, you name it.

Obviously this follows a pattern which isn't clearly defined but rather 
abstract. In theory the root hierarchy could also consist of something
entirely different as long as it divides the bookds into a structure
that is exclusive. A book will never be a newspaper and a DVD
will never be a book.
So here we have the one and only rule of the library pattern:

<div class="highlighted">
One level of a hierarchy has to divide all containing items into exclusive
domains.
</div>
<br>
Of course this will cause some friction as some books may contain several
topics. But it's important to stick to the rule, there should be no exception.
So if there's a book about music and the effects on the brain (which is arguably
biology), instead of putting it in either one of them or both, we can create a
new category, e. g. "Mixed topics". That would be overcomplicated for
a library but when working with code, at least when following the library
pattern, it's a necessity. Luckily, we won't have to make up funny names like
"Mixed topics" as we're dealing with problem domains, so they'll have their own
names anyways.

### A project's structure

In a library the name of the root category is obvious: `Library`.
In the library architecture there can be one or more root categories.
They are the index files of our application.
Let's think about a web application that offers both viewing
and modifying a pdf file.
It will have to entry files:

1. view.js
1. editor.js

This means that we'll have files which we'll need for the view only and files
which we'll need for the editor only. But it's obvious that we'll need
files/functionality for both of them, so the file structure should look like
this:

<div class="highlighted" style="padding-top: 0; padding-bottom: 0; background: #272822;">
<pre style="background: none"><code><span style="color: #A6E22E;">/ src/</span>
<span style="color: #A6E22E;">/-- editor/</span>
<span style="color: #A6E22E;">/-- lib/</span>
<span style="color: #A6E22E;">/-- view/</span>
<span style="color: #FD971F;">/-- editor.js</span>
<span style="color: #FD971F;">/-- view.js</span>
</code></pre>
</div>
<br>
There should be no other file or directory on this level!
We're separating our code base into exclusive problem domains.

#### The lib folder

The name doesn't really matter, it could be `helper` or anything else that 
fits. The idea is that code inside this directory has the following purpose:

Transformation on data will be expressed in functions (which will do the
transformation on a given input, returning the calculated result), and should
be reusable. This is where the bottom up approach comes in. If we allow 
some transformations to happen in the view domain, we're tailoring our
application towards a specific problem domain rather than abstracting the
underlying problem domains.
So operations on data should be in the library folder.
Which brings me to the next two folders.

#### The view and editor folders

Code inside these folders should have one role only:
Telling the application what needs to happen.
It shouldn't contain transformations (see one chapter above).
You can think of code inside these folders as controller code
(if you are familiar with MVC).

#### Folders inside the root level folders

Any nested folder follows the same rule.
It's simple and yet requires some planning ahead. 

### Conclusion

There's no generally applicable rule how you should divide the units of your 
application, so I can't give more advice than above and: 

Practice, practice, practice!

You'll quickly notice that - when following this pattern - you'll be able to 
search your code base much quicker than before, even if you learn new concepts
or use different libraries.
It's abstract enough to with all functional libraries
because functional programming - in contrast to design patterns in 
OOP projects - does not enforce an architectural design.

## Redux, React, Rxjs and Reselector

Let's tie the insights of the previous chapter together with currently modern
front-end technology (no one knows how long we'll be using these libraries,
especially in the JavaScript world).

We generally have the following problem domains for which we need a good way 
to approach them.<br>
We need to:

1. define intentions that will trigger the state of our application
to change.
1. define how our state - based on the intention - should be 
changed.
1. define how we handle side effect, like talking to an api.
1. handle derived state so we neither clutter the raw state with derived data 
nor recalculate derived data every time the state updates.

### Composability

We also need to find a way to handle these problem domains in a way
that we can create units which are composable.
Then we'll be able to refactor and extend our functionality easily,
otherwise we'd end up with many concretions which are less reusable,
harder to maintain and generally increase the cognitive load.

### Separation of concerns

As we can see, I've separated the different things we need to do
in order to have a good overview on how we manage our application.
This is the reason why I don't like some heavily used libraries with
redux like redux-thunk. It mixes the intention domain with the IO domain.
When looking inside the actions directory of our application,
there's no way to know which action creator returns an object or a function,
which means it's non-deterministic to know where our IO code is.
Of course this could be expressed as part of the name of the action creator, 
but that would violate the rule of writing declarative, not imperative code.

#### Defining intentions

This is an easy one. With redux we express intentions in actions that can be
dispatched to trigger a state change.

#### Changing the state

This is obviously the role of the reducers. They'll take incoming actions and
the current state to produce a new state.

#### Handling IO / Side effects

This is a bit more tricky as it's not part of the redux library by default.
There are some approaches out there, the 3 most common are:
redux-thunk, redux-saga and redux-observable.

The reason why I reject redux-thunk is mentioned above.
Then there is redux-saga which is a better approach already as we separate
IO into its own problem domain, it's not mixed with the actions anymore.
It's a reasonable choice until you have more complex asynchronicity
in your project.

This is where the true power of redux-observable shines through.
Using RxJs to work on a stream of actions will also
lift the IO / Side effects into their own problem domain.
But we can do a lot more with RxJs than just that.
We can cancel streams, complete streams, compose streams, etc.
That's the reason why redux-observable is my favorite!

#### Handling derived state

A good example for derived state is the redux todo app that you probably
came across when you got into redux. It includes a filter mechanism
to display a subset of of the todos. So you'll end up with two
collections of todos - The complete one and the visible ones.

You could easily filter out the visible ones on each rerender,
which won't have a huge performance impact within the todo app,
but larger applications shouldn't do that for obvious reasons.
Another way of storing this is by using a stateful react component.
It works, is performant but has several problems:

1. You don't separate concerns anymore. Ideally views only work on
the view problem domain.
2. The view is either less reusable or increases the cognitive load
if you read through the code for the first time (after a long time?)
and want to understand how the component works.
3. When mixin components and state,
you won't know where to look for state
in your application when you're new to the project.
4. You won't know that another state came into the application
when another dev added it unless you actually look at the merged code
every time there's a merge.

Alternatively you can store a filtered collection.
In return that means that you'll have to create the collection again
everytime either a todo is added or the filter changes.
You'll end up with two cases for one action 
(which is totally fine, no problems with that) -
but in this case you'll run into weird scenarios.

Is the todo already added to the complete collection before
you filter it or not? You don't know, so you need to perform a check 
which is generally an anti pattern.
Alternatively you can keep an eye on the order of reducers combined
in the root reducer, which is ridiculous
as it increases the complexity enormously.

The answer to this problem: [reselect](https://github.com/reduxjs/reselect)<br>
In combination with redux-react, it becomes quite easy to handle derived data.
I encourage you to read through the README if you haven't done so yet!

### Conclusion

We now solve the 4 previously listed problem domains,
we solve the data transformation domain (the lib folder)
and the presentation domain
(in the example above, it's part of the view end editor folders).
As the redux parts are neither part of the transformation nor the
presentation domain, I like to give redux its own folder on the root level:

<div class="highlighted" style="padding-top: 0; padding-bottom: 0; background: #272822;">
<pre style="background: none;"><code><span style="color: #A6E22E;">| src/</span>
<span style="color: #A6E22E;">|-- editor/</span>
<span style="color: #FD971F;">|---- rootEpic.js</span>
<span style="color: #FD971F;">|---- rootReducer.js</span>
<span style="color: #FD971F;">|---- configureStore.js</span>
<span style="color: #A6E22E;">|-- lib/</span>
<span style="color: #A6E22E;">|-- redux/</span>
<span style="color: #A6E22E;">|---- actions/</span>
<span style="color: #A6E22E;">|---- epics/</span>
<span style="color: #A6E22E;">|---- reducers/</span>
<span style="color: #A6E22E;">|---- selectors/</span>
<span style="color: #FD971F;">|---- configureStore.js</span>
<span style="color: #A6E22E;">|-- view/</span>
<span style="color: #FD971F;">|---- rootEpic.js</span>
<span style="color: #FD971F;">|---- rootReducer.js</span>
<span style="color: #FD971F;">|---- configureStore.js</span>
<span style="color: #A6E22E;">|-- editor.js</span>
<span style="color: #A6E22E;">|-- view.js</span>
</code></pre>
</div>
<br>

As you can see, I've populated some folders with files already.
We obviously can't put the rootReducer and store into the redux folder
as they'll differ from entrypoint to entrypoint, but we can share the
reducers and just combine them to the rootReducers in the editor and
view folders.

The reason why there are three configureStore files is:
We provide a higher order function in the redux/configureStore.js file,
which requires the reducers and epics as arguments, then returns
a function which will setup the store.

## Architectural details

Of course - with the groundwork laid - we're now able to setup
a project so we can work more efficiently, but there are still some
notes I'd like to add in regards to details, technologies and 
dependencies.

### Action type constants

There are a few ways where you can store your action types,
in my opinion there's only one fixed rule.
It needs to be inside the actions folder!
Just think of the library again, where else would you look for action types.
The most obvious place is usually the right place!

#### Constants file vs in-action-creator file

There are pros and cons for putting actions into constants files.
So there's no right or wrong, personally I prefer to put the type 
in the same file where I put the action creator function,
here's an example how I do it with  typescript:

```js
import {Action} from '../index';
import {Streak} from '../../../../lib/streak';

export type AddNewStreakPayload = Streak;
export const ADD_NEW_STREAK = Symbol();
export type CreateAddNewStreakAction = (streak: AddNewStreakPayload) => Action<AddNewStreakPayload>;
export const createAddNewStreakAction: CreateAddNewStreakAction =
    streak => ({
        type: ADD_NEW_STREAK,
        payload: streak,
    });
```

Everything you need to know about the add new streak action is inside this file.
You know what the payload should look like, you know the type constant, and
as you can see, the streak model is inside the lib folder.

### Code of reducers

Regardless of what you use to differentiate between incoming actions
(switch, if/else or the ternary operator - the last one being my favorite),
the reducers should use transformation functionality from the src/lib
folder for two very simple reasons:

1. It'll be obvious where transformations are stored if there's one place only.
1. If you ever decide do dump redux because you've found a better 
alternative, you won't have to split the transformation of data from
the redux code, it's already separate.

This doesn't mean that you need to wrap everything in a function.
Appending an item to an array can still be done inside the reducer:

```js
return [ ...items, newItem ]
```

### RxJs

This is such a powerful library and functional reactive programming
is a very nice approach. But - and this is important - if overused,
**code becomes very complicated, which should be avoided at all costs!**
This is why I think that RxJs should be used for epics only!
That's where we handle side effects, asynchronous code execution, etc.
With redux-observable things become very easy to understand/read.
So let me say this again:

<div class="highlighted">
Inside a redux application, don't use RxJs anywhere but for creating
epics! Period.
</div>
<br>

Don't wrap ajax calls with an Observable, a promise will do fine!
You can switchMap the promise to a stream inside the epic!
This will allow you to use the ajax calls with async/await if you need
this somewhere else in your code
(which you ideally don't as side effects should be handled by epics),
but you can easily compose promise based ajax calls or
extract them into their own library if your project contains multiple
front end applications that work on the same backend and you're not bound
to the RxJs dependency!

Another good reason is that promises are simple, RxJs can make things
complicated quite quickly, which - again - should be avoided at all costs.

### Lodash

Use lodash/fp only. Become familiar with the differences to the normal
lodash, there's a
(lodash/fp guide)[https://github.com/lodash/lodash/wiki/FP-Guide]
that will tell you all the differences.

#### Built-ins vs lodash/fp functions

Using the lodash/fp functions enables you to bring function composition to
the next level. And I strongly encourage to make use of the lodash/fp
functions when glueing units together, especially with compose/pipe!

But when you're actually transforming data, use the built-ins!
This will give you the opportunity to chain commands, like:

```js
collection
    .filter(/* callback */)
    .map(/* callback */)
    .sort(/* callback */)
    .reduce(/* callback */)
;
```

Doing the same operations with the lodash/fp functions just increases
the complexity and therefore the cognitive load when reading through code.

### One function, one job

Every function should do one thing only while the name is declarative
and not imperative! That means that your function's name describes
WHAT's being done and not HOW!

You might ask "But if a function is doing one thing only, how can I
have multiple function calls inside a function".

You still can! Just make sure that the name of the function describes
one operation, let's look at an example:
We have a list of todos but want a list of visible todos, so we create
a function `extractVisibleTodos`.

The name doesn't tell us how the operation is done, it just tells us
what's being done. Internally the function can filter out inactive todos,
then filter for keywords, then group the result by pagination and return
the first page. 
So the function does multiple things while doing one thing only:
Extracting the todos that should be shown from a list of todos.

### One unit per file vs one file containing a group of units

There's no true answer to this question. Many people think that
separating every function into its own file will just make you
jump from file to file while reading through code.
And it's true, you'll spend more time looking through files
if you want to know how things work.

But there's a fundamental difference between wanting to know
how things work and what things do (declarative vs imperative).
If done properly, no file will have more than 10 imports,
most likely it'll have 2-5, which is a very reasonable amount.

When named correctly, fuzzy file search becomes a true blessing.
You just open the fuzzy search and enter the namespace and
part of the function's name that you're looking for and
you're almost there.

Searching large files for a specific function doesn't really solve
the problem either, in the contrary, it will invite you do
ignore the library pattern and just put things where you want
to use it.

### Organizing propTypes in react components

Many times I was unsatisfied with react when I had to update the propTypes
of 5 components because a component deeply nested within the application
was changed.

Then I found an article describing a way to get around this, and it works
really well with the mapStateToProps of the redux-react lib.

Let's say we have a simple button component, called Action, that accepts
the following properties: label, primary (for styling) and onClick.
The Action component is used by another component, the ReloadPageAction
which is rendered by the App component.

```js
// Action.js
import PropTypes from 'prop-types';

export const Action = props => ({
    <button
        onClick={props.onClick}
        className={[
            'action',
            props.primary
                ? 'action--primary'
                : 'action--default',
        ].join(' ')}
    >
        {props.label}
    </button>
});

Action.propTypes = {
    label: PropTypes.string.isRequired,
    onClick: PropTypes.function.isRequired,
    primary: PropTypes.boolean,
};

Action.defaultProps = {
    primary: false,
};
```

```js
// ReloadPageAction.js
import { Action } from './action';

export const ReloadPageAction = props => ({
    <Action
        label="Reload page"
        onClick={props.onPageReloadClick}
    />
});

ReloadPageAction.propTypes = {
    label: Action.propTypes.label,
    onPageReloadClick: Action.propTypes.onClick,
};
```

```js
// App.js
import PropTypes from 'prop-types';
import { ReloadPageAction } from './ReloadPageAction';

export const App = props => ({
    <p>Reload page:</p>
    <ReloadPageAction { ...props.reloadPageAction } />
});

App.propTypes = {
    reloadPageAction: PropTypes.shapeOf(ReloadPageAction.propTypes),
};
```

I defined the propTypes of the app component to include an object
with the shape of the components it will render.
If we do this for all the components, except highly abstract components
(like the Action component in this case),
even if a component is on the  20th level of the render tree is changed,
we only have to adjust 2 parts of our application:

1. the component that we'll change
1. the mapStateToProp function that will transform the state into a deeply
nested object that will be passed to the root component of our app.

If you want to have a look at a working example, check this out:

[This is my Streak Counter Chrome extension still in development](https://github.com/Mohammer5/Streak-counter---Chrome-extension/blob/master/src/streak-counter/View.tsx)

It's written in TypeScript, so there was no need for propTypes anymore,
but the type definitions of the props are exactly what the propTypes
would look like.
If I adjust the properties of the StreakList component that's used
[here]( https://github.com/Mohammer5/Streak-counter---Chrome-extension/blob/master/src/streak-counter/view/overview/Content.tsx ),
the only place where I have to modify code is
[here]( https://github.com/Mohammer5/Streak-counter---Chrome-extension/blob/master/src/streak-counter/initialize/render.tsx ).
