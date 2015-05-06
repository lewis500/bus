template = '''
	<circle class='stop' ng-attr-r='{{vm.radius}}'></circle>
	<text class='bus-icon'>
		&#xf207;
	</text>
	</foreignObject>
	<g class='g-pax'></g>
'''
der = ()->
	directive = 
		template: template
		controllerAs: 'vm'
		bindToController: true
		scope: 
			data: '=stopDer'
		controller: ()->
			@radius = 16
			@queue = @data.boarding_paxes
		link: (scope, el, attr, vm)->
			g = d3.select(el[0]).select('g.g-pax')

			update = ()->
				circles = g.selectAll 'circle.pax'
					.data vm.queue, (d)-> d.id

				rotator = (d,i)->
						angle = 360 * switch 
							when i < 10 then i / 10
							when i < 35 then i / 15
							else i / 30
						"rotate( #{ angle } )"

				translator = (d,i)->
						level = switch 
							when i < 10 then 1
							when i < 35 then 2
							else 3
						level * 10

				circles
					.transition('place')
					.duration 150
					.ease 'cubic'
					.attr 'transform', rotator
					.attr 'cy', translator

				circles.enter()
					.append 'circle'
					.classed 'pax' , true
					.attr 'r', .5
					.attr 'transform', rotator
					.attr 'cy', translator
					.transition('grow')
					.duration 100
					.ease 'cubic-out'
					.attr 'r' , 2.2

				circles.exit().transition().duration(150).attr('r', 0).remove()

			scope.$watch 'vm.queue.length', update


module.exports = der