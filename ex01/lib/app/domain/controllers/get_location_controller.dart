import 'package:ex00/app/domain/models/place.dart';
import 'package:location/location.dart';

class GetLocationController {
  final Function() onPermissionDenied;
  final Function(Place) onLocationGetted;
  GetLocationController({
    required this.onPermissionDenied,
    required this.onLocationGetted,
  });

  fetchUserLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return onPermissionDenied.call();
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return onPermissionDenied.call();
      }
    }

    locationData = await location.getLocation();
    return onLocationGetted.call(Place(
        name: "Current location",
        region: null,
        country: null,
        coordinates: {
          locationData.latitude!.toString(): locationData.longitude!.toString()
        }));
  }
}
