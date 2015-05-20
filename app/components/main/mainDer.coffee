'use strict'
_ = require 'lodash'
d3 = require 'd3'
Data = require '../../services/data'
timeout = require( '../../helpers').timeout
World = require '../../services/world'

class ButtonCtrl
	constructor: (@scope, @timeout)->
		@adding = false
		@World = World
		@Data = Data
		@timeout ()=>
			@play()

	reset: ->
		World.pause()
		Data.reset()
		d3.timer.flush()

	add_pax: ->
		@adding = true
		timeout =>
				Data.add_pax()
				if not World.paused then @add_pax() else @adding = false
			, World.add_time

	play: ->
		@pause()
		d3.timer.flush()
		World.play()
		if not @adding then @add_pax()
		last = 0
		d3.timer (elapsed)=> 
			dt = Math.min elapsed - last,24
			last = elapsed
			Data.tick(dt)
			@scope.$evalAsync()
			World.paused

	pause: -> 
		World.pause()

der = ()->
	directive =
		controller: ['$scope', '$timeout',ButtonCtrl]
		controllerAs: 'vm'
		templateUrl: './app/components/main/main.html'
		scope: {}

module.exports = der
