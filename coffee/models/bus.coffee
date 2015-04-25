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

	@property 'blocked', get: ->
		[a,b] = [@next_bus.position, @position]
		gap = if ((a-b) > 0) then (a-b) else (a+Settings.road_length - b)
		gap < Settings.gap

	@property 'location', get: -> @position % Settings.road_length

	release: ->
		console.log 'release'
		@stopped = false
		@stop_queue = null
		@alight_queue = null
		@stop = null

	halt: ->
		@stopped = true
		stop = @next_stop
		cb = =>if @stop_queue.length > 0 then @stop_queue.shift()() else @release()

		@stop_queue = []

		@queue.filter (pax)=> pax.destination is stop
			.forEach (pax)=> @stop_queue.push(pax.alight.bind(pax, this, cb))

		stop.queue.forEach (pax) =>
			@stop_queue.push(pax.board.bind(pax, this, cb))

		setTimeout(=>cb())

	tick: (dt)->
		if not (@stopped or @blocked)
			gap = @gap
			if @gap <= dt * @velocity
				@halt()
				@position += gap
			else
				@position+=dt * @velocity

	remove_pax: (pax)->	@queue.splice(@queue.indexOf(pax), 1)

	add_pax: (pax)-> @queue.push(pax)

module.exports = Bus