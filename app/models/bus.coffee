timeout = require( '../helpers').timeout
Settings = require '../services/settings'
_ = require 'lodash'

class Bus
	constructor: (@n, @stop)->
		@queue = []
		@stopped = false
		@position = @stop.location
		@halts = 0
		@next_bus = undefined
		@next_stop = undefined
		@delay_timeout = undefined

	set_next_bus: (bus)-> @next_bus = bus
	set_next_stop: (stop)-> @next_stop = stop

	@property 'gap', get: -> @next_stop.location - @location

	@property 'space', get: ->
		space = @next_bus.position - @position
		diff = if (space > 0) then space else (space + Settings.road_length)
		diff-Settings.space

	@property 'location', get: -> @position % Settings.road_length

	@property 'not_ready', get: -> 
		@halts > Settings.expected_halts

	delay: ->
		@stopped = true
		clearInterval(@delay_timeout)
		@delay_timeout = setTimeout(=> 
			@stopped = false
		, Settings.delay)

	release:() -> @stopped = false

	halt: ->
		@halts++
		@stopped = true
		@next_stop.halt(this)

	tick: (dt)->
		if not (@stopped)
			gap = @gap
			move = (dt * Settings.bus_velocity)
			if gap <= move
				@halt()
				@position += gap
			else
				@position += Math.min(move, @space)

	remove_pax: (pax)->	@queue.splice(@queue.indexOf(pax), 1)

	add_pax: (pax)-> @queue.push(pax)

module.exports = Bus