# Frames.Promise

Promise is one of [base Frames core classes](./../base_core_classes.md). It
provides basic [promises](http://en.wikipedia.org/wiki/Promise_(programming))
functionality.

Frames.Promise follows [Promises/A+](http://promises-aplus.github.io/promises-spec)
spec.

## API

### `constructor`

``` coffeescript
promise = new Frames.Promise()
```

### `promise.then`

``` coffeescript
promise.then(onFulfilled, onRejected)
```
