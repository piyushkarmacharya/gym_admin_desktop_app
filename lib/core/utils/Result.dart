class Result<T>{
  T? _value;
  ErrorResult? _error;
  Result.value(T value){
    _value=value;
  }
  Result.error(ErrorResult error){
    _error=error;
  }

  T? get value=>_value;
  ErrorResult? get error=>_error;

  bool isValue()=>_value!=null;
  bool isError()=>_error!=null;
}

class ErrorResult{
  final int statusCode;
  final String message;
  ErrorResult(this.statusCode,this.message);
}