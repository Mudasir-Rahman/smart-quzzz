import 'package:equatable/equatable.dart';

abstract class Failures extends Equatable {
  final String message;
  const Failures(this.message);

  @override
  List<Object?> get props => [message];
}

// General Failures
class ServerFailure extends Failures {
  const ServerFailure(String message) : super(message);
}
class AuthFailures extends Failures {
  const AuthFailures(String message) : super(message);
}

class CacheFailure extends Failures {
  const CacheFailure(String message) : super(message);
}

// File-related Failures
class FileFailure extends Failures {
  const FileFailure([String message = 'File operation failed']) : super(message);
}

class FileNotFoundFailure extends FileFailure {
  const FileNotFoundFailure(String s) : super('File not found');
}

class FileUploadFailure extends FileFailure {
  const FileUploadFailure(String s) : super('Failed to upload file');
}

class FileDeleteFailure extends FileFailure {
  const FileDeleteFailure() : super('Failed to delete file');
}
class FileDownloadFailure extends FileFailure {
  const FileDownloadFailure() : super('Failed to download file');
}
class StorageFailure extends FileFailure {
  const StorageFailure() : super('Failed to access storage');
}

class StorageException extends FileFailure {
  const StorageException() : super('Failed to access storage');
}
class PostgrestException extends FileFailure {
  const PostgrestException() : super('Failed to access database');
}
