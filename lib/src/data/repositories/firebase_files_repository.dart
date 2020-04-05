import 'package:firebase_storage/firebase_storage.dart';
import 'package:train_beers/src/domain/repositories/files_repository.dart';

class FirebaseFilesRepository implements FilesRepository {
  static final String storageBucket = 'gs://train-beers.appspot.com';
  final FirebaseStorage storage = FirebaseStorage(storageBucket: storageBucket);

  @override
  Future<String> getDownloadUrl(String path) async {
    var _ref = await  storage.getReferenceFromUrl('$storageBucket/$path');
    return await _ref.getDownloadURL(); 
  }
}
