import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart'; // Import intl package for date formatting

class SessionSummaryPage extends StatefulWidget {
  final String sessionName;
  final List<String> checkpoints;
  final List<String> completedCheckpoints;
  final Map<String, Duration?> completionTimes;
  final Duration duration;

  const SessionSummaryPage({
    super.key,
    required this.sessionName,
    required this.checkpoints,
    required this.completedCheckpoints,
    required this.completionTimes,
    required this.duration,
  });

  @override
  _SessionSummaryPageState createState() => _SessionSummaryPageState();
}

class _SessionSummaryPageState extends State<SessionSummaryPage> {
  late TextEditingController _sessionNameController;

  @override
  void initState() {
    super.initState();
    _sessionNameController = TextEditingController(text: widget.sessionName);
  }

  void _saveSession() async {
    final box = await Hive.openBox('sessions');
    final formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    await box.add({
      'sessionName': _sessionNameController.text,
      'checkpoints': widget.checkpoints,
      'completedCheckpoints': widget.completedCheckpoints,
      'completionTimes': widget.completionTimes.map((key, value) => MapEntry(key, value?.inSeconds ?? -1)),
      'duration': widget.duration.inSeconds,
      'dateTime': formattedDateTime,
    });
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _sessionNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Session Summary'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveSession,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Session Name with Edit Option
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _sessionNameController,
                    decoration: const InputDecoration(
                      labelText: 'Session Name',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Summary Table
            Expanded(
              child: ListView.builder(
                itemCount: widget.checkpoints.length,
                itemBuilder: (context, index) {
                  String checkpoint = widget.checkpoints[index];
                  Duration? time = widget.completionTimes[checkpoint];
                  String timeString = time != null
                      ? '${time.inMinutes}:${(time.inSeconds % 60).toString().padLeft(2, '0')}'
                      : 'Not completed';
                  return ListTile(
                    title: Text(checkpoint),
                    trailing: Text(timeString),
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