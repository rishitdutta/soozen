// session_detail_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import intl package for date formatting
import 'new_session_page.dart';

class SessionDetailPage extends StatelessWidget {
  final Map session;

  const SessionDetailPage({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    List<String> checkpoints = List<String>.from(session['checkpoints']);
    Map<String, int> completionTimes = Map<String, int>.from(session['completionTimes']);
    final dateTime = session['dateTime'] != null
        ? DateTime.parse(session['dateTime'])
        : DateTime.now();
    final formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);

    return Scaffold(
      appBar: AppBar(
        title: Text(session['sessionName'] ?? 'Session Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewSessionPage(
                    sessionName: session['sessionName'] ?? '',
                    duration: Duration(seconds: session['duration']),
                    checkpoints: checkpoints,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Date: $formattedDateTime',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: checkpoints.length,
                itemBuilder: (context, index) {
                  String checkpoint = checkpoints[index];
                  int timeInSeconds = completionTimes[checkpoint] ?? 0;
                  Duration time = Duration(seconds: timeInSeconds);
                  return ListTile(
                    title: Text(checkpoint),
                    trailing: Text(
                      '${time.inMinutes}:${(time.inSeconds % 60).toString().padLeft(2, '0')}',
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}