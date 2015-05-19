_ = require 'lodash'
World = require '../../services/world'

template = '''
	<g transform='translate(-32,0)'>
		<rect class='bus' rx='2' ry='2' width='34px' height='14px' y='-7'></rect>
		<g class='g-pax' transform='translate(-2,-2.3)'></g>
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
				.attr 'fill' , 'black'

			scope.$watch 'vm.data.hilited', (v)->
				if v
					rect.transition()
						.duration 345
						.ease 'bounce-in'
						.attr 'stroke-width', 5.5
						.transition('something')
						.duration 130
						.ease 'cubic'
						.attr 'stroke-width', 2

				else 
					rect.transition()
						.duration 175
						.ease 'cubic'
						.attr 'stroke-width', 0

			scope.$watch 'vm.data.held', (v)->
				if v
					rect.transition 'grow'
						.duration 200
						.ease 'bounce-in'
						.attr 'transform', 'scale(1.1)'
						.transition()
						.ease 'cubic'
						.duration 100
						.attr 'transform', 'scale(1)'

					rect.transition 'color'
						.duration 200
						.ease 'cubic-in'
						.attr 'fill', 'white'
				else 
					rect.transition 'hold'
						.duration 175
						.ease 'cubic'
						.attr 'fill', 'black'

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
							y = spot.col * 5
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