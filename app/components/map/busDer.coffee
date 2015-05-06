template = '''
	<g transform='translate(-4, -2)'>
		<rect class='bus' rx='2' ry='2' width='16' height='8'></rect>
		<g class='g-pax'>
			<circle ng-repeat='pax in vm.queue track by pax.id' class='pax' r='1' shifter='{{vm.pax_pos($index)}}'></circle>
		</g>
	</g>
'''

der = ()->
	directive = 
		template: template
		scope: {
			data: '='
		}
		restrict: 'A'
		bindToController: true
		controllerAs: 'vm'
		templateNamespace: 'svg'
		controller: ()->
			@queue = @data.queue
			@pax_pos = (i)->
				row = Math.floor i / 2
				col = Math.floor i % 2
				x = row * 2
				y = col * 3
				[x,y]





module.exports = der