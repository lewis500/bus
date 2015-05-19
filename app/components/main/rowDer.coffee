'use strict'
template = '''
	<div layout='row' flex class='row' ng-mousedown='vm.bus.hold(true)' ng-mouseup='vm.bus.hold(false)' ng-mouseover='vm.bus.hilite(true)' ng-mouseleave='vm.leave()' layout-align='start center'>
		<div  flex='20'>
			<image src='./styles/busicon-01.svg' />
		</div>
		<span flex='30' offset='5'>bus {{vm.bus.n + 1| number: 0}}</span>
		<span flex> {{vm.bus.queue.length | number:0}} passengers</span>
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
