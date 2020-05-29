/// The key used in calling [Google Maps Static API](https://developers.google.com/maps/documentation/maps-static/intro).
/// See how to [Get an API Key and Signature](https://developers.google.com/maps/documentation/maps-static/get-api-key)
/// for more information.
const GOOGLE_API_KEY = 'AIzaSyCghBAvPMF_rASLPubYJte0EOIQF7fTJGM';

class LocationHelper {
  /// Generates a URL to call Google Maps Static API to retrieve
  /// an image of the map for the given [latitude] and [logitude].
  /// See [Google Maps Static API Overview](https://developers.google.com/maps/documentation/maps-static/intro)
  /// for more information.
  static String generateLocationPreviewImage({
    double latitude,
    double longitude,
  }) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$latitude,$longitude&key=$GOOGLE_API_KEY';
  }
}
