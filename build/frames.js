/*! frames (v0.1.3),
 Front-end framework,
 by Sasha Koss <kossnocorp@gmail.com>
 Tue Sep 09 2014 */
(function() {
  var modules;

  modules = {};

  if (window.modula == null) {
    window.modula = {
      "export": function(name, exports) {
        return modules[name] = exports;
      },
      require: function(name) {
        var Module;
        Module = modules[name];
        if (Module) {
          return Module;
        } else {
          throw "Module '" + name + "' not found.";
        }
      }
    };
  }

}).call(this);

(function() {
  var __hasProp = {}.hasOwnProperty,
    __slice = [].slice;

  this.Frames = (function() {
    function Frames() {}

    Frames.Extendables = {};

    Frames.createExtendables = function() {
      var klass, name, _ref, _results;
      if (this.extendables == null) {
        this.extendables = {};
      }
      _ref = this.Extendables;
      _results = [];
      for (name in _ref) {
        if (!__hasProp.call(_ref, name)) continue;
        klass = _ref[name];
        if (!Object.isFunction(klass.prototype.extended)) {
          throw 'Trying to initialize extendable module, but #extended method is not specified for it.';
        }
        _results.push(this.extendables[name.underscore()] = new klass());
      }
      return _results;
    };

    Frames.extend = function() {
      var args, moduleName, _ref;
      moduleName = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      if (this.extendables[moduleName] == null) {
        throw "Trying to extend module " + (moduleName.camelize()) + ", but it is not registered.";
      }
      return (_ref = this.extendables[moduleName]).extended.apply(_ref, args);
    };

    Frames.registerLauncher = function(Launcher) {
      return this.__launcher = new Launcher();
    };

    Frames.hook = function(type, callback) {
      if (!this.__launcher) {
        throw 'Launcher is not registered';
      }
      return this.__launcher.hook(type, callback);
    };

    Frames.start = function() {
      var extendable, name, _ref, _results;
      _ref = this.extendables;
      _results = [];
      for (name in _ref) {
        if (!__hasProp.call(_ref, name)) continue;
        extendable = _ref[name];
        _results.push(typeof extendable.ready === "function" ? extendable.ready() : void 0);
      }
      return _results;
    };

    Frames.stop = function() {};

    return Frames;

  })();

  modula["export"]('frames', Frames);

}).call(this);

(function() {
  var Echo, Frames, LEVELS, LoggerModule, level, _i, _len,
    __slice = [].slice;

  Frames = modula.require('frames');

  Echo = window.Echo;

  LEVELS = 'debug info warn error'.split(' ');

  LoggerModule = {
    included: function(klass) {
      if (this.echo == null) {
        this.echo = Echo();
      }
      return klass.extend(this);
    },
    log: function(text, options) {
      if (options == null) {
        options = {};
      }
      return this.logger(text, options);
    },
    logger: function() {
      var args;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      return LoggerModule.echo.apply(LoggerModule, args);
    }
  };

  for (_i = 0, _len = LEVELS.length; _i < _len; _i++) {
    level = LEVELS[_i];
    LoggerModule[level] = function(text, options) {
      return this.log(text, Object.extended(options).clone().merge({
        level: level
      }));
    };
  }

  modula["export"]('frames/logger_module', LoggerModule);

}).call(this);

