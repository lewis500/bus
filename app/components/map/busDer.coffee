_ = require 'lodash'
World = require '../../services/world'

template = '''
	<g transform='translate(-32,0)'>
		<rect class='bus' rx='2' ry='2' width='34px' height='14px' y='-7'></rect>
		<g class='g-pax' transform='translate(-2,-3)'></g>
	</g>
'''

der = ()->
	directive = 
		template: template
		scope: 
			data: '='
		restrict: 'A'
		bindToController: true
		controllerAs: 'vm'
		templateNamespace: 'svg'
		controller: ()->
			@queue = @data.queue
		link: (scope, el, attr, vm)->
			sel = d3. select el[0]
			rect = sel.select '.bus'

			scope.$watch 'vm.data.hilited', (v)->
				if v
					rect.transition()
						.duration 400
						.ease 'bounce-in'
						.attr 'stroke-width', 4
						.transition('something')
						.duration 200
						.ease 'cubic-in'
						.attr 'stroke-width', 2
				else 
					rect.transition()
						.duration 175
						.ease 'cubic'
						.attr
							'stroke-width': 0

			scope.$watch 'vm.data.held', (v)->
					rect.classed 'held' , v

			g = d3.select(el[0]).select('g.g-pax')

			places = []

			[0..Math.floor(World.max_capacity/2)]
				.forEach (row)->
						[0...2].forEach (col)->
							places.push 
								row: row
								col: col
								filled: false

			update = (newVal, oldVal)->
				circles = g.selectAll 'circle.pax'
					.data vm.queue, (d)-> d.id

				circles.enter()
					.append 'circle'
					.attr
						r: 0
						transform: (d,i)->
							spot = _.find places, (v)-> !v.filled 
							d.spot = spot
							spot.filled = true
							x =  30 - spot.row * 3
							y = spot.col * 6
							"translate( #{x}, #{y} )"
						class: (d,i)->'pax stop-' + d.destination.n
					.transition 'grow'
					.ease 'cubic-out'
					.delay 10
					.duration 180 
					.attr 'r' , 1.8 
					.transition 'shrink'
					.duration 90 
					.ease 'cubic'
					.attr 'r', 1.3

				circles.exit()
					.transition 'leave'
					.duration 80 
					.ease 'cubic'
					.attr 'r', 0
					.each 'end' , (d)->
						d.spot.filled = false
						d3.select(this).remove()

			scope.$watch 'vm.queue.length', update

module.exports = der