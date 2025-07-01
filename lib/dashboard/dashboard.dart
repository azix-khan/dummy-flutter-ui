import 'package:dummy/dashboard/animation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardOnePage extends StatelessWidget {
  static const String path = "lib/dashboard/dashboard.dart";

  final String image = images[0];

  DashboardOnePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(context), body: _buildBody(context));
  }

  _buildBody(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        _buildStats(),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildTitledContainer(
              "Sales",
              child: SizedBox(
                height: 200,
                child:
                    DonutPieChart.withSampleData(), // Updated to use DonutPieChart from fl_chart
              ),
            ),
          ),
        ),
        _buildActivities(context),
      ],
    );
  }

  SliverPadding _buildStats() {
    const TextStyle stats = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20.0,
      color: Colors.white,
    );
    return SliverPadding(
      padding: const EdgeInsets.all(16.0),
      sliver: SliverGrid.count(
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 1.5,
        crossAxisCount: 3,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.blue,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text("+500", style: stats),
                const SizedBox(height: 5.0),
                Text("Leads".toUpperCase()),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.pink,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text("+300", style: stats),
                const SizedBox(height: 5.0),
                Text("Customers".toUpperCase()),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.green,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text("+1200", style: stats),
                const SizedBox(height: 5.0),
                Text("Orders".toUpperCase()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  SliverPadding _buildActivities(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(16.0),
      sliver: SliverToBoxAdapter(
        child: _buildTitledContainer(
          "Activities",
          height: 280,
          child: Expanded(
            child: GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              children:
                  activities
                      .map(
                        (activity) => Column(
                          children: <Widget>[
                            CircleAvatar(
                              radius: 20,
                              child: Icon(activity.icon, size: 18.0),
                            ),
                            const SizedBox(height: 5.0),
                            Text(
                              activity.title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList(),
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
      titleSpacing: 0.0,
      elevation: 0.5,
      backgroundColor: Colors.white,
      title: const Text(
        "Dashboard",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
        ),
        textAlign: TextAlign.center,
      ),
      actions: <Widget>[_buildAvatar(context)],
    );
  }

  Widget _buildAvatar(BuildContext context) {
    return IconButton(
      iconSize: 40,
      padding: const EdgeInsets.all(0),
      icon: CircleAvatar(
        backgroundColor: Colors.grey.shade300,
        child: CircleAvatar(radius: 16, backgroundImage: NetworkImage(image)),
      ),
      onPressed: () {},
    );
  }

  Container _buildTitledContainer(
    String title, {
    required Widget child,
    double? height,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 28.0),
          ),
          const SizedBox(height: 10.0),
          child,
        ],
      ),
    );
  }
}

class DonutPieChart extends StatelessWidget {
  final List<PieChartSectionData> sections;
  final bool animate;

  const DonutPieChart({
    super.key,
    required this.sections,
    required this.animate,
  });

  factory DonutPieChart.withSampleData() {
    return DonutPieChart(sections: _createSampleData(), animate: true);
  }

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sections: sections,
        centerSpaceRadius: 50, // Makes it a donut chart
        sectionsSpace: 5, // Space between sections
      ),
    );
  }

  // Create some sample data
  static List<PieChartSectionData> _createSampleData() {
    return [
      PieChartSectionData(
        value: 40,
        color: Colors.blue,
        title: 'July',
        radius: 50,
        titleStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      PieChartSectionData(
        value: 25,
        color: Colors.red,
        title: 'August',
        radius: 50,
        titleStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      PieChartSectionData(
        value: 15,
        color: Colors.green,
        title: 'September',
        radius: 50,
        titleStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      PieChartSectionData(
        value: 20,
        color: Colors.orange,
        title: 'October',
        radius: 50,
        titleStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    ];
  }
}

/// Sample activity data
class Activity {
  final String title;
  final IconData icon;
  Activity({required this.title, required this.icon});
}

final List<Activity> activities = [
  Activity(title: "Results", icon: FontAwesomeIcons.listOl),
  Activity(title: "Messages", icon: FontAwesomeIcons.commentSms),
  Activity(title: "Appointments", icon: FontAwesomeIcons.calendarDay),
  Activity(title: "Video Consultation", icon: FontAwesomeIcons.video),
  Activity(title: "Summary", icon: FontAwesomeIcons.fileLines),
  Activity(title: "Billing", icon: FontAwesomeIcons.dollarSign),
];