(function() {
  var Backbone, Frames, LoggerModule, klass, _i, _len, _ref;

  Frames = modula.require('frames');

  LoggerModule = modula.require('frames/logger_module');

  Backbone = window.Backbone;

  this.Class = (function() {
    function Class() {}

    Class.include = function(module) {
      Object.merge(this.prototype, Object.reject(module, 'included', 'extended'));
      if (module.included) {
        return module.included(this);
      }
    };

    Class.extend = function(module) {
      Object.merge(this, Object.reject(module, 'included', 'extended'));
      if (module.extended) {
        return module.extended(this);
      }
    };

    Class.attr = function(name, options) {
      if (options == null) {
        options = {};
      }
      this.attrReader(name, options);
      return this.attrWriter(name, options);
    };

    Class.attrReader = function(name, options) {
      var privateName;
      if (options == null) {
        options = {};
      }
      privateName = this.__privateNameFor(name);
      return this.prototype[this.__getterNameFor(name, options)] = function() {
        return this[privateName];
      };
    };

    Class.attrWriter = function(name, options) {
      var privateName;
      if (options == null) {
        options = {};
      }
      privateName = this.__privateNameFor(name);
      this.prototype[this.__setterNameFor(name, options)] = function(val) {
        return this[privateName] = val;
      };
      if (options.boolean) {
        if (options["true"]) {
          this.prototype[options["true"]] = function() {
            return this[privateName] = true;
          };
        }
        if (options["false"]) {
          return this.prototype[options["false"]] = function() {
            return this[privateName] = false;
          };
        }
      }
    };

    Class.patch = function(klass) {
      Object.merge(klass, this);
      return Object.merge(klass.prototype, this.prototype);
    };

    Class.__getterNameFor = function(name, options) {
      if (options == null) {
        options = {};
      }
      return options.getter || this.__fnName(name, {
        prefix: options.boolean ? 'is' : 'get'
      });
    };

    Class.__setterNameFor = function(name, options) {
      if (options == null) {
        options = {};
      }
      return options.setter || this.__fnName(name, {
        prefix: 'set'
      });
    };

    Class.__privateNameFor = function(name) {
      return "__" + name;
    };

    Class.__fnName = function(name, options) {
      var parts;
      if (options == null) {
        options = {};
      }
      parts = [];
      if (options.prefix) {
        parts.push(options.prefix);
      }
      parts.push(name);
      return parts.join('_').camelize(false);
    };

    Class.include(LoggerModule);

    return Class;

  })();

  _ref = 'View Model Collection Router'.split(' ');
  for (_i = 0, _len = _ref.length; _i < _len; _i++) {
    klass = _ref[_i];
    Class.patch(Backbone[klass]);
  }

  modula["export"]('frames/class', Class);

}).call(this);

(function() {
  var Frames, State;

  Frames = modula.require('frames');

  State = (function() {
    function State(defaultState, options) {
      var state, _i, _len, _ref;
      if (defaultState == null) {
        defaultState = null;
      }
      if (options == null) {
        options = {};
      }
      if (this.states == null) {
        this.states = [];
      }
      if (options.states != null) {
        _ref = options.states;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          state = _ref[_i];
          this.states.push(state);
        }
      }
      if (options.events != null) {
        this.events = options.events;
      }
      if (defaultState != null) {
        this.states.push(defaultState);
        this["default"] = defaultState;
      }
      this.__rules = {};
      this.__defineEvents();
      this.__forceSet(this.__default());
    }

    State.prototype.get = function() {
      return this.__state;
    };

    State.prototype.set = function(state) {
      var callback;
      if (!this.__isStateDefined(state)) {
        throw "No such state '" + state + "'";
      }
      if (!this.__isTransitionAllowed(state)) {
        throw "Transition from '" + (this.get()) + "' to '" + state + "' is not allowed";
      }
      callback = this.__callbackFor(state);
      if (typeof callback === "function") {
        callback(this.get(), state);
      }
      return this.__state = state;
    };

    State.prototype.reset = function() {
      if (typeof this.onReset === "function") {
        this.onReset(this.get(), this.__default());
      }
      return this.__forceSet(this.__default());
    };

    State.prototype.availableStates = function() {
      return this.states;
    };

    State.prototype.__forceSet = function(__state) {
      this.__state = __state;
    };

    State.prototype.__default = function() {
      return this["default"] || this.states[0];
    };

    State.prototype.__defineEvents = function() {
      var name, rules, _ref, _results;
      _ref = this.events;
      _results = [];
      for (name in _ref) {
        rules = _ref[name];
        _results.push(this.__defineEvent(name, rules));
      }
      return _results;
    };

    State.prototype.__defineEvent = function(name, rules) {
      this.__applyRules(name, rules);
      return this[name] = function() {
        return this.set(rules.to);
      };
    };

    State.prototype.__applyRules = function(name, rules) {
      var from, origin, _base, _i, _len, _results;
      from = typeof rules.from === 'object' ? rules.from : [rules.from];
      _results = [];
      for (_i = 0, _len = from.length; _i < _len; _i++) {
        origin = from[_i];
        if ((_base = this.__rules)[origin] == null) {
          _base[origin] = [];
        }
        _results.push(this.__rules[origin].push(rules.to));
      }
      return _results;
    };

    State.prototype.__isStateDefined = function(state) {
      return this.states.indexOf(state) !== -1;
    };

    State.prototype.__isTransitionAllowed = function(state) {
      var allowedStates;
      allowedStates = this.__rules[this.get()];
      return allowedStates && allowedStates.indexOf(state) !== -1;
    };

    State.prototype.__callbackFor = function(state) {
      var callbackName;
      callbackName = ("on_" + state).camelize(false);
      return this[callbackName];
    };

    return State;

  })();

  modula["export"]('frames/state', State);

}).call(this);

