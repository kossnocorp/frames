#= require_tree ./class_modules

class Framework.Class

  @include: (module) ->
    Object.merge(@::, Object.reject(module, 'included', 'extended'))
    module.included(@) if module.included

  @extend: (module) ->
    Object.merge(@, Object.reject(module, 'included', 'extended'))
    module.extended(@) if module.extended

  @attr: (name, options={}) ->
    @attrReader(name, options)
    @attrWriter(name, options)

  @attrReader: (name, options={}) ->
    privateName = @__privateNameFor(name)
    @::[@__getterNameFor(name, options)] = -> @[privateName]

  @attrWriter: (name, options={}) ->
    privateName = @__privateNameFor(name)
    @::[@__setterNameFor(name, options)] = (val) -> @[privateName] = val

    if options.boolean
      if options.true
        @::[options.true] = -> @[privateName] = true
      if options.false
        @::[options.false] = -> @[privateName] = false

  @patch: (klass) ->
    Object.merge(klass, @)
    Object.merge(klass::, @::)

  @__getterNameFor: (name, options={}) ->
    options.getter or @__fnName(name, prefix: if options.boolean then 'is' else 'get')

  @__setterNameFor: (name, options={}) ->
    options.setter or @__fnName(name, prefix: 'set')

  @__privateNameFor: (name) -> "__#{name}"

  @__fnName: (name, options={}) ->
    parts = []
    parts.push(options.prefix) if options.prefix
    parts.push(name)
    parts.join('_').camelize(false)

  @include Framework.LoggerModule

Framework.Class.patch(Backbone[klass]) for klass in 'View Model Collection Router'.split(' ')
