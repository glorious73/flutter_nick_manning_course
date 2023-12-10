import 'package:flutter/material.dart';
import 'package:flutter_seenickcode_one/location_detail.dart';
import 'package:flutter_seenickcode_one/models/location.dart';
import 'package:flutter_seenickcode_one/styles.dart';

class LocationList extends StatefulWidget {
  @override
  State<LocationList> createState() => _LocationListState();
}

class _LocationListState extends State<LocationList> {
  List<Location> locations = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
          "Locations",
          style: Styles.navBarTitle,
        )),
        body: ListView.builder(
          itemCount: this.locations.length,
          itemBuilder: _listViewItemBuilder,
        ));
  }

  loadData() async {
    final locations = await Location.fetchAll();
    if (this.mounted) {
      setState(() {
        this.locations = locations;
      });
    }
  }

  Widget _listViewItemBuilder(BuildContext context, int index) {
    var location = this.locations[index];
    return ListTile(
      contentPadding: EdgeInsets.all(10),
      leading: _itemThumbnail(location),
      title: _itemTitle(location),
      onTap: () => _navigationToLocationDetail(context, location.id),
    );
  }

  void _navigationToLocationDetail(BuildContext context, int locationId) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => LocationDetail(locationId)));
  }

  Widget _itemThumbnail(Location location) {
    if (location.url.isEmpty) {
      return Container();
    }

    try {
      return Container(
        constraints: BoxConstraints.tightFor(height: 100.0),
        child: Image.network(location.url, fit: BoxFit.fitWidth),
      );
    } catch (e) {
      print("could not load image ${location.url}");
      return Container();
    }
  }

  Widget _itemTitle(Location location) {
    return Text(
      location.name,
      style: Styles.textDefault,
    );
  }
}
