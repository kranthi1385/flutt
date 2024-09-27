import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:integrated_panel/src/utils/constants.dart';
import 'package:integrated_panel/src/utils/logger.dart';
import 'package:integrated_panel/src/utils/network_util.dart';

class ClientService {
  final String url;
  ClientService({required this.url});

 /// Performs an HTTP GET request.
  ///
  /// - [headers]: A map of HTTP headers to include in the request.
  /// - [params]: Optional query parameters to append to the URL.
  /// - [body]: Optional body of the request (not typically used with GET).
  ///
  /// Returns the response body as a [String] if successful.
  /// Throws an exception with an error message if the request fails.
  Future<String> get({
    required Map<String, String> headers,
    Map<String, dynamic>? params,
    Object? body,
  }) async {
    // Check for internet connectivity before making the request
    if (!(await NetworkUtil.isConnected())) {
      Logger.error('No Internet Connection', null);
      return 'No internet connection';
    }

    // Construct the full URI with query parameters if provided
    final Uri uri = Uri.parse(url).replace(queryParameters: params ?? {});
    var client = http.Client(); // Create a new HTTP client
    late http.Response response;

    try {
      // Make the GET request with a timeout
      response = await client
          .get(uri, headers: headers)
          .timeout(const Duration(seconds: Constants.apiTimeout));

      // Check if the response status is not OK (200)
      if (response.statusCode != HttpStatus.ok) {
        throw Exception(response.body); // Throw an exception with the response body
      }
    } catch (error) {
      // Re-throw the caught exception to be handled by the caller
      rethrow;
    } finally {
      // Ensure the HTTP client is closed to free resources
      client.close();
    }

    // Return the response body as a string
    return response.body;
  }

  /// Performs an HTTP POST request.
  ///
  /// - [headers]: A map of HTTP headers to include in the request.
  /// - [params]: Optional query parameters to append to the URL.
  /// - [body]: The body of the POST request, typically in JSON format.
  ///
  /// Returns the response body as a [String] if the creation is successful.
  /// If the response indicates that a PUT request should be used instead,
  /// it delegates the request to the [put] method.
  /// Throws an exception with an error message if the request fails.
  Future<String> post({
    required Map<String, String> headers,
    Map<String, dynamic>? params,
    Object? body,
  }) async {
    // Check for internet connectivity before making the request
    if (!(await NetworkUtil.isConnected())) {
      Logger.error('No Internet Connection', null);
      throw Exception('No Internet Connection');
    }

    try {
      // Construct the full URI with query parameters if provided
      final Uri uri = Uri.parse(url).replace(queryParameters: params ?? {});

      // Make the POST request with a timeout of 30 seconds
      final http.Response response = await http
          .post(uri, headers: headers, body: body)
          .timeout(const Duration(seconds: 30));

      // If the resource was successfully created (HTTP 201)
      if (response.statusCode == HttpStatus.created) {
        return response.body; // Return the response body
      } else {
        // Check if the response body contains a specific message indicating a PUT request is needed
        if (response.body.contains('To update a Member, please use the PUT verb')) {
          // Delegate to the PUT method to update the resource
          return await put(headers: headers, params: params, body: body);
        }

        // Log the error response body
        Logger.error(response.body, null);
        throw Exception(response.body); // Throw an exception with the response body
      }
    } catch (error, stackTrace) {
      // Log the error with the stack trace for debugging purposes
      Logger.error(error.toString(), stackTrace);
      rethrow; // Re-throw the exception to be handled by the caller
    }
  }

  /// Performs an HTTP PUT request.
  ///
  /// - [headers]: A map of HTTP headers to include in the request.
  /// - [params]: Optional query parameters to append to the URL.
  /// - [body]: The body of the PUT request, typically in JSON format.
  ///
  /// Returns the response body as a [String] if the update is successful.
  /// Throws an exception with an error message if the request fails.
  Future<String> put({
    required Map<String, String> headers,
    Map<String, dynamic>? params,
    Object? body,
  }) async {
    // Check for internet connectivity before making the request
    if (!(await NetworkUtil.isConnected())) {
      Logger.error('No Internet Connection', null);
      return 'No internet connection';
    }

    try {
      // Construct the full URI with query parameters if provided
      final Uri uri = Uri.parse(url).replace(queryParameters: params ?? {});

      // Make the PUT request with a timeout of 30 seconds
      final http.Response response = await http
          .put(uri, headers: headers, body: body)
          .timeout(const Duration(seconds: 30));

      // If the update was successful (HTTP 200)
      if (response.statusCode == HttpStatus.ok) {
        return response.body; // Return the response body
      } else {
        // Log the error response body
        Logger.error(response.body, null);
        throw Exception(response.body); // Throw an exception with the response body
      }
    } on Exception catch (error, stackTrace) {
      // Log the error with the stack trace for debugging purposes
      Logger.error(error.toString(), stackTrace);
      rethrow; // Re-throw the exception to be handled by the caller
    }
  }
}



