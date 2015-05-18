require '../helpers'

class World
	constructor: ()->
		@max_capacity= 20
		@max_history = 20
		@road_length= 100
		@num_buses= 2
		@num_stops= 4
		@delay = 1000
		@space= 4
		@time = 0
		@bus_velocity= 27/1000
		@board_time = 180
		@alight_time = 130
		@add_time= 1000
	increment: (dt)->
		@time += dt


module.exports = new World 
