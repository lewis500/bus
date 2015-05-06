template = '''
	<g>
		<rect class='bus' rx='2' ry='2' width='36px' height='16px' x='-8' y='-8'></rect>
		<g class='g-pax' transform='translate(0,-3)'>
			<circle ng-repeat='pax in vm.queue track by pax.id' class='pax' r='2' shifter='{{vm.pax_pos($index)}}'></circle>
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
				col = i % 2
				x = row * 4.5
				y = col * 6
				[x,y]





module.exports = der