'use strict'
_ = require 'lodash'
d3 = require 'd3'
Data = require '../../services/data'
timeout = require( '../../helpers').timeout
World = require '../../services/world'

class ButtonCtrl
	constructor: (@scope)->
		@pause()
		@adding = false
		@World = World
		@buses = Data.buses
		@stops = Data.stops

	add_pax: ->
		@adding = true
		timeout =>
				Data.add_pax()
				if not World.paused then @add_pax() else @adding = false
			, World.add_time

	play: ->
		@pause()
		d3.timer.flush()
		World.paused = false
		if not @adding then @add_pax()
		last = 0
		d3.timer (elapsed)=> 
			dt = Math.min elapsed - last,24
			last = elapsed
			Data.tick(dt)
			@scope.$evalAsync()
			World.paused

	pause: -> 
		World.paused = true

der = ()->
	directive =
		controller: ['$scope', ButtonCtrl]
		controllerAs: 'vm'
		templateUrl: './app/components/main/main.html'
		scope: {}

module.exports = der
