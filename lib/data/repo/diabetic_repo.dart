import 'dart:async';

import 'package:iclinix/data/api/api_client.dart';
import 'package:iclinix/data/models/response/add_patient_model.dart';
import 'package:iclinix/utils/app_constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../models/body/appointment_model.dart';

class DiabeticRepo {
  final ApiClient apiClient;
  DiabeticRepo({required this.apiClient,});


  Future<Response> dailySugarCheckUpRepo(String? beforeMeal,
      String? afterBreakFast,String? afterLunch,
      String? afterDinner, String? randomEntry,String? checkingDate,) {
    return apiClient.postData(AppConstants.dailySugarCheckup,{
      'before_meal' : beforeMeal,
      'after_breakfast' :afterBreakFast,
      'after_lunch' : afterLunch,
      'after_dinner' : afterDinner,
      'random_entry' :randomEntry,
      'checking_date' : checkingDate,
      // 'patient_id' :patientId,
    });
  }

  Future<Response> fetchDailySugarCheckUpRepo() {
    return apiClient.getData(AppConstants.dailySugarCheckup,method: 'GET');
  }
  Future<Response> fetchDashboardDataRepo() {
    return apiClient.getData(AppConstants.diabeticDashboard,method: 'GET');
  }

  Future<Response> healthCheckUpRepo(String? height,
      String? weight,String? waistCircumference,
      String? hipCircumference, String? duraDiabetes,) {
    return apiClient.postData(AppConstants.healthCheckup,{
      'height' : height,
      'weight' :weight,
      'waist_circumference' : waistCircumference,
      'hip_circumference' : hipCircumference,
      'dura_diabetes' :duraDiabetes,
    });
  }


}




