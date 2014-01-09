# Frames.Launcher

Launcher is a class responsible for starting application.

Launcher automatically runs `Frames.start` once DOM is ready so you
don't need to do it manually. It simplifies process of starting work on
new application and keeps code a bit cleaner.

Second purpose is hooks. Pretty often you need to run some code
before DOM will be completly loaded (e.g CSS3 fallbacks), right before
application will be started (e.g data preparation) or after. Launcher
gives an ability to add hooks on all of these stages, as well as create
custom hook types and hook processors.

## Initialization stages

There are three main stages of application initialization process:

* Framework code is loaded (`loaded` hook),
* DOM is ready (`ready` hook),
* Factories are created (`created` hook)

## Installation

If you are using [Ruby on Rails integration](https://github.com/kossnocorp/frames/blob/master/doc/rails.md)
you don't need to do anything.

If you need to customize the list of used [Frames modules](https://github.com/kossnocorp/frames/blob/master/doc/modules.md)
or if you want to use a custom launcher you have to require your
launcher file from core modules manifest.

Read more about requiring Frames modules at ["Installation" page](https://github.com/kossnocorp/frames/blob/master/doc/installation.md).

## Usage

Call `Frames.hook` and pass hook type as first and callback function as
second argument.

``` coffeescript
Frames.hook 'loaded', ->
  # Do some stuff right after the hook has fired
```

There is no way to specify callbacks order, so they should be isolated
and independent.

There are three hook types that represent main initialization stages:

* `loaded` - runs callback once Frames code is loaded.
* `ready` - callback will be called on DOM ready.
* `created` - callback will be called after all factories are created.

If hook is added after stage initialization stage has passed it will be
called immediately.

## Holding stages

If you need to pause initialization process (e.g when you need to fetch
some important initial data), you can use pause method of the hook
object that is passed as first argument to the callback function.
To continue initialization you need to call `hook.unpause`.

``` coffeescript
Frames.hook 'loaded', (hook) ->
  hook.pause ->
    processSomeData()
```

Once `processSomeData finished polling data, unpause will be called
automatically. If no callback is provided, `hook.unpause` should be
called explicitly.

`hook.pause` function will not affect another hook attached to the
current stage. Other hooks will be called in the same order as before.
However, if any of the hooks on a stage are currently paused, then the
framework will not move to the next stage (e.g. from loaded to ready),
until all hooks are unpaused.

**Warning**: in the given example `pause` blocks initialization process
and creation of factories will be held. That means that no views
will be created. It may have significant impact on application
responsiveness but sometimes it's really useful.

For example you may want to load some bootstrap data at `loaded` stage
and postpone application rendering because it it is highly dependent
on that data. Another good example of proper usage of `pause` function
is async loading of application components.

## Files organization

There are 2 ways of files organization:

1. Single file per hook type:

  ```
  app
  `-- hooks
      |-- loaded_hooks.js.coffee
      `-- created_hooks.js.coffee
  ```

2. File per hook:

  Once you will have more than two hooks in single file (which is pretty
  rare) you will probably want to split your hooks according to single
  class per file rule:

  ```
  app
  `-- hooks
      |-- loaded
      |   |-- analytics_hook.js.coffee
      |   `-- modernizr_hook.js.coffee
      `-- created
          `-- analytics_hook.js.coffee
  ```

## Custom hook types

TODO

## Custom launcher

TODO

## Bultin extensions

TODO

### Document events

It's an optional hooks extension coming with Frames which simplifies
process of binding document events to views.

This resolves 2 problems:

* With Turbolinks you can't keep document bindings in views because of
  memory leaking and fantom behavior (caused by multiple bindings to
  same events).
* And in general it's a bad idea to do it because it may make an
  isolation breach and one day you will have problem with behavior
  conflict, leaked memory and will spend hours in the debugger.

It adds loaded hook and delegates all document (and body) events to all
the views via pub/sub service.

It also disallows all document bind calls from views to prevent
accidentally attached callbacks.

This is default behavior, but it can be adjusted by other extensions.

TODO
