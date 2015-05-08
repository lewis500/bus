World = require '../services/world'
{uniqueId} = require( 'lodash')
require '../helpers'

class Pax
	constructor: (@destination, @stop)->
		ticks = 
			alight: 0
			board: 0

		@id = uniqueId('pax-')

		@times = 
			start: World.time
			board: Infinity
			alight: Infinity

	@property 'wait_time', get: -> @times.board - @times.start
	@property 'total_time', get: -> @times.alight -@times.start

	alight:() -> @times.alight = World.time
	board: () -> @times.board = World.time

module.exports = Pax
