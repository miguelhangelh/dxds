import 'package:appdriver/features/models/user_model.dart';
import 'package:appdriver/features/authentication_aws/domain/repositories/authentication_repository.dart';

class UpdateTokenNotificationUseCase {
  UpdateTokenNotificationUseCase({
    required AuthenticationRepository repository,
  }) : _repository = repository;

  final AuthenticationRepository _repository;

  Future<void> call(UserModel user, String token) async => await _repository.updateTokenNotification(user, token);
}
