import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mobile_smarcerti/app/data/models/user_model.dart';
import 'package:mobile_smarcerti/app/data/models/pelatihan_model.dart';
import 'package:mobile_smarcerti/app/utils/constant.dart';
import 'package:mobile_smarcerti/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileService {
  final ApiService apiService;

  ProfileService(this.apiService);
  final Dio _dio = Dio()
    ..options = BaseOptions(
      validateStatus: (status) {
        return status != null && status <= 500;
      },
      followRedirects: true,
      receiveTimeout: const Duration(seconds: 15),
      connectTimeout: const Duration(seconds: 15),
    );

  Future<String?> getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('auth_token');
    return token;
  }

  /// Fungsi untuk menyimpan response JSON ke model Pelatihan
  // Pelatihan saveJsonToPelatihanModel(String responseJson) {
  //   try {
  //     // Decode JSON string menjadi Map
  //     final Map<String, dynamic> jsonData = json.decode(responseJson);

  //     // Validasi apakah struktur data sesuai
  //     if (jsonData.containsKey('success') &&
  //         jsonData.containsKey('message') &&
  //         jsonData.containsKey('data')) {
  //       // Parsing ke model Pelatihan
  //       final pelatihanModel = Pelatihan.fromJson(jsonData);
  //       print('Data berhasil disimpan ke model Pelatihan');
  //       return pelatihanModel;
  //     } else {
  //       throw Exception('JSON tidak sesuai dengan struktur model Pelatihan');
  //     }
  //   } catch (e) {
  //     print('Error parsing JSON to Pelatihan model: $e');
  //     throw Exception('Gagal menyimpan data ke model Pelatihan: $e');
  //   }
  // }

  // Fungsi untuk mendapatkan data pelatihan
  Future<List<User>> getProfiles() async {
    final token = await getToken(); // Ambil token dari helper atau auth service
    if (token == null) throw Exception("Token not found");

    try {
      final response = await _dio.get(
        '${ApiConstants.baseUrl}profiles',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        // Mengakses data yang berada dalam pelatihans -> data
        print(response.data);
        var json = response.data;
        final parsed = json['data'].cast<Map<String, dynamic>>();
        print("parsed data : $parsed");
        return parsed
            .map<User>((json) => User.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load pelatihans');
      }
    } catch (e) {
      print('Error fetching pelatihans: $e');
      throw Exception('Error fetching pelatihans: $e');
    }
  }
}