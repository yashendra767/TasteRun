import 'package:flutter/material.dart';
class Failure implements Exception {
  final String message;
  Failure(this.message);
  @override
  String toString() => message;
}
class NetworkFailure extends Failure {
  NetworkFailure(super.msg);
}
class ServerFailure extends Failure {
  ServerFailure(super.msg);
}
