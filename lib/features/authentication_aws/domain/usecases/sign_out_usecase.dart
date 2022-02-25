import 'package:appdriver/features/authentication_aws/domain/repositories/authentication_repository.dart';

class SignOutUseCase {
  SignOutUseCase({
    required AuthenticationRepository repository,
  }) : _repository = repository;

  final AuthenticationRepository _repository;

  Future<void> call() async => await _repository.signOut();
}
