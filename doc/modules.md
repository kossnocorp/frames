# Frames modules

Frames module is a small, responsible for single task, mostly isolated
piece of the framework.

Every Frames module can be extended or replaced with a custom one.

Frames has two types of modules:

* [Core modules](https://github.com/kossnocorp/frames/blob/master/doc/modules.md) -
  system modules which are not used directly in application code,
  but shape it's behavior. E.g factories, launcher, logger module and
  so on.
* [Base modules](https://github.com/kossnocorp/frames/blob/master/doc/modules.md) -
  modules actively used in application code. E.g base classes of view, view
  models, models and so on.
