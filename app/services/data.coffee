World = require './world'
BusStop = require '../models/bus_stop'
Bus = require '../models/bus'
Pax = require '../models/pax'
_ = require 'lodash'

class Data
	constructor: ()->
		@reset()

	reset:->
		World.time = 0
		
		# create stops
		SL = [[5, false], [30,true], [55, true], [80,false]]
		@stops = [1..World.num_stops].map (n)->
			p = SL[n-1]
			newStop = new BusStop n, p[0], p[1] 

		@stops.forEach (stop, i,k)->
			stop.set_next if k[i+1] then k[i+1] else k[0]
			
		# create buses
		@buses = [0...World.num_buses].map (n)=> 
			stop = @stops[ n * Math.floor World.num_stops / World.num_buses]
			newBus = new Bus(n, stop)
			newBus.set_next_stop stop.next_stop
			newBus

		@buses.forEach (bus,i,k)->
			bus.set_next_bus if k[i+1] then k[i+1] else k[0]

	choose_destination: (stop)->
		_.sample(_.without(@stops, stop), 1)[0]

	tick: (dt)->
		World.increment(dt)
		@buses.forEach (bus)-> bus.tick(dt)
		@stops.forEach (stop)-> stop.snapshot()

	add_pax: ->
		@stops.forEach (stop,i,k) =>
			destination = k[(i+2)%k.length]
			new_pax = new Pax(destination, stop)
			stop.receive_pax(new_pax)

module.exports = new Data

