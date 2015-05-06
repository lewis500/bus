Settings = require '../services/settings'
{uniqueId} = require( 'lodash')
require '../helpers'

class Pax
	constructor: (@destination, @stop)->
		ticks = 
			alight: 0
			board: 0

		@id = uniqueId('pax-')

		@times = 
			start: Settings.time
			board: Infinity
			alight: Infinity

	@property 'wait_time', get: -> @times.board - @times.start
	@property 'total_time', get: -> @times.alight -@times.start

	alight:() -> @times.alight = Settings.time
	board: () -> @times.board = Settings.time

module.exports = Pax
