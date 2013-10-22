# Behaviors

* `Frames.Behavior` is a class inherited from `Frames.View`.
* Consider behavior as an isolated functionality applies to a view.
* Unlike regular views, there is no way to create behaviors via
  `data-*` attribute. Behaviors can be created only with views.
* Behaviors have limited view API doesn't have access to pub/sub,

## API

### `Frames.View` functions

#### `behaviors` list

`behaviors` is a property of view contains list of behaviors that should
be applied to view's `$el`.



``` coffeescript
class UiComponent.SliderView extends Frames.View

  behaviors: ['ui#draggable', 'ui#resizable']
```
