import 'package:child_io/color.dart';
import 'package:child_io/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:app_usage/app_usage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:location/location.dart' as loc;
import 'package:location/location.dart';
import 'package:proste_bezier_curve/proste_bezier_curve.dart';
import 'package:proste_bezier_curve/utils/type/index.dart';

class AppUsageScreen extends StatefulWidget {
  @override
  _AppUsageScreenState createState() => _AppUsageScreenState();
}

class _AppUsageScreenState extends State<AppUsageScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  List<AppUsageInfo> _infos = [];
  LocationData? _currentLocation;
  String currentLocationString = "";
  Duration totalTime = Duration();

  Future<void> getCurrentLocation() async {
    final location = loc.Location();
    final locationData = await location.getLocation();

    List<Placemark> placemarks = await placemarkFromCoordinates(
      locationData.latitude!,
      locationData.longitude!,
      localeIdentifier: "en",
    ); // lat,long

    print(placemarks[0]);

    setState(() {
      currentLocationString =
          "${placemarks[0].street}, ${placemarks[0].subLocality}, ${placemarks[0].locality}, ${placemarks[0].postalCode}, ${placemarks[0].country}";
      _currentLocation = locationData;
    });

    print(_currentLocation);
  }

  Future<void> getUsageStats() async {
    try {
      DateTime endDate = DateTime.now();
      DateTime startDate = endDate.subtract(Duration(days: 1));
      List<AppUsageInfo> infoList =
          await AppUsage().getAppUsage(startDate, endDate);

      Duration total = Duration();

      for (var info in infoList) {
        if (info.usage is Duration) total += info.usage as Duration;
      }

      print(total);

      setState(() {
        _infos = infoList;
        totalTime = total;
      });
    } on AppUsageException catch (exception) {
      print(exception);
    }
  }

  String formatDuration(int milliseconds) {
    var secs = milliseconds ~/ 1000;
    var hours = (secs ~/ 3600).toString().padLeft(2, '0');
    var minutes = ((secs % 3600) ~/ 60).toString().padLeft(2, '0');
    var seconds = (secs % 60).toString().padLeft(2, '0');
    return double.parse(hours) >= 1
        ? "$hours hrs $minutes mins"
        : "$minutes mins";
  }

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    getCurrentLocation();
    getUsageStats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return RefreshIndicator(
      onRefresh: getUsageStats,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Header(300, mediaQuery.height * 0.05, context: context,),
          ),
          Container(
            height: mediaQuery.height * 0.35,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              color: primaryColor,
              image: DecorationImage(
                  image: AssetImage("assets/images/bg_cover.png"),
                  fit: BoxFit.cover),
            ),
            margin: EdgeInsets.symmetric(vertical: 10),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Expanded(
                //   child: Row(
                //     children: [
                //       Icon(Icons.location_on_outlined),
                //       Expanded(
                //         child: Text(
                //           currentLocationString,
                //           // overflow: TextOverflow.ellipsis,
                //           softWrap: true,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                Center(
                  child: Text(
                    formatDuration(totalTime.inMilliseconds),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      "Today's Total Usage",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
            child: Text(
              "Recent Activity",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Divider(),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 20,
                      offset: Offset(0, 2),
                      spreadRadius: 20,
                      color: Colors.white38,
                    ),
                  ]),
              child: ListView.builder(
                itemCount: _infos.length,
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 2,
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ListTile(
                        title: Text(
                          _infos[index].appName,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: textColor,
                          ),
                        ),
                        subtitle: Text(
                          DateFormat('d MMM y hh:mm a').format(
                            _infos[index].startDate,
                          ),
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: textColor.withOpacity(0.5),
                          ),
                        ),
                        trailing: Text(
                          formatDuration(_infos[index].usage.inMilliseconds),
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: textColor.withOpacity(0.7),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