(function() {
  var Frames,
    __slice = [].slice;

  Frames = modula.require('frames');

  Frames.Extendables.RoutersFactory = (function() {
    function RoutersFactory() {
      this.routersFactory = modula.require('frames/routers_factory');
    }

    RoutersFactory.prototype.extended = function() {
      var args, routersFactory;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      routersFactory = args[0];
      return this.routersFactory = routersFactory;
    };

    RoutersFactory.prototype.ready = function() {
      return this.routersFactory.create();
    };

    return RoutersFactory;

  })();

  modula["export"]('frames/extendables/routersFactory', Frames.Extendables.RoutersFactory);

}).call(this);

(function() {
  var Frames,
    __slice = [].slice;

  Frames = modula.require('frames');

  Frames.Extendables.ViewsFactory = (function() {
    function ViewsFactory() {
      this.viewsFactory = {
        create: function() {
          return Vtree.initNodes();
        }
      };
    }

    ViewsFactory.prototype.extended = function() {
      var args, viewsFactory;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      viewsFactory = args[0];
      return this.viewsFactory = viewsFactory;
    };

    ViewsFactory.prototype.ready = function() {
      return this.viewsFactory.create();
    };

    return ViewsFactory;

  })();

  modula["export"]('frames/extendables/views_factory', Frames.Extendables.ViewsFactory);

}).call(this);

(function() {
  var Backbone, Class, Frames, RoutersFactory,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Frames = modula.require('frames');

  Class = modula.require('frames/class');

  Backbone = window.Backbone;

  RoutersFactory = (function(_super) {
    var ROUTERS_SELECTOR;

    __extends(RoutersFactory, _super);

    function RoutersFactory() {
      return RoutersFactory.__super__.constructor.apply(this, arguments);
    }

    ROUTERS_SELECTOR = '[data-router]';

    RoutersFactory.create = function() {
      var Router, router, routerClassName, routerName;
      routerName = this.detectRouter();
      if (routerName) {
        routerClassName = routerName.camelize() + 'Router';
        Router = window[routerClassName];
        if (Router) {
          router = new Router();
          $('body').data({
            router: router
          });
          Backbone.history.start();
          return this.router = router;
        }
      }
    };

    RoutersFactory.destroy = function() {
      $('body').removeData('router');
      return Backbone.history.stop();
    };

    RoutersFactory.detectRouter = function() {
      var routers;
      routers = this.routers();
      if (routers.length > 1) {
        this.warn('There are more than one router, all except first will be ignored.');
      }
      return routers[0];
    };

    RoutersFactory.routers = function() {
      var $els, $root;
      $root = $('body');
      $els = $root.find(ROUTERS_SELECTOR).add($root.filter(ROUTERS_SELECTOR));
      return $els.map(function() {
        return $(this).data('router');
      }).toArray();
    };

    return RoutersFactory;

  })(Class);

  modula["export"]('frames/routers_factory', RoutersFactory);

}).call(this);

