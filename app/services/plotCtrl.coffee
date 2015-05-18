angular = require 'angular'

class Controller
	constructor: (@scope, @element)->
		@Y = d3.scale.linear().domain([0,8])
		@X = d3.scale.linear().domain([0,8])
		@mar = 
			left: 15
			top: 5
			right: 5
			bottom: 14
		@el = d3.select @element[0] 
			.select 'div'
			.node()

		angular.element(window).on('resize', @resize)

	resize: ()=>
		@width = @el.clientWidth - @mar.left - @mar.right
		@height = @el.clientHeight - @mar.top - @mar.bottom
		@Y.range([@height, 0])
		@X.range([0, @width])
		@scope.$evalAsync()

module.exports = Controller