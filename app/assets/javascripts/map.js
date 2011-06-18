$(function() {
  var mapOptions = {
    zoom: 11,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };
  var map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);

  if ($('#coords').size() > 0) {
    var coordsArray = $('#coords').val().split(' ');
    var location = new google.maps.LatLng(coordsArray[0], coordsArray[1]);
    map.setCenter(location);
  } else {
    geoLocate();
  }

  setMapControls(map);

  var locSearchInitialFocus = true;
  $('#map-search-input').focus(function() {
    if(locSearchInitialFocus) {
      $(this).val('');
      locSearchInitialFocus = false;
    }
  });

  $('#map-search form').submit(function() {
    geoCode($('#map-search-input').val());
    //return false; // don't actually submit the form
  });

  $('#new_question').submit(function() {
    var coord = map.getCenter().lat() + "," + map.getCenter().lng();
    $('#question_coords').val(coord);
  });

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

  function geoCode(location) {
    var geocoder = new google.maps.Geocoder();
    geocoder.geocode( { 'address': location}, function(results, status) {
      if(status == google.maps.GeocoderStatus.OK) {
        map.setCenter(results[0].geometry.location);
        $('#new_coords').val(map.center.lat() + ',' + map.center.lng());
      }
    });
  }
});
