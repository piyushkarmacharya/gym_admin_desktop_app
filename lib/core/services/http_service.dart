import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gymmanagementsystem/core/constants/api_url.dart';
import 'package:gymmanagementsystem/core/utils/Result.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class HttpService {
  Map<String, String> _headers = {
    'Content-Type': 'application/json',
  };

  Future<Result<Response>> postRequest(String path, Map<String, dynamic> body) async {
    try {
      final response = await http.post(
        Uri.parse("${ApiUrl.rootUrl}$path"),
        headers: _headers,
        body: jsonEncode(body),
      );
      return Result.value(response);
    } catch (e) {
      return _handleException(e);
    }
  }

  Future<Result<Response>> getRequest(String path) async {
    try {
      final response = await http.get(
        Uri.parse("${ApiUrl.rootUrl}$path"),
        headers: _headers,
      );

      return _handleResponse(response); // Validate response
    } catch (e) {
      return _handleException(e);
    }
  }
  Result<Response> _handleResponse(Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Result.value(response);
    } else {
      String errorMessage = _extractErrorMessage(response);
      return Result.error(ErrorResult(response.statusCode, errorMessage));
    }
  }

  String _extractErrorMessage(Response response) {
    try {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      if (jsonResponse.containsKey("message")) {
        return jsonResponse["message"]; // Extract "message" field from API response
      } else {
        return "Unexpected error occurred";
      }
    } catch (e) {
      return "Failed to parse error response";
    }
  }

  Result<T> _handleException<T>(e) {
    if (e is http.Response) {
      final String message = e.body.isNotEmpty ? e.body : "Unknown error";
      return Result.error(ErrorResult(e.statusCode, message));
    } else if (e is SocketException) {
      return Result.error(ErrorResult(0, "No internet connection. Please try again."));
    } else if (e is HttpException) {
      return Result.error(ErrorResult(0, "Couldn't find the requested resource."));
    } else if (e is FormatException) {
      return Result.error(ErrorResult(0, "Bad response format. Please try again."));
    } else {
      debugPrint(e.toString());
      return Result.error(ErrorResult(0, "Unexpected error occured. Please try again later"));
    }
  }
}
