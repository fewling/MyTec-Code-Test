import 'dart:convert';

import '../../../utils/mixins/api_clients/tec/tec_api_client.dart';
import '../../../utils/mixins/exceptions/custom_exception_handler.dart';
import '../data/centre_group.dart';

class RemoteCentreGroupRepo with CustomExceptionHandler, TecApiClient {
  Future<Result<List<CentreGroup>, CustomException>> getCentreGroups() =>
      tryRunAsync(() async {
        final response = await requestTEC(
          request: TecApiRequest.getCentreGroups(),
        );

        final json = jsonDecode(response.body) as List<dynamic>;
        return json
            .map((item) => CentreGroup.fromJson(item as Map<String, dynamic>))
            .toList();
      });
}
