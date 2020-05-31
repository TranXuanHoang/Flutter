/// The key used in calling [Google Maps Static API](https://developers.google.com/maps/documentation/maps-static/intro).
/// See how to [Get an API Key and Signature](https://developers.google.com/maps/documentation/maps-static/get-api-key)
/// for more information.
/// 
/// This key value is also used in
/// * [android/app/src/main/AndroidManifest.xml]
/// ```dart
/// <manifest ...
///     <application ...
///     <meta-data android:name="com.google.android.geo.API_KEY"
///         android:value="YOUR KEY HERE"/>
/// ```
/// * [ios/Runner/AppDelegate.swift]
/// ```dart
/// ...
/// import GoogleMaps
/// ...
///     GMSServices.provideAPIKey("YOUR KEY HERE")
/// ```
/// 
/// Note: To allow this key to be used on Android and iOS devices,
/// we will need to enable the following Google Maps APIs:
/// * [Maps Static API](https://developers.google.com/maps/documentation/maps-static/intro)
/// * [Maps SDK for Android](https://developers.google.com/maps/documentation/android-sdk/)
/// * [Maps SDK for iOS](https://developers.google.com/maps/documentation/ios-sdk/)
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
