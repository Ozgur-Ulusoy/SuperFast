import 'package:bloc/bloc.dart';

part '../state/timer_state.dart';

class TimerCubit extends Cubit<TimerState> {
  TimerCubit() : super(TimerState());

  //* Zamanı azaltma - her saniye zaman azalır
  void DecreaseTime() {
    if (state.getRemainTime <= 0) return;
    state.remainTime -= 1;
    emit(TimerState(remainTime: state.remainTime));
  }

  //* Zamanı resetleme - oyun başladığında zaman her zaman resetlenir
  void ResetTime() {
    emit(TimerState());
  }
}
