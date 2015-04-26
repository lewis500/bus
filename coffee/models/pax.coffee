Settings = require '../services/settings'
require '../helpers'
World = require '../services/World'

class Pax
	constructor: (@destination, @stop)->
		ticks = 
			alight: 0
			board: 0

		Pax.num_pax++

		@board_timeout = null
		@alight_timeout = null

		@times = 
			start: World.time
			board: Infinity
			alight: Infinity

	@num_pax: 0

	@property 'wait_time', get: -> @times.board - @times.start
	@property 'total_time', get: -> @times.alight -@times.start

	alight:() -> @times.alight = World.time
	board: () -> @times.board = World.time

module.exports = Pax
