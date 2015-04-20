'use strict'
_ = require('lodash')
World = require './World.coffee'
Car = require './models/car.coffee'
Minute = require './models/minute.coffee'
d3 = require 'd3'

class mainCtrl
	constructor: ($scope)->
		@scope = $scope

		@minutes = World.minutes = [0...World.num_minutes]
			.map (time)=> newMinute = new Minute(time)

		@cars = [0...World.num_cars].map (n)=>
				arr_time = _.sample([0..120],1)[0]
				newCar = new Car(n, arr_time)
				newCar.place()
				return newCar

		@chosen = 0

	get_sample:->
		@chosen = (@chosen + 1)%(World.num_cars)
		@cars[@chosen]

	tick: ->
		# physics stage
		World.minutes.forEach (minute)->	minute.serve()
		# choice stage
		[0...World.sample_size].forEach (car) => @get_sample().choose()
		@cars.forEach (car) => car.place()
		@scope.$evalAsync()

	play: ->
		@stop()
		@runner = setInterval(()=>
			 @tick()
		, World.interval)
		
	stop: -> clearInterval @runner


module.exports = mainCtrl
