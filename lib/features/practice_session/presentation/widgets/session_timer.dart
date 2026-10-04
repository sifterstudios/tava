import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tava/features/practice_session/presentation/bloc/practice_session_bloc.dart';

class SessionTimer extends StatefulWidget {
  const SessionTimer({super.key});

  @override
  State<SessionTimer> createState() => _SessionTimerState();
}

class _SessionTimerState extends State<SessionTimer> {
  Timer? _timer;
  Duration _elapsed = Duration.zero;
  Duration _accumulated = Duration.zero;
  DateTime? _segmentStart;

  @override
  void initState() {
    super.initState();
    _resume();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _resume() {
    _segmentStart = DateTime.now();
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted || _segmentStart == null) return;
      setState(() {
        _elapsed = _accumulated + DateTime.now().difference(_segmentStart!);
      });
    });
  }

  void _pause() {
    if (_segmentStart != null) {
      _accumulated += DateTime.now().difference(_segmentStart!);
      _elapsed = _accumulated;
      _segmentStart = null;
    }
    _timer?.cancel();
    _timer = null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<PracticeSessionBloc, PracticeSessionState>(
      listenWhen: (previous, current) => previous.isRunning != current.isRunning,
      listener: (context, state) {
        if (state.isRunning) {
          _resume();
        } else {
          _pause();
          setState(() {});
        }
      },
      child: Semantics(
        liveRegion: true,
        label: 'Session timer ${_formatDuration(_elapsed)}',
        child: Text(
          _formatDuration(_elapsed),
          style: theme.textTheme.displayMedium?.copyWith(
            color: theme.colorScheme.onPrimaryContainer,
            fontWeight: FontWeight.bold,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }
}
