
import 'package:appdriver/features/operation/data/models/operation_model.dart';
import 'package:appdriver/features/operation/domain/repositories/operation_repository.dart';

class GetOperationUseCase {
  GetOperationUseCase({
    required OperationRepository repository,
  })  :
        _repository = repository;

  final OperationRepository _repository;

  /// Callable class method
  Future<Operation?> call( ) async {
    return await  _repository.operation();
  }
}
