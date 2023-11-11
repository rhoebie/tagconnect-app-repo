import 'dart:math';

class HaversineCalculator {
  static const double earthRadius = 6371; // Earth's radius in kilometers

  static double degreesToRadians(double degrees) {
    return degrees * (pi / 180.0);
  }

  static String calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    // Convert latitude and longitude from degrees to radians
    final double radLat1 = degreesToRadians(lat1);
    final double radLon1 = degreesToRadians(lon1);
    final double radLat2 = degreesToRadians(lat2);
    final double radLon2 = degreesToRadians(lon2);

    // Haversine formula
    final double dLat = radLat2 - radLat1;
    final double dLon = radLon2 - radLon1;
    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(radLat1) * cos(radLat2) * sin(dLon / 2) * sin(dLon / 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    final double distance = earthRadius * c;

    if (distance < 1) {
      final double distanceInMeters = distance * 1000;
      return '${distanceInMeters.toStringAsFixed(4)} m';
    } else {
      return '${distance.toStringAsFixed(4)} km';
    }
  }
}
