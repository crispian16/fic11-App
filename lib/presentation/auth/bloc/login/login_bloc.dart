// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:fic11_starter_pos/data/datasources/auth_remote_datasource.dart';
import 'package:fic11_starter_pos/data/model/response/auth_response_model.dart';

part 'login_bloc.freezed.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRemoteDatasource authRemoteDatasource;
  LoginBloc(
    this.authRemoteDatasource,
  ) : super(const _Initial()) {
    on<_Login>((event, emit) async {
      emit(const _Loading());
      final response = await authRemoteDatasource.login(
        event.username,
        event.password,
      );
      response.fold(
        (l) => emit(_Error(l)),
        (r) => emit(_Success(r)),
      ); 
    });
  }
}