(function() {
  var Frames, JqueryQueryModule;

  Frames = modula.require('frames');

  JqueryQueryModule = {
    included: function(klass) {
      return klass.addToConfigureChain('buildQueryFunctions');
    },
    buildQueryFunctions: function() {
      var dirtyQuery, fnName, _ref, _results;
      if (!this.els) {
        return;
      }
      _ref = this.els;
      _results = [];
      for (fnName in _ref) {
        dirtyQuery = _ref[fnName];
        _results.push((function(_this) {
          return function(fnName, dirtyQuery) {
            var dropFnName, isCached, privateName, query, __, _ref1;
            _ref1 = dirtyQuery.match(/^(cached)?\s?(.+)/), __ = _ref1[0], isCached = _ref1[1], query = _ref1[2];
            if (isCached) {
              privateName = "__" + fnName;
              dropFnName = ("" + fnName + "_drop").camelize();
              _this[fnName] = function() {
                return this[privateName] || (this[privateName] = this.$(query));
              };
              return _this[dropFnName] = function() {
                return this[privateName] = void 0;
              };
            } else {
              return _this[fnName] = function() {
                return this.$(query);
              };
            }
          };
        })(this)(fnName, dirtyQuery));
      }
      return _results;
    }
  };

  modula["export"]('frames/jquery_query_module', JqueryQueryModule);

}).call(this);

(function() {
  var Frames, PubSubModule;

  Frames = modula.require('frames');

  PubSubModule = {
    included: function(klass) {
      this.broker = new Noted.Broker();
      return klass.addToConfigureChain('createEmitterAndReceiver');
    },
    createEmitterAndReceiver: function() {
      this.broker = PubSubModule.broker;
      this.emitter = new Noted.Emitter(this.broker, this);
      return this.receiver = new Noted.Receiver(this.broker, this);
    },
    emit: function(message, body, options) {
      return this.emitter.emit(message, body, options);
    },
    listen: function(message, callback, options) {
      return this.receiver.listen(message, callback, options);
    },
    unsubscribe: function(message, callback, context) {
      return this.broker.unsubscribe(message, callback, this);
    }
  };

  modula["export"]('frames/pub_sub_module', PubSubModule);

}).call(this);

(function() {
  var Backbone,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  modula.require('frames');

  Backbone = window.Backbone;

  Frames.Model = (function(_super) {
    __extends(Model, _super);

    function Model() {
      return Model.__super__.constructor.apply(this, arguments);
    }

    return Model;

  })(Backbone.Model);

  modula["export"]('frames/model', Frames.Model);

}).call(this);

(function() {
  var Backbone, Frames, PubSubModule,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Frames = modula.require('frames');

  Backbone = window.Backbone;

  PubSubModule = modula.require('frames/pub_sub_module');

  Frames.Router = (function(_super) {
    __extends(Router, _super);

    function Router() {
      return Router.__super__.constructor.apply(this, arguments);
    }

    Router.prototype._bindRoutes = function() {
      this.createEmitterAndReceiver();
      return Backbone.Router.prototype._bindRoutes.call(this);
    };

    Router.prototype.createEmitterAndReceiver = function() {
      this.broker = PubSubModule.broker;
      this.emitter = new Noted.Emitter(this.broker, this);
      return this.receiver = new Noted.Receiver(this.broker, this);
    };

    Router.prototype.emit = function(message, body, options) {
      return this.emitter.emit(message, body, options);
    };

    Router.prototype.listen = function(message, callback, options) {
      return this.receiver.listen(message, callback, options);
    };

    Router.prototype.unsubscribe = function(message, callback, context) {
      return this.broker.unsubscribe(message, callback, this);
    };

    return Router;

  })(Backbone.Router);

  modula["export"]('frames/router', Frames.Router);

}).call(this);

