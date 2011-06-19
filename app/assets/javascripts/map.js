// Initialize the map and set up the controls
$(function() {
  var mapOptions = {
    zoom: 11,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };
	
	// Set the map to a window property so we can access it globally
  window.map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);
	var map = window.map;

  if ($('#coords').size() > 0) {
    var coordsArray = $('#coords').val().split(' ');
    var location = new google.maps.LatLng(coordsArray[0], coordsArray[1]);
    map.setCenter(location);
  } else {
    geoLocate();
  }

  setMapControls(map);

  function geoLocate() {
    var initialLocation;
    var browserSupportFlag =  new Boolean();
    
    // Try W3C Geolocation (Preferred)
    if(navigator.geolocation) {
      browserSupportFlag = true;
      navigator.geolocation.getCurrentPosition(function(position) {
        initialLocation = new google.maps.LatLng(position.coords.latitude,position.coords.longitude);
        map.setCenter(initialLocation);
      }, function() {
        handleNoGeolocation(browserSupportFlag);
      });
    // Try Google Gears Geolocation
    } else if (google.gears) {
      browserSupportFlag = true;
      var geo = google.gears.factory.create('beta.geolocation');
      geo.getCurrentPosition(function(position) {
        initialLocation = new google.maps.LatLng(position.latitude,position.longitude);
        map.setCenter(initialLocation);
      }, function() {
        handleNoGeoLocation(browserSupportFlag);
      });
    // Browser doesn't support Geolocation
    } else {
      browserSupportFlag = false;
      handleNoGeolocation(browserSupportFlag);
    }

    function handleNoGeolocation(errorFlag) {
      //map.setCenter(initialLocation);
    }
    $.get('/questions', { new_coords: map.center.lat() + ',' + map.center.lng() });
  }

  function setMapControls(map) {
    var searchControl = $('#map-search').get(0);
    map.controls[google.maps.ControlPosition.TOP_LEFT].push(searchControl);
  }
});
