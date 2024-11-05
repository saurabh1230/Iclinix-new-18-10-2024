import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iclinix/app/widget/custom_snackbar.dart';
import 'package:iclinix/data/api/api_client.dart';
import 'package:iclinix/data/models/response/diabetic_dashboard_detail_model.dart';
import 'package:iclinix/data/models/response/sugar_checkup_model.dart';
import 'package:iclinix/data/repo/diabetic_repo.dart';
import 'package:iclinix/helper/date_converter.dart';

import '../data/models/response/user_data.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';



class DiabeticController extends GetxController implements GetxService {
  final DiabeticRepo diabeticRepo;
  final ApiClient apiClient;

  DiabeticController({required this.diabeticRepo, required this.apiClient});

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  @override
  void onInit() {
    super.onInit();
    formattedDate = SimpleDateConverter.formatDateToCustomFormat(selectedDate);
  }


  DateTime selectedDate = DateTime.now(); // Default to current date
  String? formattedDate;



  void updateDate(DateTime newDate) {
    selectedDate = newDate;
    formattedDate = SimpleDateConverter.formatDateToCustomFormat(selectedDate);
    update(); // Trigger GetX update to refresh UI if necessary
  }
  String selectedValue = '';

  bool showHistory = false;

  void toggleShowHistory(bool value) {
    showHistory = value;
    update();
  }

  String? selectedTime;
  List<String> timeSlot = [
    '12:30',
    '1:00',
    '2:00',
    '3:00',
    '4:00',
    '5:00',
    '6:00',
    '7:00',
    '8:00',
  ];

  void selectTimeSlot(int index) {
    selectedTime = timeSlot[index];
    print("Selected Time: $selectedTime");
    update(); // Update the state
  }

  var selectedInitial = 'Mr';
  var selectedGender = 'Male';
  final List<String> genderOptions = ['Male', 'Female'];

  String getGenderStatus() {
    return '${selectedGender == 'Male' ? 'M' : 'F'}';
  }

  void updateGender(String gender) {
    selectedGender = gender;
    selectedInitial = (selectedGender == 'Male') ? 'Mr' : 'Mrs';
    update();
  }

  DateTime? selectedDobDate;
  String? formattedDobDate;

  void updateDobDate(DateTime newDate) {
    selectedDobDate = newDate;
    formattedDobDate = SimpleDateConverter.formatDateToCustomFormat(selectedDobDate!);
    update();
  }

  var selectedDiabetes = 'No';
  final List<String> diabetesOptions = ['No', 'Yes'];

  void updateDiabetes(String val) {
    selectedDiabetes = val;
    update();
  }

  String getDiabetesStatus() {
    return '${selectedDiabetes == 'No' ? '0' : '1'}';
  }

  var selectedGlasses = 'No';
  final List<String> glassesOptions = ['No', 'Yes'];

  void updateGlasses(String val) {
    selectedGlasses = val;
    update();
  }

  String getGlassesStatus() {
    return '${selectedGlasses == 'No' ? '0' : '1'}';
  }

  var selectedBp = 'No';
  final List<String> bpOptions = ['No', 'Yes'];

  void updateHealth(String val) {
    selectedBp = val;
    update();
  }

  String getBpStatus() {
    return '${selectedBp == 'No' ? '0' : '1'}';
  }

  String extractVideoId(String url) {
    // Use RegExp to extract the video ID from the URL
    final RegExp regExp = RegExp(
      r'(?<=v=|\/)([0-9A-Za-z_-]{11})',
      caseSensitive: false,
    );
    final match = regExp.firstMatch(url);
    return match != null ? match.group(0) ?? '' : '';
  }

  bool _isDailySugarCheckupLoading = false;
  bool get isDailySugarCheckupLoading => _isDailySugarCheckupLoading;

