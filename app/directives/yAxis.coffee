d3 = require 'd3'
angular = require 'angular'

der = ()->
	directive = 
		controller: ()->
		controllerAs: 'vm'
		bindToController: true
		restrict: 'A'
		templateNamespace: 'svg'
		scope: 
			scale: '='
			width: '='
			tickFormat: '='
		link: (scope, el, attr, vm)->
			yAxisFun = d3.svg.axis()
				.scale vm.scale
				.ticks 5
				.orient 'left'

			sel = d3.select el[0]
				.classed 'y axis', true

			yAxisFun.tickFormat d3.format("d")
			    .tickSubdivide 0

			update = ()=>
				yAxisFun.tickSize -vm.width
				sel.call yAxisFun

			scope.$watch 'vm.scale.domain()', update , true

			angular.element window
				.on 'resize', update

module.exports = der