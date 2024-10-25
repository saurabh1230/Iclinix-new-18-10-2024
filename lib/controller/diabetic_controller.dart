import 'package:get/get.dart';
import 'package:iclinix/app/widget/custom_snackbar.dart';
import 'package:iclinix/data/api/api_client.dart';
import 'package:iclinix/data/models/response/diabetic_dashboard_detail_model.dart';
import 'package:iclinix/data/models/response/sugar_checkup_model.dart';
import 'package:iclinix/data/repo/diabetic_repo.dart';
import 'package:iclinix/helper/date_converter.dart';




class DiabeticController extends GetxController implements GetxService {
  final DiabeticRepo diabeticRepo;
  final ApiClient apiClient;

  DiabeticController({required this.diabeticRepo, required this.apiClient});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  DateTime? selectedDate;
  String? formattedDate;

  void updateDate(DateTime newDate) {
    selectedDate = newDate;
    formattedDate = SimpleDateConverter.formatDateToCustomFormat(selectedDate!);
    update();
  }
  String selectedValue = '';

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

  bool _isDailySugarCheckupLoading = false;
  bool get isDailySugarCheckupLoading => _isDailySugarCheckupLoading;

  Future<void> addSugarApi(String? beforeMeal, String? afterBreakFast, String? afterLunch,
      String? afterDinner, String? randomEntry,String? checkingDate) async {
    _isDailySugarCheckupLoading = true;
    update();
    Response response = await diabeticRepo.dailySugarCheckUpRepo(beforeMeal,afterBreakFast,afterLunch,
        afterDinner,randomEntry,checkingDate
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
  PlanDetailsModel? _planDetails;
  DietPlanModel? _dietPlan;


  List<SugarChartModel>? get sugarChartList => _sugarChartList;
  PlanDetailsModel? get planDetails => _planDetails;
  DietPlanModel? get dietPlan => _dietPlan;

  Future<void> getDiabeticDashboard() async {
    _isDailySugarCheckupLoading = true;
    update();

    try {
      Response response = await diabeticRepo.fetchDashboardDataRepo();
      if (response.statusCode == 200) {
        print("Full API Response: ${response.body}");
        var data = response.body['data'];
        // Parse monthlySugerValues
        if (data != null && data.containsKey('monthlySugerValues')) {
          List<dynamic> monthlyValues = data['monthlySugerValues'];
          _sugarChartList = monthlyValues
              .map((json) => SugarChartModel.fromJson(json as Map<String, dynamic>))
              .toList();
          print("Sugar Checkup List fetched successfully: $_sugarChartList");
        } else {
          print("No monthlySugerValues key found in the response.");
          _sugarChartList = [];
        }
        // Parse planDetails
        if (data != null && data.containsKey('planDetails')) {
          _planDetails = PlanDetailsModel.fromJson(data['planDetails']);
          print("Plan details fetched successfully: $_planDetails");
        } else {
          print("No planDetails key found in the response.");
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





}
