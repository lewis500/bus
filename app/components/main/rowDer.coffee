'use strict'
template = '''
	<div layout='row' flex class='row' ng-click='vm.delay()' ng-mouseover='vm.hilite(true)' ng-mouseleave='vm.hilite(false)'>
		<div class='icon-bus' flex='25'></div>
		<span flex='45'>Bus {{vm.bus.n + 1| number: 0}}</span>
		<span flex='30' > # pax: {{vm.bus.queue.length | number:0}}</span>
	</div>
'''

class Ctrl
	constructor: (@scope)->

	hilite: (v)->
		@bus.hilite(v)
		# @scope.$evalAsync()

	delay: ->
		@bus.delay()
		# @scope.$evalAsync()

der = ()->
	directive =
		controller: ['$scope', Ctrl]
		controllerAs: 'vm'
		bindToController: true
		template: template
		replace: true
		scope: 
			bus: '='

module.exports = der
