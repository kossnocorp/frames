# Component

Every new feature starts from component. At first you need to deside which
component is needed. If there is no such component, for example you need to
implement smart calendar, before you start need to generate component for it.

Usually it should called like SmartCalendar. If you need to add new UI elements
please welcome to Ui component.

Component is a shared space for views and model-classes. In another words
component is a union of application parts. For example Form component takes
responsobility for forms: validation, submit and displaying results.

Consider components layer as a glue between application pieces.

In component you can describe logic of events and data exchange. Here is rule:
views from different components can communicate with each other only via
component. But you free to break this rule if you don't have compicated logic in
your app.

Also view can trigger DOM event and there is no restriction to listening
for this event and bind some function on it from view related to another
component.

Everything is optional. You can use component only as a namespace just for
couple of views.

## Usage

### Create component

There is 3 ways to register new component:

1. If you are prefer native CoffeeScript class syntax:
  ``` coffeescript
  class SearchForm extends Frames.Component

    prepare: ->
  ```

2. You can use simple but handy DSL:
  ``` coffeescript
  Frames.component 'search_form',

    prepare: ->
  ```

3. Without any logic behind component (creates just empty namespace).
  ``` coffeescript
  Frames.component 'search_form'
  ```

You should include file with component before rest files belongs to this
component:

``` coffeescript
#= require_self
#= require_tree ./views
#= require_tree ./models

Frames.component 'search_form'
```

### Base class created by component



### Component helpers

Component provides

### Prepare function

Sometimes you need to perform some code between first component view will be
created. Maybe you want to read templates from DOM or fetch data from server.

In preare function you also can share some data (e.g collections) between
component views. More in "[Share data between component views]()".


Here is simple example how prepare function can be used:

``` coffeescript
Frames.component 'notifications',

  prepare: ->

```

You can delay view creation by calling start function passed as first argument.

For example, you can wait for response from server:

``` coffeescript
Frames.component 'notifications',

  prepare: (start) ->
    end = start()
    xhr = $.get('/notifications')
    xhr.done(end)
```

View what should be created will be initialized after you will call end
function.

Calling of start function will not stop views creation, but will delay
initialization of views related to this component.

### Share data between component views

In prepare function you can create collections (or set of them) and share
it

component 'browser_tab',

  include: [FghModule, AsdModule]

  map:
    'unread_count': 'contact_list:unread_messages_count'
    'icoming_call': ['contact_list:sdsdgdsg_ertret', (data) ->
      [data.phone, data.name]
    ]

  prepare: ->
    @users = new Users()
    @viewInclude('base', 'allUsers', @users)
    @viewInclude(['asd', 'qwe'], 'allUsers', @users)
    @viewInclude ['asd', 'qwe'],
      allUsers: @users
      chats: => @chats
      w00t: -> asd


### Callbacks

You can add callbacks to such events like "before|after (first) view created".

To add callback you can just put function with specific name to component
prototype and it will be called on event. View will be passed as first argument.

``` coffeescript
Frames.component 'notifications',

  before: (ViewClass) ->
    @debug('View will be created: ', ViewClass)
    @emit('progress:start')

  after: (view) ->
    @emit('progress:end')

```

Here is full list of avaliable callbacks:

* before
* after
* beforeFirst
* afterFirst


###

``` coffeescript
Frames.component 'notifications',

  SearchForm.externalEvents,

    'message_revieved': ->
      @sub('message_recieved', )


```


``` coffeescript
component 'Chat'

  p 'opened'

  api:
    'opened': 'messages_marked_as_read'
    chat:opened,
    @pub('messages_marked_as_read')

component 'ContactList'

  15

  s 'opened' -> 'chat_opened', user.id

  8

component 'TopMenu'

  s 'unread_messages_count'
  s 'unread_system_notifications_count'

  16

#= require_self
#= require views

class BrowserTab

  @include FghModule


BrowserTab.view 'Icon',

  initialize: ->
    @sub('unread_count', @updateNumber)
    @sub('incoming_call', (phone, name) -> ...)
`` `

