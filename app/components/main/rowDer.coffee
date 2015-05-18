'use strict'
template = '''
	<div layout='row' flex class='row' ng-click='vm.delay()'>
		<div class='icon-bus' flex='25'></div>
	</div>
'''

class Ctrl
	constructor: (@scope)->

	delay: ->
		@bus.delay()

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