(function() {
  var Backbone, Frames, originRemove,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Frames = modula.require('frames');

  Backbone = window.Backbone;

  originRemove = Backbone.View.prototype.remove;

  Frames.View = (function(_super) {
    __extends(View, _super);

    View.addToConfigureChain = function(fnName) {
      if (this.configureChain == null) {
        this.configureChain = [];
      }
      return this.configureChain.push(fnName);
    };

    View.addToRemoveChain = function(fnName) {
      if (this.removeChain == null) {
        this.removeChain = [];
      }
      return this.removeChain.push(fnName);
    };

    function View(options) {
      var configureChain, fnName, _i, _len;
      configureChain = this.constructor.configureChain;
      if (configureChain) {
        for (_i = 0, _len = configureChain.length; _i < _len; _i++) {
          fnName = configureChain[_i];
          this[fnName].call(this, options);
        }
      }
      View.__super__.constructor.apply(this, arguments);
    }

    View.prototype.remove = function() {
      var fnName, removeChain, _i, _len;
      removeChain = this.constructor.removeChain;
      if (removeChain) {
        for (_i = 0, _len = removeChain.length; _i < _len; _i++) {
          fnName = removeChain[_i];
          this[fnName].call(this);
        }
      }
      return originRemove.call(this);
    };

    return View;

  })(Backbone.View);

  modula["export"]('frames/view', Frames.View);

}).call(this);

(function() {
  var Frames, Model,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Frames = modula.require('frames');

  Model = modula.require('frames/model');

  Frames.ViewModel = (function(_super) {
    __extends(ViewModel, _super);

    function ViewModel() {
      return ViewModel.__super__.constructor.apply(this, arguments);
    }

    return ViewModel;

  })(Model);

  modula["export"]('frames/view_model', Frames.ViewModel);

}).call(this);

(function() {
  var Class, Frames, Launcher, State,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Frames = modula.require('frames');

  Class = modula.require('frames/class');

  State = modula.require('frames/state');

  Launcher = (function(_super) {
    __extends(Launcher, _super);

    function Launcher() {
      var events, states;
      this.__hooks = {};
      this.__passedStages = ['loaded'];
      Frames.createExtendables();
      events = {
        setReady: {
          from: 'loaded',
          to: 'ready'
        },
        setCreated: {
          from: 'ready',
          to: 'created'
        }
      };
      states = ['loaded', 'ready', 'created'];
      this.stage = new State('loaded', {
        states: states,
        events: events
      });
      this.stage.onReady = this.__stageTransition('ready', (function(_this) {
        return function() {
          Frames.start();
          return setTimeout((function() {
            return _this.stage.setCreated();
          }), 0);
        };
      })(this));
      this.stage.onCreated = this.__stageTransition('created');
      this.__bindReady(this.setReady.bind(this));
    }

    Launcher.prototype.reset = function() {
      this.__passedStages = ['loaded'];
      return this.stage.reset();
    };

    Launcher.prototype.setReady = function() {
      return this.stage.setReady();
    };

    Launcher.prototype.getStage = function() {
      return this.stage.get();
    };

    Launcher.prototype.hook = function(stage, fn) {
      var _base;
      if ((_base = this.__hooks)[stage] == null) {
        _base[stage] = [];
      }
      this.__hooks[stage].push(fn);
      if (this.__passedStages.indexOf(stage) !== -1) {
        return fn();
      }
    };

    Launcher.prototype.__bindReady = function(fn) {
      return $(fn);
    };

    Launcher.prototype.__stageTransition = function(stage, after) {
      return (function(_this) {
        return function() {
          _this.__passedStages.push(stage);
          _this.__callStage(stage);
          return typeof after === "function" ? after() : void 0;
        };
      })(this);
    };

    Launcher.prototype.__callStage = function(stage) {
      var fn, _i, _len, _ref, _results;
      if (this.__hooks[stage]) {
        _ref = this.__hooks[stage];
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          fn = _ref[_i];
          _results.push(fn());
        }
        return _results;
      }
    };

    return Launcher;

  })(Class);

  Frames.registerLauncher(Launcher);

  modula["export"]('frames/launcher', Launcher);

}).call(this);
