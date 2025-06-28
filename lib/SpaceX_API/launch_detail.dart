import 'package:dummy/SpaceX_API/utils.dart';
import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

class LaunchDetailPage extends StatelessWidget {
  final Map<String, dynamic> launch;
  final String rocketName;
  final String padName;

  const LaunchDetailPage({
    super.key,
    required this.launch,
    required this.rocketName,
    required this.padName,
  });

  @override
  Widget build(BuildContext context) {
    final patch = launch['links']?['patch']?['large'];
    final date =
        launch['date_utc'] != null
            ? DateTime.parse(launch['date_utc']).toLocal().toString()
            : 'N/A';
    final success = launch['success'];
    final fairings = launch['fairings'];
    final article = launch['links']?['article'];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          launch['name'] ?? 'Launch Detail',
          style: MyTextSample.headline(
            context,
          )!.copyWith(color: MyColorsSample.green),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (patch != null)
              Image.network(
                patch ?? '',
                width: double.infinity,
                height: 200,
                fit: BoxFit.fill,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.grey[300],
                    alignment: Alignment.center,
                    child: const Text('No Image Available'),
                  );
                },
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    launch['name'] ?? '—',
                    style: MyTextSample.headline(context),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Rocket: $rocketName",
                    style: MyTextSample.display1(context),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Launchpad: $padName",
                    style: MyTextSample.medium(context),
                  ),
                  const SizedBox(height: 8),
                  Text("Date: $date", style: MyTextSample.medium(context)),
                  const SizedBox(height: 8),
                  Text(
                    "Flight #: ${launch['flight_number']}",
                    style: MyTextSample.display1(context),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Static fire date: ${launch['static_fire_date_utc'] ?? 'N/A'}",
                    style: MyTextSample.medium(context),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Success: ${success == true
                        ? 'Yes'
                        : success == false
                        ? 'No'
                        : 'Unknown'}",
                    style: MyTextSample.medium(context),
                  ),
                  const SizedBox(height: 12),
                  if (fairings != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Fairings:",
                          style: MyTextSample.display1(context),
                        ),
                        Text(
                          "  Reused: ${fairings['reused']}",
                          style: MyTextSample.medium(context),
                        ),
                        Text(
                          "  Recovery attempt: ${fairings['recovery_attempt']}",
                          style: MyTextSample.medium(context),
                        ),
                        Text(
                          "  Recovered: ${fairings['recovered']}",
                          style: MyTextSample.medium(context),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  Text("Details:", style: MyTextSample.display1(context)),
                  Text(
                    launch['details'] ?? 'No details provided',
                    style: MyTextSample.medium(context),
                  ),
                  const SizedBox(height: 12),
                  if (article != null)
                    TextButton(
                      onPressed: () async {
                        final uri = Uri.parse(article);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri);
                        }
                      },
                      child: const Text("Read full article"),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
