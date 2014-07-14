/*! frames (v0.1.1),
 Front-end framework,
 by Sasha Koss <kossnocorp@gmail.com>
 Mon Jul 14 2014 */
(function() {
  var Frames;

  Frames = (function() {
    function Frames() {}

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
      var Factory, id, _ref, _results;
      if (!this.factories) {
        return;
      }
      _ref = this.factories;
      _results = [];
      for (id in _ref) {
        Factory = _ref[id];
        _results.push(Factory.create());
      }
      return _results;
    };

    Frames.stop = function() {
      var Factory, id, _ref, _results;
      if (!this.factories) {
        return;
      }
      _ref = this.factories;
      _results = [];
      for (id in _ref) {
        Factory = _ref[id];
        _results.push(Factory.destroy());
      }
      return _results;
    };

    Frames.registerFactory = function(Factory, type) {
      var id;
      if (this.factoryCounter == null) {
        this.factoryCounter = 0;
      }
      if (this.factories == null) {
        this.factories = {};
      }
      id = type || ("factory_" + (this.factoryCounter++));
      this.factories[id] = Factory;
      return id;
    };

    Frames["export"] = function(name, Module) {
      if (typeof modula !== "undefined" && modula !== null) {
        return modula["export"](name, Module);
      } else {
        return this.__exportToWindow(name, Module);
      }
    };

    Frames.__exportToWindow = function(name, Module) {
      var chunks, lastChunk;
      chunks = name.split('/');
      lastChunk = chunks.pop();
      return this.__getOrCreateNamespacePath(chunks)[this.__classify(lastChunk)] = Module;
    };

    Frames.__getOrCreateNamespacePath = function(chunks) {
      return chunks.reduce(this.__getOrCreateNamespaceChunk.bind(this), window);
    };

    Frames.__getOrCreateNamespaceChunk = function(object, chunk) {
      var _name;
      return object[_name = this.__classify(chunk)] != null ? object[_name] : object[_name] = {};
    };

    Frames.__classify = function(name) {
      return name.camelize();
    };

    return Frames;

  })();

  Frames["export"]('frames', Frames);

}).call(this);

(function() {
  var Echo, Frames, LEVELS, LoggerModule, level, _i, _len,
    __slice = [].slice;

  Frames = window.Frames || require('frames');

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

  Frames["export"]('frames/logger_module', LoggerModule);

}).call(this);

