class ApiResponse<T> {
  ResponseStatus status;
  T? data;
  String? message;

  ApiResponse.loading(this.message) : status = ResponseStatus.LOADING;
  ApiResponse.initial(this.message) : status = ResponseStatus.INITIAL;
  ApiResponse.completed(this.data) : status = ResponseStatus.COMPLETED;
  ApiResponse.error(this.message) : status = ResponseStatus.ERROR;

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $data";
  }
}

enum ResponseStatus { LOADING, COMPLETED, ERROR, NONE, INITIAL }
