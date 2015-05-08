require '../helpers'

class Settings
	constructor: ()->
		@max_capacity= 20
		@road_length= 100
		@num_buses= 2
		@num_stops= 4
		@delay = 1500
		@space= 4
		@_scale= 1
		@time= 0
		@_bus_velocity= 15/1000
		@_boarding= 300
		@_alighting= 250
		@_add_time= 2100
	increment: (dt)->
		@time += dt*@scale
	@property 'scale', get: -> 1/@_scale
	@property 'bus_velocity', get:->@_scale * @_bus_velocity
	@property 'board_time', get: ->@scale * @_boarding
	@property 'alight_time', get: -> @scale * @_alighting
	@property 'add_time', get: -> @scale * @_add_time

module.exports = new Settings 
