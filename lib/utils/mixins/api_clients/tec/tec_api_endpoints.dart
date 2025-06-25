part of 'tec_api_client.dart';

enum TecApiEndpoints {
  getRoomAvailability('core-api-me/api/v1/meetingrooms/availabilities'),
  getRoomPrice('core-api-me/api/v1/meetingrooms/pricings'),
  getRoomInfo('core-api-me/api/v1/meetingrooms'),
  getCentreGroup('core-api-me/api/v1/centregroups'),
  getCity('core-api/api/v1/cities');

  const TecApiEndpoints(this.path);

  final String path;
}