(function() {
  var Backbone, Class, Frames, LoggerModule, klass, _i, _len, _ref;

  Frames = window.Frames || require('frames');

  LoggerModule = Frames.LoggerModule || require('frames/logger_module');

  Backbone = window.Backbone;

  Class = (function() {
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

  Frames["export"]('frames/class', Class);

}).call(this);

(function() {
  var Frames, State;

  Frames = window.Frames || require('frames');

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

  Frames["export"]('frames/state', State);

}).call(this);

(function() {
  var Class, Frames, Launcher, State, _ref, _ref1,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Frames = window.Frames || require('frames');

  Class = ((_ref = window.Frames) != null ? _ref.Class : void 0) || require('frames/class');

  State = ((_ref1 = window.Frames) != null ? _ref1.State : void 0) || require('frames/state');

  Launcher = (function(_super) {
    __extends(Launcher, _super);

    function Launcher() {
      var events, states;
      this.__hooks = {};
      this.__passedStages = ['loaded'];
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
        return this.__call(fn);
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
      var fn, _i, _len, _ref2, _results;
      if (this.__hooks[stage]) {
        _ref2 = this.__hooks[stage];
        _results = [];
        for (_i = 0, _len = _ref2.length; _i < _len; _i++) {
          fn = _ref2[_i];
          _results.push(this.__call(fn));
        }
        return _results;
      }
    };

    Launcher.prototype.__call = function(fn) {
      return setTimeout(fn, 0);
    };

    return Launcher;

  })(Class);

  Frames.registerLauncher(Launcher);

  Frames["export"]('frames/launcher', Launcher);

}).call(this);

(function() {
  var Backbone, Class, Frames, RoutersFactory, _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Frames = window.Frames || require('frames');

  Class = ((_ref = window.Frames) != null ? _ref.Class : void 0) || require('frames/class');

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

  Frames.registerFactory(RoutersFactory, 'routers');

  Frames["export"]('frames/routers_factory', RoutersFactory);

}).call(this);

(function() {
  var Class, Frames, ViewsFactory, _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Frames = window.Frames || require('frames');

  Class = ((_ref = window.Frames) != null ? _ref.Class : void 0) || require('frames/class');

  ViewsFactory = (function(_super) {
    var ROOT_SELECTOR, VIEWS_SELECTOR, VIEW_NAME_SPLITTER, VIEW_PATH_WITH_COMPONENT_PATTERN;

    __extends(ViewsFactory, _super);

    function ViewsFactory() {
      return ViewsFactory.__super__.constructor.apply(this, arguments);
    }

    VIEWS_SELECTOR = '[data-view]';

    ROOT_SELECTOR = 'body';

    VIEW_NAME_SPLITTER = /\s/;

    VIEW_PATH_WITH_COMPONENT_PATTERN = /(.+)#(.+)/;

    ViewsFactory.create = function($el, withRoot) {
      if ($el == null) {
        $el = $(ROOT_SELECTOR);
      }
      if (withRoot == null) {
        withRoot = true;
      }
      return this.$viewEls($el, withRoot).each((function(_this) {
        return function(index, el) {
          return _this.createViewsForEl($(el));
        };
      })(this));
    };

    ViewsFactory.createViewsForEl = function(el) {
      var $el, originViewPath, view, viewPath, viewPaths, _i, _len, _results;
      $el = $(el);
      if (!$el.data('created-views')) {
        $el.data('created-views', {});
      }
      viewPaths = $el.data('view').split(VIEW_NAME_SPLITTER);
      _results = [];
      for (_i = 0, _len = viewPaths.length; _i < _len; _i++) {
        originViewPath = viewPaths[_i];
        viewPath = this.expandViewPath(originViewPath);
        if (!$el.data('created-views')[viewPath]) {
          view = this.initializeView(viewPath, {
            el: $el
          });
          _results.push($el.data('created-views')[viewPath] = view);
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    };

    ViewsFactory.destroy = function($el, withRoot) {
      if ($el == null) {
        $el = $(ROOT_SELECTOR);
      }
      if (withRoot == null) {
        withRoot = true;
      }
      return this.$viewEls($el, withRoot).each((function(_this) {
        return function(index, el) {
          return _this.destroyViewsForEl($(el));
        };
      })(this));
    };

    ViewsFactory.destroyViewsForEl = function(el) {
      var $el, createdViews, view, viewName;
      $el = $(el);
      if (createdViews = $el.data('created-views')) {
        for (viewName in createdViews) {
          view = createdViews[viewName];
          view.remove();
        }
        return $el.removeData('created-views');
      }
    };

    ViewsFactory.expandViewPath = function(viewPath) {
      if (VIEW_PATH_WITH_COMPONENT_PATTERN.test(viewPath)) {
        return viewPath;
      } else {
        return 'shared#' + viewPath;
      }
    };

    ViewsFactory.initializeView = function(viewPath, options) {
      var ViewClass;
      ViewClass = this.getViewClass(viewPath);
      if (ViewClass) {
        return new ViewClass(options);
      }
    };

    ViewsFactory.getViewClass = function(viewPath) {
      var ComponentClass, ViewClass, componentClassName, componentName, viewClassName, viewName, __, _ref1;
      _ref1 = viewPath.match(VIEW_PATH_WITH_COMPONENT_PATTERN), __ = _ref1[0], componentName = _ref1[1], viewName = _ref1[2];
      componentClassName = this.getComponentClassName(componentName);
      viewClassName = this.getViewClassName(viewName);
      ComponentClass = window[componentClassName];
      if (ComponentClass && (ViewClass = ComponentClass[viewClassName])) {
        return ViewClass;
      }
    };

    ViewsFactory.getComponentClassName = function(componentName) {
      if (componentName) {
        return componentName.camelize() + 'Component';
      }
    };

    ViewsFactory.getViewClassName = function(viewName) {
      if (viewName) {
        if (viewName) {
          return viewName.camelize() + 'View';
        }
      }
    };

    ViewsFactory.$viewEls = function($el, withRoot) {
      var $els;
      if (withRoot == null) {
        withRoot = true;
      }
      $els = $el.find(VIEWS_SELECTOR);
      if (withRoot) {
        return $els.add($el.filter(VIEWS_SELECTOR));
      } else {
        return $els;
      }
    };

    return ViewsFactory;

  })(Class);

  Frames.registerFactory(ViewsFactory, 'views');

  Frames["export"]('frames/views_factory', ViewsFactory);

}).call(this);

(function() {
  var Frames, JqueryQueryModule;

  Frames = window.Frames || require('frames');

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

  Frames["export"]('frames/jquery_query_module', JqueryQueryModule);

}).call(this);

(function() {
  var Frames, PubSubModule;

  Frames = window.Frames || require('frames');

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

  Frames["export"]('frames/pub_sub_module', PubSubModule);

}).call(this);

(function() {
  var Backbone, Frames, Model,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Frames = window.Frames || require('frames');

  Backbone = window.Backbone;

  Model = (function(_super) {
    __extends(Model, _super);

    function Model() {
      return Model.__super__.constructor.apply(this, arguments);
    }

    return Model;

  })(Backbone.Model);

  Frames["export"]('frames/model', Model);

}).call(this);

(function() {
  var Backbone, Frames, Router,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Frames = window.Frames || require('frames');

  Backbone = window.Backbone;

  Router = (function(_super) {
    __extends(Router, _super);

    function Router() {
      return Router.__super__.constructor.apply(this, arguments);
    }

    Router.prototype._bindRoutes = function() {
      this.createEmitterAndReceiver();
      return Backbone.Router.prototype._bindRoutes.call(this);
    };

    Router.prototype.createEmitterAndReceiver = function() {
      this.broker = Frames.PubSubModule.broker;
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

  Frames["export"]('frames/router', Router);

}).call(this);

(function() {
  var Backbone, Frames, JqueryQueryModule, PubSubModule, View, originRemove,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Frames = window.Frames || require('frames');

  PubSubModule = Frames.PubSubModule || require('frames/pub_sub_module');

  JqueryQueryModule = Frames.JqueryQueryModule || require('frames/jquery_query_module');

  Backbone = window.Backbone;

  originRemove = Backbone.View.prototype.remove;

  View = (function(_super) {
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

    View.include(PubSubModule);

    View.include(JqueryQueryModule);

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

  Frames["export"]('frames/view', View);

}).call(this);

(function() {
  var Frames, Model, ViewModel,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Frames = window.Frames || require('frames');

  Model = Frames.Model || require('frames/model');

  ViewModel = (function(_super) {
    __extends(ViewModel, _super);

    function ViewModel() {
      return ViewModel.__super__.constructor.apply(this, arguments);
    }

    return ViewModel;

  })(Model);

  Frames["export"]('frames/view_model', ViewModel);

}).call(this);
