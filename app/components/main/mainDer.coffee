'use strict'
_ = require 'lodash'
d3 = require 'd3'
Data = require '../../services/data'
timeout = require( '../../helpers').timeout
World = require '../../services/world'
template = '''
	<div layout='row' layout-align='start center'>
		<div flex='25'>
			<div class='button' ng-click='vm.play()'>Play</div>
			<div class='button' ng-click='vm.pause()'>Stop</div>
		</div>
		<div flex>
			<div style='text-align:center; font-family: AmLight;'>Simulation Speed</div>
			<slider ng-model='vm.World._scale' min='.3' max='1.5' step='.05'></slider>
		</div>
	</div>
'''

class ButtonCtrl
	constructor: (@scope, @rootScope)->
		@pause()
		@adding = false
		@World = World

	add_pax: ->
		@adding = true
		timeout(=>
			Data.add_pax()
			if not @rootScope.paused then @add_pax() else @adding = false
		, World.add_time)

	play: ->
		@pause()
		d3.timer.flush()
		@rootScope.paused = false
		if not @adding then @add_pax()
		last = 0
		d3.timer (elapsed)=> 
			dt = Math.min(elapsed - last, 24)
			last = elapsed
			Data.tick(dt)
			@scope.$evalAsync()
			@rootScope.paused

	pause: -> @rootScope.paused = true

der = ()->
	directive =
		controller: ['$scope', '$rootScope', ButtonCtrl]
		controllerAs: 'vm'
		template: template
		scope: {}

module.exports = der
