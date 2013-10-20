# Core classes

Contain set of core framework classes. Provides base functionlity.

All classes can be replaced with custom.

## Quick overview

Here is quick overview of classes situated in this directory:

* **Frames**: base namespace. It used for registering and run
  factories.
* **Frames.Class**: base class for every class in Frames and application.
  Provides base class functions like include, extend, accessor etc.
* **Frames.Base**: base class for every class in Frames
  Provides functional for logging and communicating.
* **Frames.BaseFactory**: base class for every factory class in Frames
  (e.g. Frames.ViewFactory).
* **Frames.RouterFactory**: default routers factory.
* **Frames.ViewsFactory**: default views factory.
* **Frames.Logger**: default applicatation logger.
* **Frames.Starter**: default framework starter. Wraps Frames.start into
  try-catch and run it on DOM ready (depends on jQuery or Zepto.js).
