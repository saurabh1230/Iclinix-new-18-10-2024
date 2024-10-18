
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get.dart';
import 'package:iclinix/data/api/api_client.dart';
import 'package:iclinix/data/models/response/clinic_model.dart';
import 'package:iclinix/data/models/response/plans_model.dart';
import 'package:iclinix/data/models/response/search_model.dart';
import 'package:iclinix/data/models/response/services_model.dart';
import 'package:iclinix/data/repo/appointment_repo.dart';
import 'package:iclinix/data/repo/clinic_repo.dart';
import 'package:iclinix/helper/date_converter.dart';

class ClinicController extends GetxController implements GetxService {
  final ClinicRepo clinicRepo;
  final ApiClient apiClient;
  ClinicController({required this.clinicRepo, required this.apiClient});

  bool _isLoading = false;
  bool get isLoading => _isLoading;



  List<ClinicModel>? _clinicList;
  List<ClinicModel>? get clinicList => _clinicList;

  bool _isClinicLoading = false;
  bool get isClinicLoading => _isClinicLoading;

  Future<void> getClinicList() async {
    _isClinicLoading = true;
    update();
    try {
      Response response = await clinicRepo.getClinicList();
      if (response.statusCode == 200) {
        List<dynamic> responseData = response.body['branches'];
        _clinicList = responseData.map((json) => ClinicModel.fromJson(json)).toList();
        print("Plans fetched successfully: $_clinicList");
      } else {
        print("Error while fetching Data Error clinic list: ${response.statusCode} - ${response.statusText}");
      }
    } catch (error) {
      print("Error while fetching Plans list: $error");
    }
    _isClinicLoading = false;
    update();
  }


  List<ServicesModel>? _servicesList;
  List<ServicesModel>? get servicesList => _servicesList;

  bool _isServicesLoading = false;
  bool get isServicesLoading => _isServicesLoading;

  Future<void> getServicesList() async {
    _isServicesLoading = true;
    update();
    try {
      Response response = await clinicRepo.getServicesList();
      if (response.statusCode == 200) {
        List<dynamic> responseData = response.body['services'];
        _servicesList = responseData.map((json) => ServicesModel.fromJson(json)).toList();
        print("Plans fetched successfully: $_servicesList");
      } else {
        print("Error while fetching Data Error services list: ${response.statusCode} - ${response.statusText}");
      }
    } catch (error) {
      print("Error while fetching Plans list: $error");
    }
    _isServicesLoading = false;
    update();
  }



  List<SearchModel>? _searchList = [];
  List<SearchModel>? get searchList => _searchList;

  bool _isSearchLoading = false;
  bool get isSearchLoading => _isSearchLoading;

  void clearSearchList() {
    _searchList = []; // Clear the search list
    update(); // Notify listeners
  }

  Future<void> getSearchList(String? query) async {
    _isSearchLoading = true;
    update();
    try {
      Response response = await clinicRepo.getSearchList(query);
      if (response.statusCode == 200) {
        List<dynamic> responseData = response.body['searchResponse']['branch'];
        _searchList = responseData.map((json) => SearchModel.fromJson(json)).toList();
        print("Plans fetched successfully: $_searchList");
      } else {
        print("Error while fetching Data Error services list: ${response.statusCode} - ${response.statusText}");
      }
    } catch (error) {
      print("Error while fetching Plans list: $error");
    }
    _isSearchLoading = false;
    update();
  }






}