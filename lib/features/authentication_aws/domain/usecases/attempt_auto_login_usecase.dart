import 'package:appdriver/features/authentication_aws/domain/repositories/authentication_repository.dart';

class AttemptAutoLoginUseCase {
  AttemptAutoLoginUseCase({
    required AuthenticationRepository repository,
  }) : _repository = repository;

  final AuthenticationRepository _repository;

  Future<bool> call() async {
    return await _repository.attemptAutoLogin();
  }
}
