import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  ApiClient._();
  static final instance = ApiClient._();

  static const _tokenKey = 'jwt_token';
  final _http = http.Client();
  final _storage = const FlutterSecureStorage();
  String? _token;

  String get _baseUrl {
    final configuredUrl = dotenv.env['API_BASE_URL'];
    if (configuredUrl == null || configuredUrl.isEmpty) {
      return 'http://localhost:5080/api';
    }
    return configuredUrl;
  }

  Future<void> carregarToken() async {
    _token = await _storage.read(key: _tokenKey);
  }

  Future<void> salvarToken(String token) async {
    _token = token;
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<void> removerToken() async {
    _token = null;
    await _storage.delete(key: _tokenKey);
  }

  Future<dynamic> get(String path, {Map<String, String>? query}) =>
      _send('GET', path, query: query);

  Future<dynamic> post(String path, Map<String, dynamic> body) =>
      _send('POST', path, body: body);

  Future<dynamic> put(String path, Map<String, dynamic> body) =>
      _send('PUT', path, body: body);

  Future<dynamic> delete(String path) => _send('DELETE', path);

  Future<dynamic> _send(
    String method,
    String path, {
    Map<String, String>? query,
    Map<String, dynamic>? body,
  }) async {
    final uri = Uri.parse('$_baseUrl$path').replace(queryParameters: query);
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (_token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }

    late final http.Response response;
    try {
      switch (method) {
        case 'GET':
          response = await _http.get(uri, headers: headers);
          break;
        case 'POST':
          response = await _http.post(
            uri,
            headers: headers,
            body: jsonEncode(body),
          );
          break;
        case 'PUT':
          response = await _http.put(
            uri,
            headers: headers,
            body: jsonEncode(body),
          );
          break;
        case 'DELETE':
          response = await _http.delete(uri, headers: headers);
          break;
        default:
          throw ArgumentError('Método HTTP inválido: $method');
      }
    } on http.ClientException {
      throw const ApiException('Não foi possível conectar à API.', 0);
    }

    late final Map<String, dynamic> respostaPadronizada;
    try {
      respostaPadronizada = jsonDecode(response.body) as Map<String, dynamic>;
    } on FormatException {
      throw ApiException(
        'A API retornou uma resposta inválida.',
        response.statusCode,
      );
    }

    final statusValido =
        response.statusCode >= 200 && response.statusCode < 300;
    final operacaoBemSucedida = respostaPadronizada['success'] == true;
    if (statusValido && operacaoBemSucedida) {
      return respostaPadronizada['data'];
    }

    final erros = (respostaPadronizada['errors'] as List<dynamic>? ?? []).join(
      '\n',
    );
    final mensagem =
        respostaPadronizada['message']?.toString() ?? 'Erro ao acessar a API.';
    if (erros.isEmpty) {
      throw ApiException(mensagem, response.statusCode);
    }

    throw ApiException('$mensagem\n$erros', response.statusCode);
  }
}

class ApiException implements Exception {
  final String message;
  final int statusCode;

  const ApiException(this.message, this.statusCode);

  @override
  String toString() => message;
}
