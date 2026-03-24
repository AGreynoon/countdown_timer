import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TickerNotifier extends StateNotifier<DateTime> with WidgetsBindingObserver {
  Timer? _timer;

  TickerNotifier() : super(DateTime.now()) {
    _startTimer();
    WidgetsBinding.instance.addObserver(this);
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      state = DateTime.now();
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      this.state = DateTime.now(); // Immediate resync
      _startTimer();
    } else if (state == AppLifecycleState.paused) {
      _stopTimer();
    }
  }

  @override
  void dispose() {
    _stopTimer();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}

final tickerProvider = StateNotifierProvider<TickerNotifier, DateTime>((ref) {
  return TickerNotifier();
});