  Future<void> addSugarApi(String? beforeMeal, String? afterBreakFast, String? afterLunch, String? afterDinner, String? randomEntry,String? checkingDate) async {
    _isDailySugarCheckupLoading = true;
    update();
    Response response = await diabeticRepo.dailySugarCheckUpRepo(
        beforeMeal,afterBreakFast,afterLunch, afterDinner,randomEntry,checkingDate
    );
    if(response.statusCode == 200) {
      var responseData = response.body;
      if(responseData["msg"]  == "Data Inserted Successfully") {
        _isDailySugarCheckupLoading = false;
        update();
        Get.back();
        return showCustomSnackBar('Added Successfully', );
      } else {
        showCustomSnackBar(responseData["msg"], isError: true);
        _isDailySugarCheckupLoading = false;
        update();
      }
      _isDailySugarCheckupLoading = false;
      update();
    } else {
      _isDailySugarCheckupLoading = false;
      update();
    }
    _isDailySugarCheckupLoading = false;
    update();
  }

  List<SugarCheckupModel>? _sugarCheckUpList;
  List<SugarCheckupModel>? get sugarCheckUpList => _sugarCheckUpList;

  Future<void> getSugarCheckUpHistory() async {
    _isDailySugarCheckupLoading = true;
    update();
    try {
      Response response = await diabeticRepo.fetchDailySugarCheckUpRepo();
      if (response.statusCode == 200) {
        print("Full API Response: ${response.body}");
        if (response.body != null && response.body.containsKey('dailyChekupsList')) {
          List<dynamic> responseData = response.body['dailyChekupsList'];
          _sugarCheckUpList = responseData.map((json) => SugarCheckupModel.fromJson(json as Map<String, dynamic>)).toList();
          print("Appointment dailyChekupsList fetched successfully: $_sugarCheckUpList");
          } else {
          print("No dailyChekupsList key found in the response.");
          _sugarCheckUpList = [];
          }
      } else {
        print("Error while fetching dailyChekupsList history. Status code: ${response.statusCode} - ${response.statusText}");
      }
    } catch (error) {
      print("Error while fetching dailyChekupsList history: $error");
    } finally {
      _isDailySugarCheckupLoading = false;
      update();
    }
  }


  List<SugarChartModel>? _sugarChartList;




  List<SugarChartModel>? get sugarChartList => _sugarChartList;

  DietPlanModel? get dietPlan => _dietPlan;
  DietPlanModel? _dietPlan;
  PlanDetailsModel? _planDetails;
  PlanDetailsModel? get planDetails => _planDetails;

  List<PlanResourceModel> videoResources = [];
  List<PlanResourceModel> imageResources = [];
  List<PlanResourceModel> pdfResources = [];
  List<PlanResourceModel> textResources = [];

  Future<void> getDiabeticDashboard() async {
    _isDailySugarCheckupLoading = true;
    update();
    try {
      Response response = await diabeticRepo.fetchDashboardDataRepo();

      if (response.statusCode == 200) {
        var data = response.body['data'];

        if (data != null) {
          // Process monthly sugar values if they exist
          if (data.containsKey('monthlySugerValues') && data['monthlySugerValues'] != null) {
            List<dynamic> monthlyValues = data['monthlySugerValues'];
            _sugarChartList = monthlyValues
                .map((json) => SugarChartModel.fromJson(json as Map<String, dynamic>))
                .toList();
            print("Sugar Checkup List fetched successfully: $_sugarChartList");
          } else {
            _sugarChartList = [];
            print("No monthlySugerValues key found in the response.");
          }

          // Process diet plan
          if (data.containsKey('dietPlan') && data['dietPlan'] != null) {
            _dietPlan = DietPlanModel.fromJson(data['dietPlan'] as Map<String, dynamic>);
            print("Diet Plan fetched successfully: $_dietPlan");
          } else {
            _dietPlan = null;
            print("No dietPlan key found in the response.");
          }

          // Process plan details and resources
          if (data.containsKey('planDetails') && data['planDetails'] != null) {
            var planDetailsData = data['planDetails'];
            _planDetails = PlanDetailsModel.fromJson(planDetailsData);

            // Clear previous resources
            videoResources.clear();
            imageResources.clear();
            pdfResources.clear();
            textResources.clear();

            // Categorize resources by type
            if (planDetailsData.containsKey('attachedPlanResources') && planDetailsData['attachedPlanResources'] != null) {
              for (var resourceData in planDetailsData['attachedPlanResources']) {
                final PlanResourceModel resource = PlanResourceModel.fromJson(resourceData);
                switch (resource.type) {
                  case 1:
                    videoResources.add(resource);
                    break;
                  case 2:
                    imageResources.add(resource);
                    break;
                  case 3:
                    pdfResources.add(resource);
                    break;
                  case 4:
                    textResources.add(resource);
                    break;
                  default:
                    print("Unknown resource type: ${resource.type}");
                }
              }
              print('Text Resources Length: ${textResources.length}');
            } else {
              print("No attachedPlanResources found in planDetails.");
            }
          } else {
            print("No planDetails key found in the response.");
          }
        } else {
          print("No data found in the response.");
        }
      } else {
        print("Error fetching dashboard data. Status code: ${response.statusCode}");
      }
    } catch (error) {
      print("Error fetching diabetic dashboard data: $error");
    } finally {
      _isDailySugarCheckupLoading = false;
      update();
    }
  }



