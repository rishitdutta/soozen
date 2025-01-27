// new_session_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'timer_page.dart';

class NewSessionPage extends StatefulWidget {
  final String sessionName;
  final Duration duration;
  final List<String> checkpoints;

  const NewSessionPage({
    super.key,
    this.sessionName = '',
    this.duration = const Duration(),
    this.checkpoints = const [],
  });

  @override
  _NewSessionPageState createState() => _NewSessionPageState();
}

class _NewSessionPageState extends State<NewSessionPage> {
  late String _sessionName;
  late Duration _duration;
  late List<String> _checkpoints;
  final TextEditingController _sessionNameController = TextEditingController();
  final TextEditingController _checkpointController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _sessionName = widget.sessionName;
    _duration = widget.duration;
    _checkpoints = List<String>.from(widget.checkpoints);
    _sessionNameController.text = _sessionName;
  }

  void _pickDuration() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: MediaQuery.of(context).copyWith().size.height / 3,
          child: CupertinoTimerPicker(
            mode: CupertinoTimerPickerMode.hms,
            initialTimerDuration: _duration,
            onTimerDurationChanged: (Duration newDuration) {
              setState(() {
                _duration = newDuration;
              });
            },
          ),
        );
      },
    );
  }

  void _addCheckpoint() {
    String checkpoint = _checkpointController.text.trim();
    if (checkpoint.isNotEmpty) {
      setState(() {
        _checkpoints.add(checkpoint);
        _checkpointController.clear();
      });
    }
  }

  void _deleteCheckpoint(int index) {
    setState(() {
      _checkpoints.removeAt(index);
    });
  }

  void _reorderCheckpoints(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex -= 1;
      final item = _checkpoints.removeAt(oldIndex);
      _checkpoints.insert(newIndex, item);
    });
  }

  @override
  void dispose() {
    _sessionNameController.dispose();
    _checkpointController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Session'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Session Name
            TextField(
              controller: _sessionNameController,
              decoration: const InputDecoration(
                labelText: 'Session Name (optional)',
              ),
              onChanged: (value) {
                _sessionName = value;
              },
            ),
            const SizedBox(height: 20),
            // Time Picker
            ListTile(
              title: const Text('Select Duration'),
              subtitle: Text('${_duration.inHours}h ${_duration.inMinutes % 60}m ${_duration.inSeconds % 60}s'),
              trailing: const Icon(Icons.access_time),
              onTap: _pickDuration,
            ),
            const SizedBox(height: 20),
            // Add Labels
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _checkpointController,
                    decoration: const InputDecoration(
                      hintText: 'Add Label',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addCheckpoint,
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Labels List
            Expanded(
              child: ReorderableListView(
                onReorder: _reorderCheckpoints,
                children: [
                  for (int index = 0; index < _checkpoints.length; index++)
                    ListTile(
                      key: ValueKey(_checkpoints[index]),
                      leading: const Icon(Icons.drag_handle),
                      title: Text(_checkpoints[index]),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteCheckpoint(index),
                      ),
                    ),
                ],
              ),
            ),
            // Start Timer Button
            ElevatedButton(
              onPressed: () {
                if (_duration.inSeconds > 0 && _checkpoints.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TimerPage(
                        sessionName: _sessionName,
                        duration: _duration,
                        checkpoints: _checkpoints,
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please set duration and add at least one label')),
                  );
                }
              },
              child: const Text('Start Timer'),
            ),
          ],
        ),
      ),
    );
  }
}