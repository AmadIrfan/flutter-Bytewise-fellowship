import 'package:bfsw2_provider/data/responce/status.dart';

class ApiResponse<T> {
  Status? status;
  T? data;
  String? message;
  ApiResponse(this.data, this.message, this.status);

  ApiResponse.loading() : status = Status.loading;
  ApiResponse.completed() : status = Status.completed;
  ApiResponse.error() : status = Status.error;

  @override
  String toString() {
    return 'Status :$status \n Message $message \n Data :$data ';
  }
}
