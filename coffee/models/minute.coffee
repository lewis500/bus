d3 = require 'd3'
World = require('../World')
num_cars = require('../World').num_cars
require('../helpers.coffee')

class Minute 
	constructor: (@time)->
		@queue = []
		@cum_arrivals = 0
		@cum_exits = 0
		@arrivals = 0
		@exits = 0

	@property 'next', get: ->World.minutes[@time+1] ? false

	@property 'prev', get: ->World.minutes[@time-1] ? false

	serve: ->
		@queue_length = @queue.length

		[0...Math.min(@queue_length, World.rate)]
			.forEach ()=>
				car = @queue.pop()
				car.exit(@time)
				@exits++

		@cum_exits = @exits
		@cum_arrivals = @arrivals

		if @next then @next.receive_queue(@queue)

		if @prev
			@cum_exits+=@prev.cum_exits
			@cum_arrivals+=@prev.cum_arrivals

		@queue = []
		@arrivals = 0
		@exits = 0

	receive_car: (car)-> 
		@queue.push(car)
		@arrivals++

	receive_queue: (queue)->@queue = @queue.concat(queue)

module.exports = Minute