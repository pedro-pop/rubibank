import 'dart:io';

abstract class AppException implements Exception{
  final String message;
  final int statusCode;
  
  const AppException(this.message, this.statusCode);

  @override
  String toString() => message;
}

class ErrUserNotFound extends AppException{

  const ErrUserNotFound() :super('usuário não encontrado', HttpStatus.notFound);
  
}