import 'dart:async';

import 'package:flutter/material.dart';
import 'package:usage_stats/usage_stats.dart';

void main() {
  runApp(UsageStat());
}

class UsageStat extends StatefulWidget {
  @override
  _UsageStatState createState() => _UsageStatState();
}

class _UsageStatState extends State<UsageStat> {
  List<UsageInfo> events = [];
  Map<String?, NetworkInfo?> _netInfoMap = Map();

  @override
  void initState() {
    super.initState();

    initUsage();
  }

  Future<void> initUsage() async {
    try {
      UsageStats.grantUsagePermission();

      DateTime endDate = new DateTime.now();
      DateTime startDate =
          DateTime(endDate.year, endDate.month, endDate.day, 0, 0, 0);

      List<EventUsageInfo> queryEvents =
          await UsageStats.queryEvents(startDate, endDate);
      List<NetworkInfo> networkInfos = await UsageStats.queryNetworkUsageStats(
        startDate,
        endDate,
        networkType: NetworkType.all,
      );

      Map<String?, NetworkInfo?> netInfoMap = Map.fromIterable(networkInfos,
          key: (v) => v.packageName, value: (v) => v);

      List<UsageInfo> t = await UsageStats.queryUsageStats(startDate, endDate);

      for (var i in t) {
        if (double.parse(i.totalTimeInForeground!) > 0) {
          print(
              DateTime.fromMillisecondsSinceEpoch(int.parse(i.firstTimeStamp!))
                  .toIso8601String());

          print(DateTime.fromMillisecondsSinceEpoch(int.parse(i.lastTimeStamp!))
              .toIso8601String());

          print(i.packageName);
          print(DateTime.fromMillisecondsSinceEpoch(int.parse(i.lastTimeUsed!))
              .toIso8601String());
          print(int.parse(i.totalTimeInForeground!) / 1000 / 60);

          print('-----\n');
        }
      }

      this.setState(() {
        events = t;
        _netInfoMap = netInfoMap;
      });
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("Usage Stats"), actions: [
          IconButton(
            onPressed: UsageStats.grantUsagePermission,
            icon: Icon(Icons.settings),
          )
        ]),
        body: Container(
          child: RefreshIndicator(
            onRefresh: initUsage,
            child: ListView.separated(
              itemBuilder: (context, index) {
                var event = events[index];
                var networkInfo = _netInfoMap[event.packageName];
                return ListTile(
                  title: Text(events[index].packageName!),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "Last time used: ${events[index].lastTimeUsed!}"),
                      networkInfo == null
                          ? Text("Unknown network usage")
                          : Text("Received bytes: ${networkInfo.rxTotalBytes}\n" +
                              "Transfered bytes : ${networkInfo.txTotalBytes}"),
                    ],
                  ),
                  trailing: Text(events[index].totalTimeInForeground!),
                );
              },
              separatorBuilder: (context, index) => Divider(),
              itemCount: events.length,
            ),
          ),
        ),
      ),
    );
  }
}