  Future<void> addHealthApi(String? height, String? weight, String? waistCircumference,
      String? hipCircumference, String? duraDiabetes) async {
    _isDailySugarCheckupLoading = true;
    update();
    Response response = await diabeticRepo.healthCheckUpRepo(height,weight,waistCircumference,
        hipCircumference,duraDiabetes,);
    if(response.statusCode == 200) {
      var responseData = response.body;
      if(responseData["msg"]  == "Data updated successfully") {
        Get.back();
        _isDailySugarCheckupLoading = false;
        update();
        return showCustomSnackBar('Added Successfully', );
      } else {
        showCustomSnackBar(responseData["msg"], isError: true);
        _isDailySugarCheckupLoading = false;
        update();
      }
      _isDailySugarCheckupLoading = false;
      update();
    } else {
      _isDailySugarCheckupLoading = false;
      update();
    }
    _isDailySugarCheckupLoading = false;
    update();
  }



  bool _userDataLoading = false;
  bool get userDataLoading => _userDataLoading;


  UserData? _userData;
  PatientData? _patientData;

  UserData? get userData => _userData;
  PatientData? get patientData => _patientData;

  bool _isResourceDetailsLoading = false;
  bool get isResourceDetailsLoading => _isResourceDetailsLoading;

  PlanResourceModel? _resourceDetail;
  PlanResourceModel? get resourceDetail => _resourceDetail;

  Future<PlanResourceModel?> getResourceDetailsApi(String id) async {
    _isResourceDetailsLoading = true;
    _resourceDetail = null;
    update();

    try {
      Response response = await diabeticRepo.fetchResourceContentRepo(id);
      if (response.statusCode == 200) {
        final data = response.body['data'];
        _resourceDetail = PlanResourceModel.fromJson(data);
      } else {
        // Handle non-200 status codes
        print("Failed to resourceDetail data: ${response.statusCode}");
        // ApiChecker.checkApi(response);
      }
    } catch (e) {
      // Handle exceptions
      print("Exception occurred: $e");
    }
    _isResourceDetailsLoading = false;
    update();
    return _resourceDetail;
  }



  Future<void> downloadImage(String url, String imageName) async {
    if (await Permission.storage.isDenied) {
      PermissionStatus status = await Permission.storage.request();
      if (!status.isGranted) {
        // If permission is denied, show a dialog
        Get.defaultDialog(
          title: "Permission Required",
          content: const Text("Please enable storage permission to download the image."),
          actions: [
            TextButton(
              onPressed: () => openAppSettings(),
              child: const Text("Open Settings"),
            ),
            TextButton(
              onPressed: () => Get.back(),
              child: const Text("Cancel"),
            ),
          ],
        );
        return;
      }
    }

    // Continue to download if permission is granted
    if (await Permission.storage.isGranted) {
      try {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final directory = await getExternalStorageDirectory();
          final filePath = '${directory!.path}/$imageName.jpg';
          final file = File(filePath);
          await file.writeAsBytes(response.bodyBytes);
          Get.snackbar("Download", "Image saved to $filePath",
              snackPosition: SnackPosition.BOTTOM);
        } else {
          Get.snackbar("Download Failed", "Unable to download image",
              snackPosition: SnackPosition.BOTTOM);
        }
      } catch (e) {
        Get.snackbar("Error", "Failed to save image: $e",
            snackPosition: SnackPosition.BOTTOM);
      }
    } else {
      Get.snackbar("Permission Denied", "Storage permission is required",
          snackPosition: SnackPosition.BOTTOM);
    }
  }






}
