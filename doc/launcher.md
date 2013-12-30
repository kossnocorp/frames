# Frames.Launcher

Launcher is a class responsible for starting application.

Launcher automatically runs `Frames.start` once DOM is ready so you
don't need to do it manually. It simplifies process of starting work on
new application and keeps code a bit cleaner.

Second purpose is a hooks. Pretty often you need to run some code
before DOM will be completly loaded (e.g CSS3 fallbacks), right before
application will be started (e.g data preparation) of after. Launcher
gives ability to add hooks on all of these stages, as well as create
custom hook types and hook processors.

## Initialization stages

There is tree main stages of application initialization process:

* Framework code is loaded (`loaded` hook),
* DOM is ready (`ready` hook),
* Factories are created (`created` hook)

## Installation

If you are using [Ruby on Rails integration](https://github.com/kossnocorp/frames/blob/master/doc/rails.md)
you don't need to do anything.

In case when you need to customize list of used [Frames modules](https://github.com/kossnocorp/frames/blob/master/doc/modules.md)
or if you want to use your custom launcher you have to put launcher file
require to your file to core modules manifest.

Read more about requiring Frames modules at ["Installation" page](https://github.com/kossnocorp/frames/blob/master/doc/installation.md).

## Usage

Call `Frames.hook` and pass hook type as first argument and callback
what should be called on specific stage as second argument.

``` coffeescript
Frames.hook 'loaded', ->
  # Do some stuff right after
```

There is no way to specify callbacks order, so they should be isolated
and independent.

There is tree hook types respresents main stages:

* `loaded` - runs callback once Frames code is loaded.
* `ready` - callback will be called on DOM ready.
* `created` - callback will be called after all factories are worked.

If hook will be added after stage is initialized in will be called
immediately.

## Holding stages

If you need to pause initialization process (e.g when you need to fetch
some important initial data), you can use `pause` function passed to
callback as first argument. To continue initialization you need to
call `unpause` passed as second argument:

``` coffeescript
Frames.hook 'loaded', (pause, unpause) ->
  pause()
  doSomeStuff ->
    unpause()
```

`pause` function will not affect another hooks attached to the current
stage. Rest hooks will be called in same order as before. But when
`unpause` function is not yet called and in the same time framework is
ready to move up to the next stage (e.g `ready`) then stage transition
will be posponed until `unpause` function is called.

You can use as many pauses as you want to. Next stage will be started
once all unpause functions are called.

**Warning**: in the given example `pause` blocks initialization process
and creation of factories will be holded. What is mean that no views
will be created. It may have significant impact on application
responsobility but sometimes it's really usefull.

For example you may want to load some bootstrap data at `loaded` stage
and postpone application rendering because it highly depends on that
data. Another good example of proper using of `pause` function is a
async loading of application components.

## Files organization

There is 2 recommended ways to files organization:

1. Single file per hook type:

  ```
  + app
    + hooks
      - loaded_hooks.js.coffee
      - created_hooks.js.coffee
  ```

2. File per hook:

  Once you will have more than two hooks in single file (what is pretty
  rare) you probably will want to split your hooks according to rule
  single class per file:

  ```
  + app
    + hooks
      + loaded
        - analytics_hook.js.coffee
        - modernizr_hook.js.coffee
        -
      + created
        - analytics_hook.js.coffee
    - ...
  ```

## Custom hook types

TODO

## Custom launcher

TODO

## Bultin extensions

TODO

### Document events

It's an optional hooks extension coming with Frames which simplifying
process of binding documents events to views.

This is solution for two issues:

* With Turbolinks you can't keep document bindings in views because of
  memory leaking and fantom behavior (caused by multiply bindings to
  same events).
* And in general it's a bad idea to do it because it makes isolation
  breach and one day you will meet problem with behaviors conflict,
  leaked memory and will spend hours in debugger.

It's adds loaded hook and delegated all document (and body) events to all the views via pub/sub service.

It's also disallows all document bind calls from views to prevent accidentally attached callbacks.

This is default behavior, but as other extension features it can be adjusted.

TODO
