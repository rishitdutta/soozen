// timer_page.dart
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'session_summary_page.dart';
import 'package:audioplayers/audioplayers.dart'; // For audio playback
import 'package:vibration/vibration.dart'; // For vibration
import 'package:wakelock_plus/wakelock_plus.dart';

class TimerPage extends StatefulWidget {
  final String sessionName;
  final Duration duration;
  final List<String> checkpoints;

  const TimerPage({
    Key? key,
    required this.sessionName,
    required this.duration,
    required this.checkpoints,
  }) : super(key: key);

  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  late Duration _remainingTime;
  Duration _elapsedTime = Duration.zero;
  Timer? _timer;
  int _currentCheckpointIndex = 0;
  final List<String> _completedCheckpoints = [];
  final Map<String, Duration?> _completionTimes = {};
  bool _isRunning = true;
  bool _timerEnded = false;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.duration;
    // Initialize completion times with null for each checkpoint
    _completionTimes.addAll({ for (var checkpoint in widget.checkpoints) checkpoint: null });
    _startTimer();
    _enterFullscreen();
  }

  void _startTimer() {
    _timer?.cancel();
    WakelockPlus.enable();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime.inSeconds > 0) {
        setState(() {
          _remainingTime -= const Duration(seconds: 1);
          _elapsedTime += const Duration(seconds: 1); // Update elapsed time
        });
      } else {
        timer.cancel();
        setState(() {
          _isRunning = false;
          _timerEnded = true;
        });
        _startAlert();
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    WakelockPlus.disable();
    setState(() {
      _isRunning = false;
    });
  }

  void _resumeTimer() {
    WakelockPlus.enable();
    _startTimer();
    setState(() {
      _isRunning = true;
    });
  }

  void _stopTimer() {
    _stopAlert();
    _timer?.cancel();
    WakelockPlus.disable();
    _exitFullscreen();
    _showSummary();
  }

  void _startAlert() async {
    // Start vibration
    if (await Vibration.hasVibrator() ?? false) {
      try {
        // Pattern array: [wait1, vibrate1, wait2, vibrate2]
        // Repeat index must be between 0 and pattern.length-1
        await Vibration.vibrate(duration: 1000);
      } catch (e) {
        debugPrint('Vibration failed: $e');
      }
    } else {
      debugPrint('Device does not have vibration capability');
    }
    // Play beep sound in loop
    _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.play(AssetSource('sounds/beep.mp3'));

    // Stop after 15 seconds
    await Future.delayed(const Duration(seconds: 15));
    if (_timerEnded) {
      _stopAlert();
    }
  }

  void _stopAlert() {
    Vibration.cancel();
    _audioPlayer.stop();
  }

  void _extendTimer() {
    _stopAlert();
    setState(() {
      _remainingTime = const Duration(minutes: 5);
      _isRunning = true;
      _timerEnded = false;
    });
    _startTimer();
  }

  void _markCheckpointCompleted() {
    if (_currentCheckpointIndex < widget.checkpoints.length) {
      String checkpoint = widget.checkpoints[_currentCheckpointIndex];
      _completedCheckpoints.add(checkpoint);
      _completionTimes[checkpoint] = _elapsedTime; // Use elapsed time
      setState(() {
        _currentCheckpointIndex++;
      });
    }
    if (_currentCheckpointIndex >= widget.checkpoints.length) {
      _stopTimer();
    }
  }

  void _showSummary() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SessionSummaryPage(
          sessionName: widget.sessionName,
          checkpoints: widget.checkpoints,
          completedCheckpoints: _completedCheckpoints,
          completionTimes: _completionTimes,
          duration: widget.duration,
        ),
      ),
    );
  }

  void _enterFullscreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  void _exitFullscreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  @override
  void dispose() {
    _stopAlert();
    _timer?.cancel();
    _audioPlayer.dispose();
    _exitFullscreen();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String currentCheckpoint = _currentCheckpointIndex < widget.checkpoints.length
        ? widget.checkpoints[_currentCheckpointIndex]
        : 'All targets completed';

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${_remainingTime.inHours.toString().padLeft(2, '0')}:${(_remainingTime.inMinutes % 60).toString().padLeft(2, '0')}:${(_remainingTime.inSeconds % 60).toString().padLeft(2, '0')}',
              style: const TextStyle(
                fontSize: 80,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              currentCheckpoint,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 30,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 40),
            if (!_timerEnded) ...[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
                onPressed: _markCheckpointCompleted,
                child: const Text('Mark as Completed'),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      _isRunning ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: 40,
                    ),
                    onPressed: _isRunning ? _pauseTimer : _resumeTimer,
                  ),
                  const SizedBox(width: 40),
                  IconButton(
                    icon: const Icon(
                      Icons.stop,
                      color: Colors.white,
                      size: 40,
                    ),
                    onPressed: _stopTimer,
                  ),
                ],
              ),
            ] else ...[
              ElevatedButton(
                onPressed: _stopTimer,
                child: const Text('Stop'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _extendTimer,
                child: const Text('Extend 5 Minutes'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}