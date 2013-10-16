# Frames
![](https://api.travis-ci.org/kossnocorp/frames.png)

## Installation

1. Copy `src` content to `vendor/assets/javascripts/frames`,
2. download and install dependencies; at the moment for Frames.js, needed:
  * jquery_ujs
  * [jquery.role](https://github.com/kossnocorp/role#downloads)
  * underscore
  * backbone
  * [sugar](http://sugarjs.com/)
  * [noted](https://raw.github.com/kossnocorp/noted/master/lib/noted.js)
  * [echoes](https://raw.github.com/kossnocorp/echoes/master/src/echo.coffee)
3. configure manifest:

  ``` coffeescript
  #= require frames
  #= require_self

  $ ->
    Framework.start()
  ```

## Usage

You need such dir structure:

```
- app/assets/javascripts/
  - components/
    - component_name_a/
      - index.js.coffee
      - views/
        - view_name_a.js.coffee
        - view_name_b.js.coffee

  - routers/
    - router_name_a.js.coffee
    - router_name_b.js.coffee
    - ...
```

### Routers

Only one router can exists on the page.

``` coffeescript
class @LandingRouter extends Framework.Router

  # Typical Backbone.js router
```

You have to specify `data-router='landing_router'` on some node to emit
router initialization. Right after DOM ready (and `Framework.start()`)
window.LandingRouter will be created.

### Components

Component is union of views. For example `UiComponent` can have views like
`RadioButtonView`, `CalendarPopupView` etc. Views with more specific purposes
(e.g. `ChatWindowView`, `ChatMessageView` etc) should be grouped in components
for every such purpose.

Example:

`app/assets/javascripts/components/component_name_a/index.js.coffee`:

``` coffeescript
#= require_self
#= require_tree ./views

@ComponentNameAComponent = {}
```

Every component should required manually e.g:

``` coffeescript
#= require frames
#= require ./components/component_name_a
#= require ./components/component_name_b
#= require_self

$ ->
  Framework.start()
```

### Views

Every view should be grouped in component.

Example:

`app/assets/javascripts/components/component_name_a/views/view_name_a`:

``` coffeescript
class @ComponentNameAComponent.ViewNameAView extends Framework.View

  # Typical Backbone.js view
```

To emit view initialization put `data-view='component_name#view_name'` into
some DOM node. View will be initialized after DOM ready with specified node
as `el`.

You can specify two or more views with space as delimeter.

You can just put `view_name` without specifing component name then
`SharedComponent.ViewNameView` will be created.

For dynamically appended html, you need to call function that find new nodes
with views and initializes them:

``` coffeescript
$container.html(newHtml)
Framework.ViewsFactory.create($container, false)
```

Second argument means what you don't need to look into $container itself.
With `true` `Framework.ViewsFactory.create` will lookup for `data-view`
in $container too.

`Framework.ViewsFactory.create` creates view only for new nodes. Nodes with
already initialized views will be ignored.

