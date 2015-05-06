'use strict'
_ = require 'lodash'
d3 = require 'd3'
Data = require '../../services/data'
timeout = require( '../../helpers').timeout
Settings = require '../../services/settings'
template = '''
	<button ng-click='vm.play()'>Play</buton>
	<button ng-click='vm.pause()'>Stop</buton>
'''

class MainCtrl
	constructor: (@scope)->
		@paused = false
		@adding = false
		@eval_async = _.throttle(()=> 
			@scope.$evalAsync()
		, 10)

	add_pax: ->
		@adding = true
		timeout(=>
			Data.add_pax()
			if not @paused then @add_pax() else @adding = false
		, Settings.add_time)

	play: ->
		@pause()
		d3.timer.flush()
		@paused = false
		if not @adding then @add_pax()
		last = 0
		d3.timer (elapsed)=> 
			dt = elapsed - last
			last = elapsed
			Data.tick(dt)
			@eval_async()
			@paused

	pause: -> 
		@paused = true
		d3.timer.flush()

der = ()->
	directive =
		controller: ['$scope', MainCtrl]
		controllerAs: 'vm'
		template: template
		scope: {}


module.exports = der
