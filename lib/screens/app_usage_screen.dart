import 'package:flutter/material.dart';
import 'package:app_usage/app_usage.dart';

class AppUsageScreen extends StatefulWidget {
  @override
  _AppUsageScreenState createState() => _AppUsageScreenState();
}

class _AppUsageScreenState extends State<AppUsageScreen> {
  List<AppUsageInfo> _infos = [];
  Duration totalTime = Duration();

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

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    getUsageStats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: getUsageStats,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: mediaQuery.height * 0.35,
                width: double.infinity,
                color: Color(0xff274296),
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        totalTime.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 8,
                        ),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          "Rahul's Phone",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 8,
                        ),
                        padding: const EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.yellow,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "200C",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.yellow,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
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
                      return Container(
                        color: Color(0xffFFEEE6),
                        margin: EdgeInsets.symmetric(vertical: 2,horizontal: 8),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          title: Text(_infos[index].appName),
                          trailing: Text(
                            _infos[index].startDate.toString(),
                          ),
                          subtitle: Text(
                            _infos[index].usage.toString(),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
