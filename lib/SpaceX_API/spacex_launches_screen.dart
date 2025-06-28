import 'dart:convert';
import 'package:dummy/SpaceX_API/card_widget.dart';
import 'package:dummy/SpaceX_API/launch_detail.dart';
import 'package:dummy/SpaceX_API/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SpaceXLaunchesScreen extends StatefulWidget {
  const SpaceXLaunchesScreen({super.key});

  @override
  State<SpaceXLaunchesScreen> createState() => _SpaceXLaunchesScreenState();
}

class _SpaceXLaunchesScreenState extends State<SpaceXLaunchesScreen> {
  List<dynamic> _launches = [];
  Map<String, String> _rocketNames = {};
  Map<String, String> _padNames = {};
  bool _loading = true;
  String _error = '';
  bool _showUpcoming = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final launchRes = await http.get(
        Uri.parse('https://api.spacexdata.com/v4/launches'),
      );
      final rocketRes = await http.get(
        Uri.parse('https://api.spacexdata.com/v4/rockets'),
      );
      final padRes = await http.get(
        Uri.parse('https://api.spacexdata.com/v4/launchpads'),
      );

      if (launchRes.statusCode == 200 &&
          rocketRes.statusCode == 200 &&
          padRes.statusCode == 200) {
        final launches = json.decode(launchRes.body);
        final rockets = json.decode(rocketRes.body);
        final pads = json.decode(padRes.body);

        final rocketMap = {for (var r in rockets) r['id']: r['name']};
        final padMap = {
          for (var p in pads) p['id']: "${p['name']}, ${p['locality']}",
        };

        setState(() {
          _launches = launches;
          _rocketNames = rocketMap.cast<String, String>();
          _padNames = padMap.cast<String, String>();
          _loading = false;
        });
      } else {
        setState(() => _error = 'Failed to fetch data');
      }
    } catch (e) {
      setState(() => _error = 'Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_error.isNotEmpty) return Scaffold(body: Center(child: Text(_error)));

    final filtered =
        _launches
            .where((l) => (l['upcoming'] ?? false) == _showUpcoming)
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "SpaceX Launches API",
          style: MyTextSample.headline(
            context,
          )!.copyWith(color: MyColorsSample.green),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ChoiceChip(
                backgroundColor: Colors.white,
                selectedColor: Colors.lightBlueAccent,
                label: const Text("Past"),
                selected: !_showUpcoming,
                onSelected: (_) => setState(() => _showUpcoming = false),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                backgroundColor: Colors.white,
                selectedColor: Colors.lightBlueAccent,
                label: const Text("Upcoming"),
                selected: _showUpcoming,
                onSelected: (_) => setState(() => _showUpcoming = true),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final launch = filtered[index];
                final imageUrl =
                    launch['links']?['patch']?['large'] ??
                    'https://via.placeholder.com/300x180.png?text=No+Image';
                final missionName = launch['name'] ?? 'Unnamed Launch';
                final rocketName =
                    _rocketNames[launch['rocket']] ?? 'Unknown Rocket';
                final padName =
                    _padNames[launch['launchpad']] ?? 'Unknown Launchpad';
                final success = launch['success'];
                final details = launch['details'] ?? 'No description available';
                final dateStr = launch['date_utc'] ?? '';
                // final dateTime =
                //     dateStr.isNotEmpty ? DateTime.tryParse(dateStr) : null;

                // if (dateTime == null) return const SizedBox.shrink();

                DateTime? dateTime;
                try {
                  dateTime =
                      dateStr.isNotEmpty
                          ? DateTime.parse(dateStr).toLocal()
                          : null;
                } catch (_) {
                  dateTime = null;
                }
                if (dateTime == null) {
                  return const SizedBox.shrink();
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  child: GestureDetector(
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => LaunchDetailPage(
                                  launch: launch,
                                  rocketName: rocketName,
                                  padName: padName,
                                ),
                          ),
                        ),
                    child: LaunchCard(
                      imageUrl: imageUrl,
                      missionName: missionName,
                      rocketName: rocketName,
                      launchpad: padName,
                      date: dateTime.toLocal().toString().split(' ')[0],
                      success: success,
                      details: details,
                      launchTime: dateTime.toLocal(),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
