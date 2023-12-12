import 'package:flutter/material.dart';
import 'package:flutter_seenickcode_one/components/banner_image.dart';
import 'package:flutter_seenickcode_one/components/fancy_app_bar.dart';
import 'package:flutter_seenickcode_one/components/location_tile.dart';
import 'package:flutter_seenickcode_one/location_detail.dart';
import 'package:flutter_seenickcode_one/models/location.dart';
import 'package:flutter_seenickcode_one/styles.dart';

const ListItemHeight = 245.0;

class LocationList extends StatefulWidget {
  @override
  State<LocationList> createState() => _LocationListState();
}

class _LocationListState extends State<LocationList> {
  List<Location> locations = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: FancyAppBar(),
        body: RefreshIndicator(
            onRefresh: loadData,
            child: Column(children: [
              renderProgressBar(context),
              Expanded(child: renderListView(context))
            ])));
  }

  Future<void> loadData() async {
    if (this.mounted) {
      setState(() => this.isLoading = true);
      final locations = await Location.fetchAll();
      setState(() {
        this.locations = locations;
        this.isLoading = false;
      });
    }
  }

  Widget renderProgressBar(BuildContext context) {
    return (this.isLoading
        ? LinearProgressIndicator(
            value: null,
            backgroundColor: Colors.white,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.grey))
        : Container());
  }

  Widget renderListView(BuildContext context) {
    return ListView.builder(
      itemCount: this.locations.length,
      itemBuilder: _listViewItemBuilder,
    );
  }

  Widget _listViewItemBuilder(BuildContext context, int index) {
    final location = this.locations[index];
    return GestureDetector(
        onTap: () => _navigateToLocationDetail(context, location.id),
        child: Container(
          height: ListItemHeight,
          child: Stack(children: [
            BannerImage(url: location.url, height: ListItemHeight),
            _tileFooter(location),
          ]),
        ));
  }

  void _navigateToLocationDetail(BuildContext context, int locationId) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => LocationDetail(locationId)));
  }

  Widget _tileFooter(Location location) {
    final info = LocationTile(location: location, darkTheme: true);
    final overlay = Container(
      padding: EdgeInsets.symmetric(
          vertical: 5.0, horizontal: Styles.horizontalPaddingDefault),
      decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
      child: info,
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [overlay],
    );
  }

  Widget _itemTitle(Location location) {
    return Text(
      location.name,
      style: Styles.textDefault,
    );
  }
}
