import 'package:dummy/SpaceX_API/utils.dart';
import 'package:flutter/material.dart';

class LaunchCard extends StatelessWidget {
  final String imageUrl, missionName, rocketName, date, launchpad;
  final bool? success;
  final String details;
  final DateTime launchTime;

  const LaunchCard({
    super.key,
    required this.imageUrl,
    required this.missionName,
    required this.rocketName,
    required this.date,
    required this.launchpad,
    required this.success,
    required this.details,
    required this.launchTime,
  });

  @override
  Widget build(BuildContext context) {
    final timeLabel =
        "${launchTime.hour.toString().padLeft(2, '0')}:${launchTime.minute.toString().padLeft(2, '0')}";

    return Card(
      color: Colors.grey[350],
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Image.network(
            imageUrl,
            height: 180,
            width: double.infinity,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 180,
                width: double.infinity,
                color: Colors.grey[300],
                alignment: Alignment.center,
                child: const Text('No Image'),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  missionName,
                  style: MyTextSample.headline(
                    context,
                  )!.copyWith(color: MyColorsSample.green),
                ),
                const SizedBox(height: 8),
                Text(
                  "$date • $rocketName",
                  style: MyTextSample.medium(
                    context,
                  ).copyWith(color: MyColorsSample.grey_80),
                ),
                const SizedBox(height: 4),
                Text(
                  "Launchpad: $launchpad",
                  style: MyTextSample.medium(
                    context,
                  )!.copyWith(color: MyColorsSample.grey_60),
                ),
                const SizedBox(height: 10),
                Text(
                  details,
                  style: MyTextSample.medium(
                    context,
                  )!.copyWith(color: MyColorsSample.grey_40),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Launch Time",
                  style: MyTextSample.medium(
                    context,
                  ).copyWith(color: MyColorsSample.grey_80),
                ),
                const SizedBox(height: 5),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {},
                  child: Text(
                    timeLabel,
                    style: const TextStyle(color: MyColorsSample.grey_60),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
