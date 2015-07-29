//! Author: Martin K. Schröder <mkschreder.uk@gmail.com>

JUCI.app
.controller("InternetFirewallPageCtrl", function($scope, $uci, $firewall, $config){
	$scope.data = {}; 
	$firewall.getZones().done(function(zones){
		$scope.zones = zones; 
		$scope.$apply(); 
	}); 
	$firewall.getRules().done(function(rules){
		$scope.rules = rules; 
		$scope.$apply(); 
	}); 
	$uci.sync("firewall").done(function(){
		$scope.firewall = $uci.firewall; 
		$scope.data.enabled = $uci.firewall["@zone"].filter(function(zone){ 
			return zone.name.value == "wan" && zone.input.value == "REJECT" && zone.forward.value == "REJECT"; 
		}).length > 0; 
		$scope.$apply(); 
	}); 
	
	$scope.$watch("data.enabled", function(value){
		$uci.firewall["@zone"].map(function(zone){
			if(zone.name.value == "wan"){
				if(value){
					zone.input.value = "REJECT"; 
					zone.forward.value = "REJECT"; 
				} else {
					zone.input.value = "ACCEPT"; 
					zone.forward.value = "ACCEPT"; 
				}
			}
		}); 
		$uci.save(); 
	}); 
}); 
