State = require('frames/state')

describe 'State', ->

  describe '::constructor', ->

    it 'accepts default value as first argument', ->
      state = new State('test')
      expect(state.get()).to.be.eq 'test'

    it 'adds passed default value to list of states', ->
      state = new State('test')
      expect(state.availableStates()).to.be.eql ['test']

    describe 'options as second argument', ->

      it 'accepts list of values', ->
        state = new State('a', states: ['b', 'c'])
        expect(state.availableStates()).to.have.members ['a', 'b', 'c']

      it 'accepts list of events', ->
        events =
          lock: from: 'unlocked', to: 'locked'
          unlock: from: 'locked', to: 'unlocked'
        state = new State('locked', states: ['locked', 'unlocked'], events: events)
        state.unlock()
        expect(state.get()).to.be.eq 'unlocked'

  describe '::availableStates', ->

    it 'returns available states', ->
      class Abc extends State
        states: ['a', 'b', 'c']
      abc = new Abc()
      expect(abc.availableStates()).to.be.eql ['a', 'b', 'c']

  describe 'manual transition', ->

    before ->
      class @Lock extends State
        states: ['locked', 'unlocked', 'broken']

        events:
          lock: from: 'unlocked', to: 'locked'
          unlock: from: 'locked', to: 'unlocked'
          broke: from: 'locked', to: 'broken'

    beforeEach ->
      @lock = new @Lock()

    describe '::get', ->

      it 'gets first avaliable state as default', ->
        expect(@lock.get()).be.be.eq 'locked'

      it "reads ::default property if it's defined", ->
        @Lock::default = 'unlocked'
        lock = new @Lock
        expect(lock.get()).to.be.eq 'unlocked'
        delete @Lock::default

    describe '::set', ->

      it 'sets new state', ->
        @lock.set('unlocked')
        expect(@lock.get()).to.be.eq 'unlocked'

      it 'respects defined events', ->
        @lock.set('unlocked')
        expect(=> @lock.set('broken')).to.throw "Transition from 'unlocked' to 'broken' is not allowed!"

      it 'throw error if state is not defined', ->
        expect(=> @lock.set('burned')).to.throw "There is not 'burned' state"

    describe '::reset', ->

      it 'resets state to default state', ->
        @lock.unlock()
        @lock.reset()
        expect(@lock.get()).to.be.eq 'locked'

      it 'ignores transition rules', ->
        @lock.broke()
        @lock.reset()
        expect(@lock.get()).to.be.eq 'locked'

      it 'calls onReset callback', ->
        callback = sinon.spy()
        @lock.onReset = callback
        @lock.reset()
        expect(callback).to.be.called

      it 'passes current state as first argument and new as second one', ->
        callback = sinon.spy()
        @lock.onReset = callback
        @lock.broke()
        @lock.reset()
        expect(callback).to.be.calledWith('broken', 'locked')

  describe 'transitions', ->

    before ->
      class @TrafficLights extends State
        states: ['red', 'yellow', 'green']

        default: 'red'

        events:
          makeRed: from: 'yellow', to: 'red'
          makeGreen: from: 'yellow', to: 'green'
          makeYellow: from: ['red', 'green'], to: 'yellow'

    beforeEach ->
      @lights = new @TrafficLights()

    describe 'events definition', ->

      it 'defines events', ->
        expect(@lights.makeRed).to.be.a('function')
        expect(@lights.makeGreen).to.be.a('function')
        expect(@lights.makeYellow).to.be.a('function')

      it 'changes state', ->
        @lights.makeYellow()
        expect(@lights.get()).to.be.eq 'yellow'

      it 'throw expection if transition is not allowed', ->
        expect(=> @lights.makeGreen()).to.throw("Transition from 'red' to 'green' is not allowed!")

    describe 'callbacks', ->

      beforeEach ->
        @callback = sinon.spy()

      it 'calls callback on succeseful state change', ->
        @lights.onYellow = @callback
        @lights.makeYellow()
        expect(@callback).to.be.called

      it "doesn't call callback if transition is not allowed", ->
        @lights.onGreen = @callback
        try @lights.makeGreen() catch
        expect(@callback).to.be.not.called

      it 'passes current state as first argument and new state as second one', ->
        @lights.onYellow = @callback
        @lights.makeYellow()
        expect(@callback).to.be.calledWith('red', 'yellow')
