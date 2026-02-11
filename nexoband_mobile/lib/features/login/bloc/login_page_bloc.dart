import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:nexoband_mobile/core/dto/login_request.dart';
import 'package:nexoband_mobile/core/model/auth_session_response.dart';
import 'package:nexoband_mobile/core/service/auth_session_service.dart';

part 'login_page_event.dart';
part 'login_page_state.dart';

class LoginPageBloc extends Bloc<LoginPageEvent, LoginPageState> {
  final AuthSessionService authSessionService;
  LoginPageBloc(this.authSessionService) : super(LoginPageInitial()) {
    on<IniciarSesion>((event, emit) async {
      emit(LoginPageLoading());
      try {
        final response = await authSessionService.iniciarSesion(event.request);
        emit(LoginPageSuccess(response));
      } catch (e) {
        emit(LoginPageError(e.toString()));
      }
    });
  }
}
