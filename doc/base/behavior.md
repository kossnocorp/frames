# Frames.Behavior

**Behavior** is a special subset of **[view](https://github.com/kossnocorp/frames/blob/master/doc/base/view.md)**
and it has his own features and limitations. **Behavior** is useful if
you want to add some additional behavior to existing view but don't want
to increase complexity of target view class.

## Ideas behind behaviors

Behavior let you follow [single responsibility principle](http://en.wikipedia.org/wiki/Single_responsibility_principle)
and isolate piece of view functionality which can't be splitted to
independent view.

As an example, imagine testimonials slider like this one

```
  +------------------------------------+
  |                                    |
  |  Behavior is an amazing concept!   |
<+|                                    |+>
  |            *                       |
  |            1 2 3 4 5 6             |
  +------------------------------------+
```

At first you are probably will want to attach click ovent to 1, 2, 3... links.
On click this slider will change text to `data-text` passed link. Run it,
test it, it works just fine!

```
  +------------------------------------+
  |                                    |
  |  Behaviors helps me keep my code   |
  |  clean and extremly readable!      |
<+|  I'm just love it!                 |+>
  |                                    |
  |              *                     |
  |            1 2 3 4 5 6             |
  +------------------------------------+
```

But you annoyed with jumping height of the slider. What you going to do? Right,
you going to write some piece of code that makes container height equal to
height of longest text in your collection. Run it, test it and again, it works
just fine. But your code is look like mess now. You just coupled _text swap_
behavior with _fixed height_ behavior. Behaviors as an abstraction comes into play
here. That is you need here is to move code related to fixing height to
additional class, attach it to gallery view and... voilà!

This is how behaviors helps to make your code cleaner.

Behaviors also useful for sharing functionality between different views. For
example _draggable_ behavior can be used in _sortable list item_ as well as in
_slider_ view. Another good example of behavior is a _spinner_ that can be
attached to wide range of views.

## Frames.Behavior overview

TODO

## Frames.View integration

### Access behavior public API

TODO

### Manual

Behaviors can be created with `@createBehavior` function:

``` coffeescript
class TasksView extends Frames.View

  initialize: ->
    @createBehavior('draggable')
```

It will pass `el: @el` to behavior constructor. If you need to, you can
specify `el` manually:

``` coffeescript
$list = @$el.find('.list')
@draggable = @createBehavior('draggable', el: $list)
```

Options object will be passed to behavior constructor:

``` coffeescript
@draggable = @createBehavior('draggable', disabled: true)
```

### Automated

Along with a manual initialization, behavior(s) can be attached to view
via shortcut:

``` coffeescript
class TasksView extends Frames.View

  behaviors: ['draggable', 'sortable', 'deletable']
```

### Accessing behaviors

TODO

### Attaching behaviors via data-behavior

TODO

### Disable behaviors via data-exclude-behavior

TODO
