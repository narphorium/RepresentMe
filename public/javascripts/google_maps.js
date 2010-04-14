var map;
function loadMap(elementId, overlaySrc, centerX, centerY){
	if (GBrowserIsCompatible()) { 
		var geoXml;
		var geoCallback = function() {
			geoXml.gotoDefaultViewport(map);
		}
		geoXml = new GGeoXml(overlaySrc, geoCallback);
		var map = new GMap2(document.getElementById(elementId));
		map.setCenter(new GLatLng(centerX, centerY), 12);
		map.addMapType(G_PHYSICAL_MAP);
		map.setMapType(G_PHYSICAL_MAP);
		map.disableDoubleClickZoom();
		map.disableInfoWindow();
		map.addOverlay(geoXml);
	
		var icon = new GIcon( );
		icon.image = "/images/marker.png";
		icon.iconSize = new GSize( 19, 19 );
		icon.iconAnchor = new GPoint( 9,9);
		icon.infoWindowAnchor = new GPoint( 9, 9 );
		var pnt = new GLatLng(centerX, centerY);
		var opts = { icon:icon };
		var marker = new GMarker(pnt, opts);
		map.addOverlay(marker);
		map.disableDragging();
  	}
};