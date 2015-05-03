#Google Maps API

*Can you figure it out?*

[Google Maps API](https://developers.google.com/maps/documentation/javascript/tutorial)

<br />

##Let's get started
<br />

`Start by grabbing your Google API key`

[Google Developers Console](https://console.developers.google.com/project)

1. Click 'Create Project'
2. Click 'Enable an API'
3. Click 'Google Maps JavaScript API'
4. Click 'Enable API'
5. Then click 'Credentials' and 'Create new Key' under public API access
6. Create a server key


`Create a rails app called GoogleMaps`

	$ rails new GoogleMaps -T

Create a controller 'welcome' with the action of maps

	$ rails g controller welcome maps

`Set up Figaro in the gemfile`

	gem "figaro"

In your terminal, let's bundle then install figaro

	$ bundle install
	$ figaro install

In our application.yml (created by figaro), let's now add our google API key

	GOOGLE_MAPS: [Your Server API Key]

Restart your rails server

`Let's build our controller`

	class WelcomeController < ApplicationController
	  def maps
	    url = 'https://maps.googleapis.com/maps/api/js?key='
	    key = ENV['GOOGLE_MAPS']
	    @endpoint = url + key
	  end
	end


`Let's use the API`

	<style type="text/css">
	      html, body, #map-canvas { height: 100%; margin: 0; padding: 0;}
	</style>
  
    <script type="text/javascript"
      src="<%= @endpoint %>">
    </script>

    <script type="text/javascript">
      function initialize() {
        var mapOptions = {
          center: { lat: -34.397, lng: 150.644},
          zoom: 8
        };
        var map = new google.maps.Map(document.getElementById('map-canvas'),
            mapOptions);
      }
      google.maps.event.addDomListener(window, 'load', initialize);
    </script>
  
	<div id="map-canvas"></div>

`Let's style our map`

	function initialize() {
      	// Add styles

      	var styles = [
      		{
		      stylers: [
		        { hue: "#00ffe6" },
		        { saturation: -10 }
		      ]
		    },{
		      featureType: "road",
		      elementType: "geometry",
		      stylers: [
		        { lightness: 100 },
		        { visibility: "simplified" }
		      ]
		    },{
		      featureType: "road",
		      elementType: "labels",
		      stylers: [
		        { visibility: "off" }
		      ]
		    }
      	];

      	var styledMap = new google.maps.StyledMapType(styles, {name: "Styled Map"});

        var mapOptions = {
          center: { lat: -34.397, lng: 150.644},
          zoom: 11 // Zoom level
        };
        var map = new google.maps.Map(document.getElementById('map-canvas'),
            mapOptions);
        //Associate the styled map with the MapTypeId and set it to display.
	  	map.mapTypes.set('map_style', styledMap);
	  	map.setMapTypeId('map_style');
      }

`Note: Use the google maps style wizard to help you style it`

[Google maps style wizard](http://gmaps-samples-v3.googlecode.com/svn/trunk/styledmaps/wizard/index.html)
[Snazzy maps](https://snazzymaps.com/style/19557/hotelcube)

###Add a marker

Lets replace the center coordinates with the following:

		// San Jose
      	var sanJose = new google.maps.LatLng(37.339085, -121.8914807);
      	
Change mapOptions

		var marker = new google.maps.Marker({
		    position: sanJose,
		    title:"Hello World!"
		});

		// To add the marker to the map, call setMap();
		marker.setMap(map);

Make draggable and animation

	// Create the marker
	  	var marker = new google.maps.Marker({
		    position: sanJose,
		    animation: google.maps.Animation.DROP,
		    draggable: true,
		    title:"Hello World!"
		});
		
Let's make it bounce

	marker.setAnimation(google.maps.Animation.BOUNCE);

Let's make it bounce onclick

	google.maps.event.addListener(marker, 'click', function(){
      		marker.setAnimation(google.maps.Animation.BOUNCE);
      	});

###Setting multiple markers      	
	var beaches = [
            ['Huntington Beach', 33.660297, -117.99922650000002],
            ['Seal Beach', 33.7414064, -118.10478660000001],
            ['Long Beach', 33.7700504, -118.19373949999999],
            ['Venice Beach', 33.9850469, -118.46948320000001],
            ['Manhattan Beach', 33.8847361, -118.41090889999998]
          ];

          function setMarkers(map, locations){
              for(var i = 0; i < locations.length; i++){
                var beach = locations[i];
                var LatLng = new google.maps.LatLng(beach[1], beach[2]);
                var marker = new google.maps.Marker({
                    position: LatLng,
                    draggable: true,
                    map: map,
                    animation: google.maps.Animation.DROP,
                    title: beach[0],
                    zIndex: beach[3]
                });

                google.maps.event.addListener(marker, 'click', toggleBounce);

                function toggleBounce(){
                  this.setAnimation(google.maps.Animation.BOUNCE);
                }

              }
            }

`Add the beaches into initialize():`

	setMarkers(map, beaches);	     

#Finding a place by location with GeoCoder:


	function showAddress(address, map){
	          var geocoder = new google.maps.Geocoder();
	            // Run Geocoder
	          geocoder.geocode( { 'address': address}, function(results, status) {
	            if(status === google.maps.GeocoderStatus.OK){
	if (status !== google.maps.GeocoderStatus.ZERO_RESULTS) {
                      console.log(results[0].geometry.location);
                      map.setCenter(results[0].geometry.location);

                      var infowindow = new google.maps.InfoWindow(
                          { content: '<b>'+address+'</b>',
                            size: new google.maps.Size(150,50)
                          });

                      var marker = new google.maps.Marker({
                          position: results[0].geometry.location,
                          map: map,
                          title:address
                      });
                      google.maps.event.addListener(marker, 'click', function() {
                          infowindow.open(map,marker);
                      });
                   } else {
                     alert("No results found");
                   }

            }else{
              alert('Geocoder failed!');
            }
          });
        }