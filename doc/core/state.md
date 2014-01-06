# Frames.State

State is one of the base Frame classes (along with Frames.Class and Frames itself). It represents finite state
machine.

## Usage

### Basic example

Definition:

``` coffeescript
class TrafficLights extends RedYellowGreen

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
    makeRed: 'yellow -> red'
    makeGreen: 'yellow -> green'
    makeYellow: 'red, green -> yellow'
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
# => throw ReferenceError
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

### Callbacks

``` coffeescript
class Timer extends Frames.State

  states: ['stopped', 'started']

  default: 'stopped'

  events:
    start: 'stopped -> started'
    stop: 'started -> stopped'

  # Will be called on stop() or set('stop')
  onStopped: ->

  # Will be called on start() or set('start')
  onStarted: ->
```

``` coffeescript
timer = new Timer()
timer.start() # timer.onStarted was called
timer.stop()  # timer.onStopped was called
```

### Resetting

``` coffeescript
timer = new Timer()
timer.start()
timer.reset() # timer.onReset was called
timer.get()
# => 'stopped'
```

## Integration with Frames.Class

### Definition

Short syntax:

``` coffeescript
class ClassWithState extends Frames.Class

  @state 'lights', ['red', 'yellow', 'green'], default: 'red', events:
    makeRed: 'yellow -> red'
    makeGreen: 'yellow -> green'
    makeYellow: 'red, green -> yellow'
```

Splitted definition:

``` coffeescript
class ClassWithState extends Frames.Class

  @state 'lights', ['red', 'yellow', 'green']

  lightsDefault: 'red'

  lightsEvents:
    makeRed: 'yellow -> red'
    makeGreen: 'yellow -> green'
    makeYellow: 'red, green -> yellow'
```

### Usage

``` coffeescript
test = new ClassWithState()
test.state('lights') # Returns Frames.State instance
```
