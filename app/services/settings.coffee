require '../helpers'

class Settings
	constructor: ()->
	road_length: 100
	num_buses: 4
	num_stops: 4
	space: 1
	scale: 1
	time: 0
	bus_velocity: .01
	_boarding: 150
	_alighting: 150
	_add_time: 1000
	@property 'board_time', get: ->@scale * @_boarding
	@property 'alight_time', get: -> @scale * @_alighting
	@property 'add_time', get: -> @scale * @_add_time
	# @property 'travel_time', get: -> 
	# @property 'expected_halts', get: -> 
	# 	dist_bw_stops = @road_length / @num_stops
	# 	travel_time = dist_bw_stops / @bus_velocity
	# 	pax_time = (@board_time + @alight_time ) / @add_time
	# 	headway = travel_time/(1-pax_time)
	# 	res = (World.time + pax_time * travel_time)/headway + 1

module.exports = new Settings 
