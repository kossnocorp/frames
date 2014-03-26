# Frames.State

State is one of [the base Frames core classes](./../base_core_classes.md).
It represents [finite-state machine](http://en.wikipedia.org/wiki/Finite-state_machine).

## Usage

### Basic example

Definition:

``` coffeescript
class TrafficLights extends Frames.State

  # Avaliable states list
  states: [
    'red'
    'yellow'
    'green'
  ]

  # Default state
  default: 'red'

  # Events list
  events:
    makeRed: from: 'yellow', to: 'red'
    makeGreen: from: 'yellow', to: 'green'
    makeYellow: from: ['red', 'green'], to: 'yellow'
```

Usage example:

``` coffeescript
trafficLights = new TrafficLights()
trafficLights.get()
# => 'red'

trafficLights.makeYellow()
trafficLights.get()
# => 'yellow'

trafficLights.makeGreen()
trafficLights.get()
# => 'green'

trafficLights.makeRed()
# => throw "Transition from 'green' to 'red' is not allowed"
trafficLights.get()
# => 'green'
```

### Manual transition:

``` coffeescript
trafficLights.set('yellow')
trafficLights.get()
# => 'yellow'

trafficLights.set('green')
trafficLights.get()
# => 'green'

trafficLights.set('red')
# => throw ReferenceError
trafficLights.get()
# => 'green'
```

### Avaliable states

``` coffeescript
trafficLights.availableStates()
#=> ['red', 'yello', 'green']
```

### Callbacks

#### State callbacks

State callbacks is are callbacks that are called before state transition.

``` coffeescript
class Timer extends Frames.State

  states: ['stopped', 'started']

  default: 'stopped'

  events:
    start: from: 'stopped', to: 'started'
    stop: from: 'started', to: 'stopped'

  # Will be called on stop() or set('stopped')
  onStopped: ->

  # Will be called on start() or set('started')
  onStarted: ->
```

``` coffeescript
timer = new Timer()
timer.start() # timer.onStarted is called
timer.stop()  # timer.onStopped is called
```

### Resetting

``` coffeescript
timer = new Timer()
timer.start()
timer.reset() # timer.onReset was called
timer.get()
# => 'stopped'
```

### Constructor

Frames.State accepts default state as first argument:

``` coffeescript
state = new Frames.State('default')
state.get()
#=> 'default'
```

You can pass list of states as property of second argument:

``` coffeescript
state = new Frames.State('a', states: ['b', 'c'])
state.availableStates()
#=> ['a', 'b', 'c']
```

Same for events:

``` coffeescript
events =
  lock: from: 'unlocked', to: 'locked'
  unlock: from: 'locked', to: 'unlocked'
state = new State('locked', states: ['locked', 'unlocked'], events: events)
state.unlock()
state.get()
#=> 'unlocked'
```

## Integration with Frames.Class

### Definition

Short syntax:

``` coffeescript
class ClassWithState extends Frames.Class

  @state 'lights', ['red', 'yellow', 'green'], default: 'red', events:
    makeRed: from: 'yellow', to: 'red'
    makeGreen: from: 'yellow', to: 'green'
    makeYellow: from: ['red', 'green'], to: 'yellow'
```

### Usage

``` coffeescript
test = new ClassWithState()
test.state('lights') # Returns Frames.State instance
```
