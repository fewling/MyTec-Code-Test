part of 'tec_api_client.dart';

@freezed
sealed class TecPaginatedResponse with _$TecPaginatedResponse {
  const factory TecPaginatedResponse({
    required int pageCount,
    required int totalItemCount,
    required int pageNumber,
    required int pageSize,
    required bool hasPreviousPage,
    required bool hasNextPage,
    required bool isFirstPage,
    required bool isLastPage,
    @Default(<dynamic>[]) List<dynamic> items,
  }) = _TecPaginatedResponse;

  factory TecPaginatedResponse.fromJson(Map<String, dynamic> json) =>
      _$TecPaginatedResponseFromJson(json);
}
