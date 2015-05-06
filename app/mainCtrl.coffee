'use strict'
# libraries
_ = require('lodash')
d3 = require 'd3'
timeout = require( './helpers').timeout
#services
Settings = require './services/settings'
World = require './services/world'

# classes/models
BusStop = require './models/stop'
Pax = require './models/pax'
Bus = require './models/bus'

class mainCtrl
	constructor: ($scope)->
		@scope = $scope
		@paused = false
		@adding = false

		@thro = _.throttle(()=>
			@scope.$evalAsync()
		, 25)

		# create stops
		World.stops = [1..Settings.num_stops].map (n)->
			position = Settings.road_length * n / Settings.num_stops
			newStop = new BusStop(n, position)
		# create buses
		World.buses = [0...Settings.num_buses].map (n)-> 
			stop = World.stops[n]
			newBus = new Bus(n, stop)

	choose_destination: (stop)->
		_.sample(_.without(World.stops, stop), 1)[0]

	tick: (dt)->
		World.time += dt
		World.buses.forEach (bus)-> bus.tick(dt)
		@thro()

	add_pax: ->
		@adding = true
		timeout(=>
			World.stops.forEach (stop) =>
				destination = @choose_destination(stop)
				new_pax = new Pax(destination, stop)
				stop.receive_pax(new_pax)
			if not @paused then @add_pax() else @adding = false
		, Settings.add_time)

	play: ->
		@pause()
		if not @adding then @add_pax()
		@paused = false
		last = 0
		d3.timer (elapsed)=> 
			dt = elapsed - last
			last = elapsed
			@tick(dt)
			@paused

	pause: -> 
		@paused = true

module.exports = mainCtrl
