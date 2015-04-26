require '../helpers'
World = require '../services/world'
Settings = require '../services/settings'
_ = require 'lodash'

class Bus
	constructor: (@n, @stop)->
		@queue = []
		@stopped = false
		@position = @stop.location
		@velocity = Settings.bus_velocity 

	@property 'gap', get: -> @next_stop.location - @location

	@property 'next_bus', get: -> World.buses[(@n+1)%World.buses.length]

	@property 'next_stop', get: -> 
		_.find(World.stops , (stop)=> stop.location > @location) ? World.stops[0]

	@property 'space', get: ->
		[a,b] = [@next_bus.position, @position]
		if (a < b) then (a-b) else (a+Settings.road_length - b)

	@property 'location', get: -> @position % Settings.road_length

	release: ->
		console.log 'release'
		@position += .02
		@stopped = false

	halt: ->
		@stopped = true
		@next_stop.halt(this)

	tick: (dt)->
		World.time += dt
		if not (@stopped)
			gap = @gap
			move = (dt * @velocity)
			if gap <= move
				@halt()
				@position += gap
			else
				@position += move

	remove_pax: (pax)->	@queue.splice(@queue.indexOf(pax), 1)

	add_pax: (pax)-> @queue.push(pax)

module.exports = Bus