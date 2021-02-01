

import 'package:geolocator/geolocator.dart';
import 'package:uber/map.dart';
import 'package:uber/places_api/request_api.dart';

class FetchUrl{
  static Future<String> searchCoordinateAddress(Position position) async{
    String placeAddress = '';
    String url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapkey';

    var response = RequestApi.getRequest(url);
    if(response != 'faild'){
      //placeAddress = response['results'][0]['formatted_address'];
    }
    return placeAddress;
  }
}