part of 'constants.dart';

enum EnvKeys {
  tecApiBaseUrl('TEC_API_BASE_URL'),
  tecApiAccessKey('X_ACCESS_KEY');

  const EnvKeys(this.key);

  final String key;
}
