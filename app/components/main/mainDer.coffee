'use strict'
_ = require 'lodash'
d3 = require 'd3'
Data = require '../../services/data'
timeout = require( '../../helpers').timeout
Settings = require '../../services/settings'
template = '''
	<div class='button' ng-click='vm.play()'>Play</div>
	<div class='button' ng-click='vm.pause()'>Stop</div>
	<slider ng-model='vm.Settings._scale' min='.4' max='1.5' step='.05'></slider>
'''

class ButtonCtrl
	constructor: (@scope, @rootScope)->
		@pause()
		@adding = false
		@Settings = Settings

	add_pax: ->
		@adding = true
		timeout(=>
			Data.add_pax()
			if not @rootScope.paused then @add_pax() else @adding = false
		, Settings.add_time)

	play: ->
		@pause()
		d3.timer.flush()
		@rootScope.paused = false
		if not @adding then @add_pax()
		last = 0
		d3.timer (elapsed)=> 
			dt = elapsed - last
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
