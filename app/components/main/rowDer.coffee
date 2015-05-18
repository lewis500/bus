'use strict'
template = '''
	<div layout='row' flex class='row' ng-mousedown='vm.bus.hold(true)' ng-mouseup='vm.bus.hold(false)' ng-mouseover='vm.bus.hilite(true)' ng-mouseleave='vm.leave()' ng-class='{"hilited": vm.bus.hilited, "held": vm.bus.held}'>
		<div class='icon-bus' flex='25'></div>
		<span flex='45'>Bus {{vm.bus.n + 1| number: 0}}</span>
		<span flex='30' > # pax: {{vm.bus.queue.length | number:0}}</span>
	</div>
'''

class Ctrl
	constructor: (@scope)->

	leave: ()->
		@bus.hilite(false)
		@bus.hold(false)

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
