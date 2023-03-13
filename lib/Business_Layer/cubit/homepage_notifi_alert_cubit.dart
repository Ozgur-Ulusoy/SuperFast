import 'package:bloc/bloc.dart';
import 'package:engame2/Data_Layer/data.dart';

part '../state/homepage_notifi_alert_state.dart';

class HomepageNotifiAlertCubit extends Cubit<HomepageNotifiAlertState> {
  HomepageNotifiAlertCubit()
      : super(HomepageNotifiAlertState(
            isNotifiAlert: MainData.homePageNotifiAlert));

  void ChangeNotifiAlert(bool val) {
    MainData.homePageNotifiAlert = val;
    emit(HomepageNotifiAlertState(isNotifiAlert: val));
  }
}
