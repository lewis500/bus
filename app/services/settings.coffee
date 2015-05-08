require '../helpers'

class Settings
	constructor: ()->
		@max_capacity=24
		@road_length= 100
		@num_buses= 2
		@num_stops= 4
		@delay = 1000
		@space= 3
		@_scale= 1
		@time= 0
		@_bus_velocity= 12/1000
		@_boarding= 325
		@_alighting= 250
		@_add_time= 1500
	increment: (dt)->
		@time += dt*@scale
	@property 'scale', get: -> 1/@_scale
	@property 'bus_velocity', get:->@_scale * @_bus_velocity
	@property 'board_time', get: ->@scale * @_boarding
	@property 'alight_time', get: -> @scale * @_alighting
	@property 'add_time', get: -> @scale * @_add_time
	@property 'expected_halts', get: -> 
		dist_bw_stops = @road_length / @num_stops
		travel_time = dist_bw_stops / @bus_velocity
		pax_time = (@board_time + @alight_time ) / @add_time
		headway = travel_time/(1-pax_time)
		res = (@time + pax_time * travel_time)/headway + .4

module.exports = new Settings 
