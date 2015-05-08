Settings = require './settings'
BusStop = require '../models/bus_stop'
Bus = require '../models/bus'
Pax = require '../models/pax'
_ = require 'lodash'

class Data
	constructor: ()->
		@reset()

	reset:->
		# create stops
		@stops = [1..Settings.num_stops].map (n)->
			position = Settings.road_length * n / Settings.num_stops 
			newStop = new BusStop(n, position)

		@stops.forEach (stop, i,k)->
			stop.set_next if k[i+1] then k[i+1] else k[0]
			
		# create buses
		@buses = [0...Settings.num_buses].map (n)=> 
			stop = @stops[ n * Math.floor Settings.num_stops / Settings.num_buses]
			newBus = new Bus(n, stop)
			newBus.set_next_stop stop.next_stop
			newBus

		@buses.forEach (bus,i,k)->
			bus.set_next_bus if k[i+1] then k[i+1] else k[0]

		@paxes = []

	choose_destination: (stop)->
		_.sample(_.without(@stops, stop), 1)[0]

	tick: (dt)->
		Settings.increment(dt)
		@buses.forEach (bus)-> bus.tick(dt)

	add_pax: ->
		@stops.forEach (stop,i,k) =>
			# destination = @choose_destination(stop)
			destination = k[(i+2)%k.length]
			new_pax = new Pax(destination, stop)
			stop.receive_pax(new_pax)

module.exports = new Data

