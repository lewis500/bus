timeout = require( '../helpers').timeout
World = require '../services/world'
_ = require 'lodash'

class Bus
	constructor: (@n, stop)->
		@queue = []
		@stopped = false
		@position = stop.location + 3
		@halts = 0
		@next_bus = undefined
		@next_stop = undefined
		@delay_timeout = undefined
		@hilited = false

	set_next_bus: (bus)-> @next_bus = bus
	set_next_stop: (stop)-> @next_stop = stop

	@property 'gap', get: -> 
		l = @next_stop.location - @location
		Math.min Math.abs(l), l + World.road_length

	@property 'space', get: ->
		l0 = @next_bus.position - @position
		l1 = if l0 < 0 then l0 + World.road_length else l0
		l1 - World.space

	@property 'location', get: -> @position % World.road_length

	hilite: (v)-> 
		@hilited = v

	delay: ->
		@stopped = true
		clearInterval(@delay_timeout)
		@delay_timeout = setTimeout(=> 
			@stopped = false
		, World.delay)

	release:() -> @stopped = false

	halt: ->
		@halts++
		@stopped = true
		@next_stop.halt(this)

	tick: (dt)->
		if not (@stopped)
			gap = @gap
			move = (dt * World.bus_velocity)
			if gap <= move
				@halt()
				@position += gap
			else
				@position += Math.min(move, @space)

	remove_pax: (pax)->	@queue.splice(@queue.indexOf(pax), 1)

	add_pax: (pax)-> @queue.push(pax)

module.exports = Bus