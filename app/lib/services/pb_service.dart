import 'package:pocketbase/pocketbase.dart';

/// Global PocketBase instance
final pb = PocketBase('YOUR_POCKETBASE_URL');

/// Service for interacting with the PocketBase API
class PbService {
  /// The PocketBase instance
  final PocketBase pb;

  /// Creates a new PocketBase service
  PbService(this.pb);

  /// Gets the collection with the given name
  RecordService collection(String name) => pb.collection(name);
} 