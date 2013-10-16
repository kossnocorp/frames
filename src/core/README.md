# Core classes

Contain set of core framework classes. Provides base functionlity.

All classes can be replaced with custom.

## Quick overview

Here is quick overview of classes situated in this directory:

* **Framework**: base namespace. It used for registering and run
  factories.
* **Framework.Class**: base class for every class in Framework and application.
  Provides base class functions like include, extend, accessor etc.
* **Framework.Base**: base class for every class in Framework
  Provides functional for logging and communicating.
* **Framework.BaseFactory**: base class for every factory class in Framework
  (e.g. Framework.ViewFactory).
* **Framework.RouterFactory**: default routers factory.
* **Framework.ViewsFactory**: default views factory.
* **Framework.Logger**: default applicatation logger.
* **Framework.Starter**: default framework starter. Wraps Framework.start into
  try-catch and run it on DOM ready (depends on jQuery or Zepto.js).
