import 'package:domain/error/base_error.dart';

class FileError extends BaseError<FileErrorCase> {
  FileError(FileErrorCase errorCase, String message)
      : super(errorCase, message);
}

enum FileErrorCase {
  NotExist,
}
