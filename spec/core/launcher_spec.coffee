Launcher = require('frames/launcher')

describe 'Launcher', ->

  describe 'initialization stages', ->

    describe 'loaded stage', ->

      it 'initiates right after launcher is loaded and registered', ->
        launcher = new Launcher()
        expect(launcher.getState()).to.be.eq 'loaded'

    describe 'ready stage', ->

      it 'initiates once DOM is ready'

      it 'calls Frames.start'

      it 'calls attached hooks before Frames.start is called'

    describe 'created stage', ->

      it 'initiates right after Frames.start is worked'

  describe 'hook function', ->

    it 'calls hook immediately if stage is already initiated'

    it 'calls hook immediately if next stage(s) is initiated'

  describe 'pause function', ->

    it 'pauses initialization process until unpause will be called'

    it "holds next stage until all unpause's will be called"
