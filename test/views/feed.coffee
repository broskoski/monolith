_       = require 'underscore'
sinon   = require 'sinon'
benv    = require 'benv'
eco     = require 'eco'

{ resolve } = require 'path'

describe 'FeedView', ->
  beforeEach (done) ->
    benv.setup ->
      benv.expose
        $: benv.require 'jquery'
        _: benv.require 'underscore'
        Backbone: benv.require 'backbone'

      @Velocity = sinon.stub()
      Backbone.$ = $
      sinon.stub Backbone, 'sync'

      @FeedView = require '../../app/views/feed'
      @FeedView::initialize = sinon.stub()

      @Tags = require '../../app/collections/tags'
      @Entries = require '../../app/collections/entries'

    @clock = sinon.useFakeTimers()

    done()

  afterEach (done) ->
    Backbone.sync.restore()
    @clock.restore()
    benv.teardown false
    done()

  describe 'FeedView', ->
    beforeEach (done) ->
      @tags = benv.require resolve(__dirname, '../fixtures/tags.js')
      @entries = benv.require resolve(__dirname, '../fixtures/entries.js')

      @view = new FeedView
      @view.tags = new Tags @tags
      @view.entries = new Entries @entries

      @transitionSpy = sinon.spy @view, 'transitionToHoldingPage'

      done()

    describe '#maybeShowHolder', ->
      xit 'Removes an entry from the front of the list', ->
        @view.entries.length.should.equal 8
        @view.maybeShowHolder()
        @view.entries.length.should.equal 7

      xit 'Shows holding page when entry list is exhausted', ->
        @view.entries = new Entries @entries[0]
        @view.entries.length.should.equal 1
        @view.maybeShowHolder()
        @transitionSpy.called.should.be.ok

