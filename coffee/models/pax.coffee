Settings = require '../services/settings'
require '../helpers'

class Pax
	constructor: (@destination, @stop)->
		ticks = 
			alight: 0
			board: 0

		Pax.num_pax++

		@board_timeout = null
		@alight_timeout = null

		@times = 
			start: Date.now()
			board: Infinity
			alight: Infinity

	@num_pax: 0

	@property 'wait_time', get: -> @times.board - @times.start
	@property 'total_time', get: -> @times.alight -@times.start

	alight:(bus, cb) ->
		console.log 'alighting'
		d3.timer(=>
			bus.remove_pax(this)
			cb()
			true
		, Settings.alight_time())

	board:(bus, cb) ->
		console.log 'boarding'
		@bus = bus
		d3.timer( =>
			@bus.add_pax(this)
			@stop.remove_pax(this)
			cb()
			true
		, Settings.board_time())

module.exports = Pax
