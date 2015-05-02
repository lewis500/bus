timeout = require( '../helpers').timeout
World = require '../services/world'
Settings = require '../services/settings'
_ = require 'lodash'

class Bus
	constructor: (@n, @stop)->
		@queue = []
		@stopped = false
		@position = @stop.location
		@velocity = Settings.bus_velocity 
		@halts = 0

	@property 'gap', get: -> @next_stop.location - @location

	@property 'next_bus', get: -> World.buses[(@n+1)%World.buses.length]

	@property 'next_stop', get: -> 
		_.find(World.stops , (stop)=> stop.location > @location) ? World.stops[0]

	@property 'space', get: ->
		space = @next_bus.position - @position
		diff = if (space > 0) then space else (space + Settings.road_length)
		-Settings.space + diff

	@property 'location', get: -> @position % Settings.road_length

	@property 'not_ready', get: -> @halts > Settings.expected_halts

	delay_draw:->
		draw = Math.random()
		if draw < .005
			@stopped = true
			timeout(=> 
				@stopped=false
			, 200)

	release: ->
		@position += .02
		@stopped = false

	halt: ->
		@halts++
		@stopped = true
		@next_stop.halt(this)

	tick: (dt)->
		if not (@stopped)
			gap = @gap
			move = (dt * @velocity)
			if gap <= move
				@halt()
				@position += gap
			else
				@position += Math.min(move, @space)
			@delay_draw()

	remove_pax: (pax)->	@queue.splice(@queue.indexOf(pax), 1)

	add_pax: (pax)-> @queue.push(pax)

module.exports = Bus