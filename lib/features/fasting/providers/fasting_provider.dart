import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/fasting_session.dart';
import '../data/repositories/fasting_repository.dart';

/// Estado extendido: ahora incluye elapsed y remaining
class FastingTimerState {
  final FastingSession? activeSession;
  final Duration elapsed;
  final Duration remaining;
  final bool isLoading;
  final String? error;

  FastingTimerState({
    this.activeSession,
    this.elapsed = Duration.zero,
    this.remaining = Duration.zero,
    this.isLoading = false,
    this.error,
  });

  FastingTimerState copyWith({
    FastingSession? activeSession,
    Duration? elapsed,
    Duration? remaining,
    bool? isLoading,
    String? error,
  }) {
    return FastingTimerState(
      activeSession: activeSession ?? this.activeSession,
      elapsed: elapsed ?? this.elapsed,
      remaining: remaining ?? this.remaining,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class FastingTimerController extends StateNotifier<FastingTimerState> {
  final FastingRepository _repository;
  final String _userId;

  Timer? _timer;

  FastingTimerController(this._repository, this._userId)
      : super(FastingTimerState(isLoading: true)) {
    _init();
  }

  Future<void> _init() async {
    try {
      final session = await _repository.getActiveSession(_userId);
      state = state.copyWith(activeSession: session, isLoading: false);

      if (session != null) {
        _startInternalTimer();
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Timer persistente dentro del provider
  void _startInternalTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final session = state.activeSession;
      if (session == null) return;

      final now = DateTime.now();
      final elapsed = now.difference(session.startTime);
      final target = Duration(hours: session.targetHours);
      Duration remaining = target - elapsed;
      if (remaining.isNegative) remaining = Duration.zero;

      state = state.copyWith(
        elapsed: elapsed,
        remaining: remaining,
      );
    });
  }

  /// Iniciar ayuno
  Future<void> startFasting(String protocol, int targetHours) async {
    state = state.copyWith(isLoading: true);

    await _repository.startFasting(
      userId: _userId,
      protocol: protocol,
      targetHours: targetHours,
    );

    final session = await _repository.getActiveSession(_userId);

    state = state.copyWith(
      activeSession: session,
      isLoading: false,
      elapsed: Duration.zero,
      remaining: Duration(hours: targetHours),
    );

    _startInternalTimer();
  }

  /// Finalizar ayuno
  Future<void> endFasting() async {
    if (state.activeSession == null) return;

    state = state.copyWith(isLoading: true);

    await _repository.endFasting(
      userId: _userId,
      sessionId: state.activeSession!.id,
      xpEarned: 50,
    );

    state = FastingTimerState(activeSession: null);
    _timer?.cancel();
  }

  /// Cancelar ayuno
  Future<void> cancelFasting() async {
    if (state.activeSession == null) return;

    await _repository.cancelFasting(
      userId: _userId,
      sessionId: state.activeSession!.id,
    );

    state = FastingTimerState(activeSession: null);
    _timer?.cancel();
  }

  /// Actualización desde Firestore (stream)
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

/// Provider
final fastingTimerControllerProvider = StateNotifierProvider.family<
    FastingTimerController, FastingTimerState, String>(
  (ref, userId) {
    final repository = ref.watch(fastingRepositoryProvider);
    return FastingTimerController(repository, userId);
  },
);
