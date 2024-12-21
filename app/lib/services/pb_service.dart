import 'package:pocketbase/pocketbase.dart';

/// Service for interacting with the PocketBase API
class PbService {
  /// The PocketBase instance
  final PocketBase pb;

  /// Creates a new PocketBase service
  PbService(this.pb);

  /// Gets the collection with the given name
  RecordService collection(String name) => pb.collection(name);
} 