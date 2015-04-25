'use strict'

angular = require 'angular'
mainCtrl = require './mainCtrl.coffee'
vis = require './directives/vis.coffee'

app = angular.module('mainApp', [])
	.controller 'mainCtrl', mainCtrl
	.directive 'visDer', vis
