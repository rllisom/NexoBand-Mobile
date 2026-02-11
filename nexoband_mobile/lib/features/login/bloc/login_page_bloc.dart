import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'login_page_event.dart';
part 'login_page_state.dart';

class LoginPageBloc extends Bloc<LoginPageEvent, LoginPageState> {
  LoginPageBloc() : super(LoginPageInitial()) {
    on<LoginPageEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
