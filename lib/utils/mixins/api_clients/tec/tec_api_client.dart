import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:http/http.dart';

import '../../../constants/constants.dart';
import '../../../logging/logger.dart';
import '../../../serialization/serialization.dart';
import '../../exceptions/custom_exception_handler.dart';

part 'tec_api_client.freezed.dart';
part 'tec_api_client.g.dart';
part 'tec_api_endpoints.dart';
part 'tec_api_request.dart';
part 'tec_paginated_response.dart';

mixin TecApiClient {
  static final _baseUrl = dotenv.env[EnvKeys.tecApiBaseUrl.key];
  static final _accessKey = dotenv.env[EnvKeys.tecApiAccessKey.key];

  /// Use [TecApiRequest] to help you find the correct request body and query parameters
  ///
  /// Example:
  /// ```dart
  /// final response = await requestTEC(
  ///   request: TecApiRequest.getRoomAvailability(
  ///     ...
  ///   ),
  /// );
  /// ```
  ///
  Future<Response> requestTEC({required TecApiRequest request}) => _request(
    method: request.method,
    endpoint: request.endpoint,
    body: request.body?.toJson(),
    files: request.files,
    queryParams: request.queryParam?.toJson(),
  );

  Future<Response> _request({
    required Method method,
    required TecApiEndpoints endpoint,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParams,
    List<MultipartFile>? files,
  }) async {
    final accessKey = _accessKey;

    const publicEndpoints = [];
    if (!publicEndpoints.contains(endpoint) && accessKey == null) {
      logger.e('User is not authenticated');
      throw TecException(TecExceptionCode.unAuthenticated);
    }

    final url = '$_baseUrl/${endpoint.path}';
    final uri = Uri.parse(url).replace(
      queryParameters: queryParams?.map(
        (key, value) => MapEntry(key, '$value'),
      ),
    );

    final headers = {if (accessKey != null) 'x-access-key': accessKey};

    if (files != null && files.isNotEmpty) {
      return _uploadFilesRequest(
        method: method,
        uri: uri,
        headers: headers,
        files: files,
        body: body,
      );
    }

    return switch (method) {
      Method.get_ => get(uri, headers: headers),
      Method.post => post(uri, headers: headers, body: body),
      Method.put => put(uri, headers: headers, body: body),
      Method.patch => patch(uri, headers: headers, body: body),
      Method.delete => delete(uri, headers: headers),
    };
  }

  Future<Response> _uploadFilesRequest({
    required Method method,
    required Uri uri,
    required Map<String, String> headers,
    required List<MultipartFile> files,
    Map<String, dynamic>? body,
  }) async {
    assert(
      [Method.post, Method.put, Method.patch].contains(method),
      'Only POST, PUT, and PATCH methods are allowed for file uploads',
    );

    final request = MultipartRequest(switch (method) {
      Method.post => 'POST',
      Method.put => 'PUT',
      Method.patch => 'PATCH',
      _ => '',
    }, uri);
    request.headers.addAll(headers);
    request.files.addAll(files);

    // Add form fields if body is present
    body?.forEach((key, value) {
      request.fields[key] = '$value';
    });

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();
    return Response(responseBody, response.statusCode);
  }
}
