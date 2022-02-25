part of 'phone_authentication1_bloc.dart';

class PhoneAuthenticationState extends Equatable {
  final String? username;
  final String? smsCode;
  final bool? loading;
  final bool? loginSuccess;
  final bool? registerSuccess;
  final bool? verifiedNumber;
  final bool? error;
  final bool? errorCreate;
  final int? duration;
  final bool? completedTicker;
  final String? messageError;
  const PhoneAuthenticationState({
    this.username,
    this.smsCode,
    this.loading,
    this.loginSuccess,
    this.registerSuccess,
    this.verifiedNumber,
    this.error,
    this.duration,
    this.errorCreate,
    this.completedTicker,
    this.messageError,
  });

  PhoneAuthenticationState copyWith({
    String? username,
    String? smsCode,
    bool? loading,
    bool? loginSuccess,
    bool? registerSuccess,
    bool? verifiedNumber,
    bool? error,
    int? duration,
    bool? errorCreate,
    bool? completedTicker,
    String? messageError,
  }) {
    return PhoneAuthenticationState(
      username: username ?? this.username,
      smsCode: smsCode ?? this.smsCode,
      errorCreate: errorCreate ?? this.errorCreate,
      loading: loading ?? this.loading,
      loginSuccess: loginSuccess ?? this.loginSuccess,
      registerSuccess: registerSuccess ?? this.registerSuccess,
      verifiedNumber: verifiedNumber ?? this.verifiedNumber,
      error: error ?? this.error,
      duration: duration ?? this.duration,
      completedTicker: completedTicker ?? this.completedTicker,
      messageError: messageError ?? this.messageError,
    );
  }

  static PhoneAuthenticationState get initialState => const PhoneAuthenticationState(
        username: '',
        smsCode: '',
        loading: false,
        loginSuccess: false,
        errorCreate: false,
        registerSuccess: false,
        verifiedNumber: false,
        error: false,
        duration: 60,
        completedTicker: false,
        messageError: '',
      );
  @override
  List<Object?> get props => [
        username,
        smsCode,
        errorCreate,
        loading,
        loginSuccess,
        error,
        duration,
        completedTicker,
        verifiedNumber,
        messageError,
        registerSuccess,
      ];
}
