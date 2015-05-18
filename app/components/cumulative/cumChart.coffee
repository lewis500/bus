_ = require 'lodash'
plotCtrl = require '../../services/plotCtrl'
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
				<rect class='background' ng-attr-width='{{vm.width}}' ng-attr-height='{{vm.height}}'/>
				<g y-axis scale='vm.Y' width='vm.width'></g>
				<text class='axis-label time' shifter='{{[vm.width, vm.height]}}'  dy='1em'>time</text>
			</g>
			<g clip-path="url(#{{::vm.ID}})" shifter='{{::[vm.mar.left, vm.mar.top]}}'>
				<path class='cumulative-area'/>
			</g>
		</svg>
	</div>
'''

class cumCtrl extends plotCtrl
	constructor: (@scope, @element)->
		super(@scope, @element)

		sel = d3.select @element[0]

		@cumArea = sel
			.select 'path.cumulative-area'
			.classed 'stop-' + @stop.n , true
			.datum @stop.history

		@cumLine = sel
			.select 'path.cumulative-line'
			.datum @stop.history

		@ID = _.uniqueId 'chart'

		@scope.$watch => 
						@stop.history.slice(-1)[0]?.time
					, @update

		@areaFun = d3.svg.area()
			.interpolate 'monotone'
			.y1 (d)=> @Y d.count
			.y0 (d)=> @Y 0
			.x (d)=> @X(World.max_history - (World.time - d.time)/1000)

		@lineFun = d3.svg.line()
			.interpolate 'monotone'
			.y (d)=> @Y d.count
			.x (d)=> @X(World.max_history - (World.time - d.time)/1000)

		@X.domain [0, World.max_history]

	update: =>
		max = d3.max @stop.history, (d)-> 
			d.count
		@Y.domain [0, Math.max((max ? 0), 8) ]

		@cumArea
			.attr 'd' , @areaFun
			.attr 'transform', null
			.transition()
			.attr 'transform', "translate(#{@X(-1)},0)"	

		@cumLine.attr 'd' , @lineFun
			.attr 'transform', null
			.transition()
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
