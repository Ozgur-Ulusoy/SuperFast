import 'package:bloc/bloc.dart';

part '../state/login_page_state.dart';

class LoginPageCubit extends Cubit<LoginPageState> {
  LoginPageCubit()
      : super(LoginPageState(isSignInUsername: false, signInKey: "Email"));

  void ChangeSignInMethod() {
    emit(LoginPageState(
        isSignInUsername: !state.isSignInUsername,
        signInKey: state.isSignInUsername == true ? "Email" : "Kullanıcı adı"));
  }
}
