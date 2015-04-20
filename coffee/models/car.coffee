d3 = require('d3')
World = require( '../World.coffee')
require('../helpers.coffee')
_ = require('lodash')

class Car 
	constructor: (@n, @arr_time)->
		@sched_pen = Infinity
		@cost = Infinity
		@travel_pen = Infinity
		@exit_time = @arr_time 

	exit: (time)-> 
		@exit_time = time
		@travel_pen = World.alpha*(@exit_time - @arr_time)
		sched_del = @exit_time - World.wish_time
		@sched_pen = if sched_del <= 0 then (-World.beta * sched_del) else (World.gamma * sched_del)
		@cost = @travel_pen + @sched_pen

	getCost: (arr_time, exit_time)->
		travel_pen = World.alpha*(exit_time - arr_time)
		sched_del = exit_time - World.wish_time
		sched_pen = if sched_del <= 0 then (-World.beta * sched_del) else (World.gamma * sched_del)
		cost = travel_pen + sched_pen

	choose: ()->
		cost = @cost
		World.minutes.forEach (minute,i)=>
			arr_time = minute.time
			exit_time = arr_time + minute.queue_length/World.rate
			if exit_time < World.num_minutes
				pCost = @getCost(arr_time, exit_time)
				if pCost < cost 
					@arr_time = arr_time
					cost = pCost

	place: -> World.minutes[@arr_time].receive_car(this)

module.exports = Car