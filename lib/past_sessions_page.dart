// past_sessions_page.dart
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'session_detail_page.dart';
import 'new_session_page.dart';
import 'package:intl/intl.dart'; // Import intl package for date formatting

class PastSessionsPage extends StatefulWidget {
  const PastSessionsPage({super.key});

  @override
  _PastSessionsPageState createState() => _PastSessionsPageState();
}

class _PastSessionsPageState extends State<PastSessionsPage> {
  List<Map> _sessions = [];
  bool _isSelectionMode = false;
  final Set<int> _selectedSessions = {};

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    final box = await Hive.openBox('sessions');
    setState(() {
      _sessions = box.toMap().values.toList().cast<Map>();
    });
  }

  void _toggleSelectionMode() {
    setState(() {
      _isSelectionMode = !_isSelectionMode;
      _selectedSessions.clear();
    });
  }

  void _deleteSelectedSessions() async {
    final box = await Hive.openBox('sessions');
    final keysToDelete = _selectedSessions.map((index) => box.keyAt(index)).toList();
    for (var key in keysToDelete) {
      await box.delete(key);
    }
    _toggleSelectionMode();
    _loadSessions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Past Sessions'),
        actions: [
          if (_isSelectionMode)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteSelectedSessions,
            )
          else
            IconButton(
              icon: const Icon(Icons.select_all),
              onPressed: _toggleSelectionMode,
            ),
        ],
      ),
      body: ListView.builder(
        itemCount: _sessions.length,
        itemBuilder: (context, index) {
          final session = _sessions[index];
          final isSelected = _selectedSessions.contains(index);
          final sessionName = session['sessionName'] ?? 'Unnamed Session';
          final duration = session['duration'] != null
              ? Duration(seconds: session['duration'])
              : Duration.zero;
          final dateTime = session['dateTime'] != null
              ? DateTime.parse(session['dateTime'])
              : DateTime.now();
          final formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);

          return ListTile(
            leading: _isSelectionMode
                ? Checkbox(
                    value: isSelected,
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          _selectedSessions.add(index);
                        } else {
                          _selectedSessions.remove(index);
                        }
                      });
                    },
                  )
                : null,
            title: Text(sessionName),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Duration: ${duration.inMinutes} minutes',
                ),
                Text(
                  'Date: $formattedDateTime',
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewSessionPage(
                      sessionName: sessionName,
                      duration: duration,
                      checkpoints: List<String>.from(session['checkpoints'] ?? []),
                    ),
                  ),
                );
              },
            ),
            onTap: _isSelectionMode
                ? () {
                    setState(() {
                      if (isSelected) {
                        _selectedSessions.remove(index);
                      } else {
                        _selectedSessions.add(index);
                      }
                    });
                  }
                : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SessionDetailPage(
                          session: session,
                        ),
                      ),
                    );
                  },
          );
        },
      ),
    );
  }
}