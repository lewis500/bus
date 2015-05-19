_ = require 'lodash'
World = require '../../services/world'
d3 = require 'd3'

template = '''
	<div class='cum-chart' ng-init='vm.resize()'>
		<svg ng-attr-height='{{vm.height + vm.mar.top + vm.mar.bottom}}'>
			<defs>
				<clippath id='{{::vm.ID}}'>
					<rect ng-attr-width='{{vm.width}}' ng-attr-height='{{vm.height}}'/>
				</clippath>
			</defs>
			<g shifter='{{[vm.mar.left, vm.mar.top]}}'>
				<text class='axis-label count' ng-attr-x='{{vm.width/2}}' y='-5px'>Pax Waiting</text>
				<g y-axis scale='vm.Y' width='vm.width'></g>
				<text class='axis-label time' shifter='{{[vm.width, vm.height]}}'  dy='1em'>time</text>
				<line class='x-zero' ng-attr-y2='{{vm.height}}'></line>
			</g>
			<g clip-path="url(#{{::vm.ID}})" shifter='{{::[vm.mar.left, vm.mar.top]}}'>
				<path class='cumulative-area'/>
			</g>
		</svg>
	</div>
'''

class cumCtrl
	constructor: (@scope, @element)->
		@Y = d3.scale.linear().domain([0,8])
		@X = d3.scale.linear().domain([0,World.max_history])
		@ID = _.uniqueId 'chart-'
		@mar = 
			left: 14
			top: 16
			right: 5
			bottom: 14

		sel = d3.select @element[0]

		@el = sel
			.select 'div'
			.node()

		@cumArea = sel
			.select 'path.cumulative-area'
			.classed 'stop-' + @stop.n , true
			.datum @stop.history

		@scope.$watch => 
						@stop.history.slice(-1)[0]?.time
					, @update

		@areaFun = d3.svg.area()
			.interpolate 'monotone'
			.y1 (d)=> @Y d.count
			.y0 (d)=> @Y 0
			.x (d)=> @X(World.max_history - (World.time - d.time)/1000)

		angular.element(window).on('resize', @resize)
		

	resize: ()=>
		@width = @el.clientWidth - @mar.left - @mar.right
		@height = @el.clientHeight - @mar.top - @mar.bottom
		@Y.range([@height, 0])
		@X.range([0, @width])
		@scope.$evalAsync()

	update: =>
		max = d3.max @stop.history, (d)-> 
			d.count
		@Y.domain [0, Math.max((max ? 0), 8) ]

		@cumArea
			.attr 'd' , @areaFun
			# .attr 'transform', null
			.transition()
			.duration 200
			.ease 'linear'
			.attr 'transform', "translate(#{@X(-1)},0)"	


der = ()->
	directive = 
		controllerAs: 'vm'
		scope: 
			stop: '='
		bindToController: true
		templateNamespace: 'svg'
		template: template
		controller: ['$scope','$element', cumCtrl]

module.exports = der
