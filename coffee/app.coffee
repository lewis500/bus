'use strict'

angular = require 'angular'
mainCtrl = require './mainCtrl.coffee'
lineChart = require './lineChart.coffee'

app = angular.module('mainApp', [])
	.controller 'mainCtrl', mainCtrl
	.controller 'lineChartCtrl', lineChart.controller
	.directive 'lineChart', lineChart.directive
