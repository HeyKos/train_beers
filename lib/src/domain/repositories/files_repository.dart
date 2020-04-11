import 'dart:io';

abstract class FilesRepository {
    Future<String> getDownloadUrl(String path);
    dynamic uploadFile(File file);
}
