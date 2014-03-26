# Frames.deferred

## API

### `constructor`

```  coffeescript
deferred = new Frames.deferred()
```

### Binding (`done`, `fail`, `always`)

``` coffeescript
deferred.done(onDone).fail(onFail).always(onDoneAndFail)
```

### Resolving (`resolve`, `reject`)

``` coffeescript
deferred.resolve(arg1, arg2)
```

``` coffeescript
deferred.reject('Reason, why?')
```

### State

``` coffeescript
deferred.isRejected()
deferred.isResolved()
```
