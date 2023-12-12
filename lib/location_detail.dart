import 'package:flutter/material.dart';
import 'package:flutter_seenickcode_one/components/banner_image.dart';
import 'package:flutter_seenickcode_one/components/fancy_app_bar.dart';
import 'package:flutter_seenickcode_one/components/location_tile.dart';
import 'package:flutter_seenickcode_one/styles.dart';
import 'package:url_launcher/url_launcher.dart';
import 'models/location.dart';

const BannerImageHeight = 300.0;
const BodyVerticalPadding = 20.0;
const FooterHeight = 100.0;

class LocationDetail extends StatefulWidget {
  final int locationId;

  LocationDetail(this.locationId);

  @override
  State<LocationDetail> createState() => _LocationDetailState(this.locationId);
}

class _LocationDetailState extends State<LocationDetail> {
  final int locationId;
  Location location = Location.blank();

  _LocationDetailState(this.locationId);

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: FancyAppBar(),
        body: Stack(children: [
          _renderBody(context, location),
          _renderFooter(context, location),
        ]));
  }

  loadData() async {
    final location = await Location.fetchById(this.locationId);

    if (mounted) {
      setState(() {
        this.location = location;
      });
    }
  }

  Widget _renderBody(BuildContext context, Location location) {
    var result = <Widget>[];
    result.add(BannerImage(url: location.url, height: BannerImageHeight));
    result.add(_renderHeader());
    result.addAll(_renderFacts(context, location));
    result.add(const SizedBox(
      height: 100,
    ));
    return SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: result));
  }

  Widget _renderHeader() {
    return Container(
        padding: EdgeInsets.symmetric(
            vertical: BodyVerticalPadding,
            horizontal: Styles.horizontalPaddingDefault),
        child: LocationTile(location: this.location, darkTheme: false));
  }

  Widget _renderFooter(BuildContext context, Location location) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.5)),
            height: FooterHeight,
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
                child: _renderBookButton()),
          )
        ]);
  }

  List<Widget> _renderFacts(BuildContext context, Location location) {
    var result = <Widget>[];
    for (int i = 0; i < (location.facts ?? []).length; i++) {
      result.add(_sectionTitle(location.facts![i].title));
      result.add(_sectionText(location.facts![i].text));
    }
    return result;
  }

  Widget _sectionTitle(String text) {
    return Container(
        padding: EdgeInsets.fromLTRB(Styles.horizontalPaddingDefault, 25.0,
            Styles.horizontalPaddingDefault, 0.0),
        child: Text(text.toUpperCase(),
            textAlign: TextAlign.left, style: Styles.headerLarge));
  }

  Widget _sectionText(String text) {
    return Container(
        padding: EdgeInsets.fromLTRB(25.0, 15.0, 25.0, 15.0),
        child: Text(text, style: Styles.textDefault));
  }

  Widget _renderBookButton() {
    return FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: Styles.accentColor,
        foregroundColor: Styles.textColorBright,
      ),
      onPressed: _handleBookPress,
      child: Text('Book'.toUpperCase(), style: Styles.textCTAButton),
    );
  }

  void _handleBookPress() async {
    const url = 'mailto:hello@tourism.co?subject=inquiry';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }
}
