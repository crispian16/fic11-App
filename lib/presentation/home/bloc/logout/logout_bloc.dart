// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:fic11_starter_pos/data/datasources/auth_remote_datasource.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'logout_event.dart';
part 'logout_state.dart';
part 'logout_bloc.freezed.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  final AuthRemoteDatasource _authRemoteDatasource;
  LogoutBloc(
    this._authRemoteDatasource,
  ) : super(const _Initial()) {
    on<_Logout>((event, emit) async {
      emit(const LogoutState.loading());
      final result = await _authRemoteDatasource.logout();
      result.fold(
        (l) => emit(LogoutState.error(l)),
        (r) => emit(const LogoutState.success()),
      );
    });
  }
}
