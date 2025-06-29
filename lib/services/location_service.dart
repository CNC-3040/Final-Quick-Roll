import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  Future<String> getLocationAddress() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return 'Location services are disabled.';
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return 'Location permissions are denied';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return 'Location permissions are permanently denied.';
    }

    // Get the current position
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Get the address from the coordinates
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    if (placemarks.isEmpty) {
      return 'No address available';
    }

    // Construct a detailed address string
    Placemark place = placemarks.first;
    String address =
        '${place.name ?? ''}, ${place.thoroughfare ?? ''}, ${place.subThoroughfare ?? ''}, ${place.locality ?? ''}, ${place.subLocality ?? ''}, ${place.administrativeArea ?? ''}, ${place.subAdministrativeArea ?? ''}, ${place.postalCode ?? ''}, ${place.country ?? ''}';

    // Remove any null or empty values from the address
    address = address.split(', ').where((part) => part.isNotEmpty).join(', ');

    return address;
  }
}