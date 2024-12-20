
// event have image, but we use pocketbase image url
// so we create function to get the image url
import 'package:shared/shared.dart';

import 'main.dart';




// Each uploaded file could be accessed by requesting its file url:
// http://127.0.0.1:8090/api/files/COLLECTION_ID_OR_NAME/RECORD_ID/FILENAME

// If your file field has the Thumb sizes option, you can get a thumb of the image file (currently limited to jpg, png, and partially gif – its first frame) by adding the thumb query parameter to the url like this: http://127.0.0.1:8090/api/files/COLLECTION_ID_OR_NAME/RECORD_ID/FILENAME?thumb=100x300

// The following thumb formats are currently supported:

//     WxH (e.g. 100x300) - crop to WxH viewbox (from center)
//     WxHt (e.g. 100x300t) - crop to WxH viewbox (from top)
//     WxHb (e.g. 100x300b) - crop to WxH viewbox (from bottom)
//     WxHf (e.g. 100x300f) - fit inside a WxH viewbox (without cropping)
//     0xH (e.g. 0x300) - resize to H height preserving the aspect ratio
//     Wx0 (e.g. 100x0) - resize to W width preserving the aspect ratio

// The original file would be returned, if the requested thumb size is not found or the file is not an image!

// If you already have a Record model instance, the SDKs provide a convenient method to generate a file url by its name.

String? getFileUrl(String collectionIdOrName, String recordId, String? fileName) {
  if (collectionIdOrName.isEmpty || recordId.isEmpty || (fileName?.isEmpty ?? true)) {
    return null;
  }
  return '${pb.baseUrl}/api/files/$collectionIdOrName/$recordId/$fileName';
}

// extensions for easier access to pocketbase file url from our models
extension EventPocketbaseFileUrl on FacilityEvent {
  String? get imageUrl => getFileUrl("facilities_events", id, image);
}
