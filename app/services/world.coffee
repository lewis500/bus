require '../helpers'

class World
	constructor: ()->
		@max_capacity= 20
		@max_history = 20
		@road_length= 100
		@num_buses= 2
		@num_stops= 4
		@_delay = 1000
		@space= 4
		@_scale= 1.8
		@time= 0
		@_bus_velocity= 15/1000
		@_boarding= 300
		@_alighting= 215
		@_add_time= 1800
	increment: (dt)->
		@time += dt*@_scale
	@property 'delay', get:-> @_delay * @scale
	@property 'scale', get: -> 1/@_scale
	@property 'bus_velocity', get:->@_scale * @_bus_velocity
	@property 'board_time', get: ->@scale * @_boarding
	@property 'alight_time', get: -> @scale * @_alighting
	@property 'add_time', get: -> @scale * @_add_time

module.exports = new World 
