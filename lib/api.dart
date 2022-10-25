import 'dart:convert';
import 'package:api_app/user.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Api {
  final String baseUrl = 'https://reqres.in';
  // late List _user;
  Future<List> getData({required int pagenumber}) async {
    final http.Response res = await http.get(
      Uri.parse('$baseUrl/api/users?page=$pagenumber'),
    );
    final body = jsonDecode(res.body);
    debugPrint(res.statusCode.toString());
    if (res.statusCode.toString() == "200") {
      final List temp = jsonDecode(res.body)["data"];
      return temp;
    } else {
      throw Error();
    }
  }

  Future<String?> deleteUser(String id) async {
    final http.Response res = await http.delete(
      Uri.parse(
        '$baseUrl/api/users/$id',
      ),
    );
    if (res.statusCode == 204) {
      debugPrint(res.statusCode.toString());
      return "Done";
    }
    return null;
  }

  Future createUser(String name, String job, BuildContext context) async {
    try {
      final http.Response res = await http.post(
          Uri.parse(
            '$baseUrl/api/users/',
          ),
          body: {
            'name': name,
            'job': job,
          });
    } catch (e) {
      throw e;
    }

    // 1.exception handeling
    // 2.network hendeling
    // try catch
    // 3.pagination
    //
  }
}
