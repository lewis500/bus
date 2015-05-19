require '../helpers'

class World
	constructor: ()->
		@max_capacity= 18
		@max_history = 35
		@road_length= 100
		@num_buses= 2
		@num_stops= 4
		@delay = 1000
		@space= 2.5
		@time = 0
		@bus_velocity= 27/1000
		@board_time = 180
		@alight_time = 115
		@add_time= 1350
		@paused = false
	increment: (dt)->
		@time += dt


module.exports = new World 
