import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:saving_our_planet/api_client.dart';
import 'package:saving_our_planet/map_data.dart';
import 'package:saving_our_planet/spacing.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MapTab extends StatefulWidget {
  MapTab({Key key}) : super(key: key);

  @override
  _MapTabState createState() => _MapTabState();
}

class _MapTabState extends State<MapTab> {
  List<MapData> mapDataList = [];
  MapData selectedMapData;
  Completer<GoogleMapController> _controller = Completer();
  BitmapDescriptor myIcon;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 2.84863901138305,
  );

  CameraPosition currentCameraPosition;

  @override
  void initState() {
    super.initState();
    currentCameraPosition = _kGooglePlex;
    fetchData();
  }

  fetchData() async {
    this.myIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(0.5, 0.5)), 'assets/ellipse.png');
    List<MapData> d = await ApiClient.fetchMapData();
    setState(() {
      this.mapDataList = d;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            markers: getMarkers(),
            mapToolbarEnabled: false,
            compassEnabled: false,
            rotateGesturesEnabled: false,
            buildingsEnabled: false,
            trafficEnabled: false,
            indoorViewEnabled: false,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            onCameraMove: (position) {
              setState(() {
                this.currentCameraPosition = position;
              });
            },
          ),
          if (this.selectedMapData != null) ...[
            mapDataPanel(),
          ]
        ],
      ),
    );
  }

  SlidingUpPanel mapDataPanel() {
    return SlidingUpPanel(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16.0),
        topRight: Radius.circular(16.0),
      ),
      minHeight: 180.0,
      panel: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                margin: inset3t,
                width: 40.0,
                height: 8.0,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
              Container(
                margin: inset3t,
                child: Text(
                  this.selectedMapData.city,
                  style: Theme.of(context).textTheme.display1,
                ),
              ),
              ListTile(
                title: Text('Infected'),
                trailing: Text(this.selectedMapData.infected.toString()),
              ),
              ListTile(
                title: Text('Recovered'),
                trailing: Text(this.selectedMapData.recovered.toString()),
              ),
              ListTile(
                title: Text('Deaths'),
                trailing: Text(this.selectedMapData.dead.toString()),
              )
            ],
          ),
          Positioned(
            right: 0,
            top: 0,
            child: IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.grey,
                size: 24.0,
              ),
              onPressed: () {
                setState(() {
                  this.selectedMapData = null;
                });
              },
            ),
          )
        ],
      ),
    );
  }

  Set<Marker> getMarkers() {
    Set<Marker> circles = Set();

    this.mapDataList.forEach((mapData) {
      circles.add(
        Marker(
            position: LatLng(mapData.latitude, mapData.longitude),
            markerId: MarkerId(mapData.city),
            icon: this.myIcon,
            onTap: () {
              setState(() {
                this.selectedMapData = mapData;
              });
            },
            consumeTapEvents: true),
      );
    });

    return circles;
  }
}
