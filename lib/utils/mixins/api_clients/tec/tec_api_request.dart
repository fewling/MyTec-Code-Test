part of 'tec_api_client.dart';

final class TecApiRequest {
  const TecApiRequest({
    required this.method,
    required this.endpoint,
    this.body,
    this.queryParam,
    this.files,
  });

  TecApiRequest.getRoomAvailability({required RoomAvailabilityQuery query})
    : this(
        method: Method.get_,
        endpoint: TecApiEndpoints.getRoomAvailability,
        queryParam: query,
      );

  TecApiRequest.getRoomPrice({required RoomPriceQuery query})
    : this(
        method: Method.get_,
        endpoint: TecApiEndpoints.getRoomPrice,
        queryParam: query,
      );

  TecApiRequest.getRoomInfo({required RoomInfoQuery query})
    : this(
        method: Method.get_,
        endpoint: TecApiEndpoints.getRoomInfo,
        queryParam: query,
      );

  TecApiRequest.getCentreGroups()
    : this(method: Method.get_, endpoint: TecApiEndpoints.getCentreGroup);

  TecApiRequest.getCity({required CityQuery query})
    : this(
        method: Method.get_,
        endpoint: TecApiEndpoints.getCity,
        queryParam: query,
      );

  final Method method;
  final TecApiEndpoints endpoint;
  final TecApiRequestBody? body;
  final TecApiQueryParam? queryParam;
  final List<MultipartFile>? files;
}

@freezed
sealed class TecApiRequestBody with _$TecApiRequestBody {
  const factory TecApiRequestBody() = _TecApiRequestBody;

  factory TecApiRequestBody.fromJson(Map<String, dynamic> json) =>
      _$TecApiRequestBodyFromJson(json);
}

@Freezed()
sealed class TecApiQueryParam with _$TecApiQueryParam {
  const factory TecApiQueryParam.getRoomAvailability({
    @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
    required DateTime startDate,

    @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
    required DateTime endDate,

    required String cityCode,
  }) = RoomAvailabilityQuery;

  const factory TecApiQueryParam.getRoomPrice({
    @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
    required DateTime startDate,

    @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
    required DateTime endDate,

    required String cityCode,

    @Default(true) bool isVcBooking,
  }) = RoomPriceQuery;

  @JsonSerializable(includeIfNull: false)
  const factory TecApiQueryParam.getRoomInfo({
    required int pageSize,
    required int pageNumber,
    @JsonSerializable(includeIfNull: false) String? cityCode,
  }) = RoomInfoQuery;

  const factory TecApiQueryParam.getCity({
    required int pageSize,
    required int pageNumber,
  }) = CityQuery;

  factory TecApiQueryParam.fromJson(Map<String, dynamic> json) =>
      _$TecApiQueryParamFromJson(json);
}
