import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/fasting_session.dart';
import '../data/repositories/fasting_repository.dart';

/// Estado del timer de ayuno
class FastingTimerState {
  final FastingSession? activeSession;
  final bool isLoading;
  final String? error;

  FastingTimerState({
    this.activeSession,
    this.isLoading = false,
    this.error,
  });

  FastingTimerState copyWith({
    FastingSession? activeSession,
    bool? isLoading,
    String? error,
  }) {
    return FastingTimerState(
      activeSession: activeSession ?? this.activeSession,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

/// Controller del timer de ayuno
class FastingTimerController extends StateNotifier<FastingTimerState> {
  final FastingRepository _repository;
  final String _userId;

  FastingTimerController(this._repository, this._userId)
      : super(FastingTimerState(isLoading: true)) {
    _init();
  }

  Future<void> _init() async {
    try {
      final session = await _repository.getActiveSession(_userId);
      state = FastingTimerState(activeSession: session, isLoading: false);
    } catch (e) {
      state = FastingTimerState(isLoading: false, error: e.toString());
    }
  }

  /// Iniciar ayuno
  Future<void> startFasting(String protocol, int targetHours) async {
    state = state.copyWith(isLoading: true);

    try {
      print('🔥 Iniciando ayuno en Firebase...');
      await _repository.startFasting(
        userId: _userId,
        protocol: protocol,
        targetHours: targetHours,
      );
      print('✅ Ayuno iniciado en Firebase');

      final session = await _repository.getActiveSession(_userId);
      state = FastingTimerState(activeSession: session, isLoading: false);
      print('✅ Sesión cargada: ${session?.id}');
    } catch (e) {
      print('❌ Error iniciando ayuno: $e');
      state = FastingTimerState(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  /// Finalizar ayuno
  Future<void> endFasting() async {
    if (state.activeSession == null) return;

    state = state.copyWith(isLoading: true);

    try {
      final session = state.activeSession!;

      int xp = 0;
      if (session.isCompleted) {
        xp = 50;
        if (session.targetHours >= 18) xp = 75;
        if (session.targetHours >= 20) xp = 100;
        if (session.protocol == 'omad') xp = 150;
      } else {
        xp = (50 * session.progress).toInt();
      }

      print('🔥 Finalizando ayuno en Firebase...');
      await _repository.endFasting(
        userId: _userId,
        sessionId: session.id,
        xpEarned: xp,
      );
      print('✅ Ayuno finalizado. XP ganado: $xp');

      state = FastingTimerState(activeSession: null, isLoading: false);
    } catch (e) {
      print('❌ Error finalizando ayuno: $e');
      state = FastingTimerState(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  /// Cancelar ayuno
  Future<void> cancelFasting() async {
    if (state.activeSession == null) return;

    state = state.copyWith(isLoading: true);

    try {
      print('🔥 Cancelando ayuno en Firebase...');
      await _repository.cancelFasting(
        userId: _userId,
        sessionId: state.activeSession!.id,
      );
      print('✅ Ayuno cancelado');

      state = FastingTimerState(activeSession: null, isLoading: false);
    } catch (e) {
      print('❌ Error cancelando ayuno: $e');
      state = FastingTimerState(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  void updateSession(FastingSession? session) {
    state = FastingTimerState(activeSession: session, isLoading: false);
  }
}

/// Provider del controller
final fastingTimerControllerProvider = StateNotifierProvider.family<
    FastingTimerController, FastingTimerState, String>(
  (ref, userId) {
    final repository = ref.watch(fastingRepositoryProvider);
    final controller = FastingTimerController(repository, userId);

    repository.watchActiveSession(userId).listen((session) {
      print('📡 Stream update: ${session?.id ?? "null"}');
      controller.updateSession(session);
    });

    return controller;
  },
);
