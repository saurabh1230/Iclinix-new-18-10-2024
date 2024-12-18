import 'package:get/get.dart';
import 'package:iclinix/app/widget/custom_snackbar.dart';
import 'package:iclinix/controller/auth_controller.dart';
import 'package:iclinix/data/api/api_client.dart';
import 'package:iclinix/data/models/response/add_patient_model.dart';
import 'package:iclinix/data/models/response/appointment_history_model.dart';
import 'package:iclinix/data/models/response/patients_model.dart';
import 'package:iclinix/data/models/response/plans_model.dart';
import 'package:iclinix/data/repo/appointment_repo.dart';
import 'package:iclinix/helper/date_converter.dart';
import 'package:iclinix/helper/route_helper.dart';
import 'package:iclinix/utils/images.dart';

import '../app/widget/loading_widget.dart';
import '../data/models/body/appointment_model.dart';
import 'profile_controller.dart';

class AppointmentController extends GetxController implements GetxService {
  final AppointmentRepo appointmentRepo;
  final ApiClient apiClient;

  AppointmentController({required this.appointmentRepo, required this.apiClient});

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
    return selectedBp == 'No' ? '0' : '1';
  }

  bool _isNewPatientEnabled = false;
  bool get isNewPatientEnabled => _isNewPatientEnabled;

  void toggleNewPatientSelection(bool isNewPatient) {
    _isNewPatientEnabled = isNewPatient;
    update();
  }

  bool _isPlanNewPatientEnabled = true;
  bool get isPlanNewPatientEnabled => _isPlanNewPatientEnabled;
  void togglePlanNewPatientSelection([bool? value]) {
    _isPlanNewPatientEnabled = value ?? !_isPlanNewPatientEnabled; // If value is provided, set it. Otherwise, toggle.
    update();
  }

  // void togglePlanNewPatientSelection() {
  //   _isPlanNewPatientEnabled = !_isPlanNewPatientEnabled;
  //   update();
  // }
  List<PlanModel>? _planList;
  List<PlanModel>? get planList => _planList;

  bool _isPlansLoading = false;
  bool get isPlansLoading => _isPlansLoading;

  Future<void> getPlansList() async {
    _isPlansLoading = true;
    update();
    try {
      Response response = await appointmentRepo.getPlansList();
      if (response.statusCode == 200) {
        List<dynamic> responseData = response.body['plans'];
        _planList = responseData.map((json) => PlanModel.fromJson(json)).toList();
        print("Plans fetched successfully: $_planList");
      } else {
        print("Error while fetching Data Error list: ${response.statusCode} - ${response.statusText}");
      }
    } catch (error) {
      print("Error while fetching Plans list: $error");
    }
    _isPlansLoading = false;
    update();
  }

  List<PatientModel>? _patientList;
  List<PatientModel>? get patientList => _patientList;

  bool _isPatientLoading = false;
  bool get isPatientLoading => _isPatientLoading;

  Future<void> getPatientList() async {
    _isPatientLoading = true;
    update();
    try {
      Response response = await appointmentRepo.getPatientList();
      if (response.statusCode == 200) {
        if (response.body != null && response.body['patients'] != null) {
          List<dynamic> responseData = response.body['patients'];
          _patientList = responseData.map((json) => PatientModel.fromJson(json)).toList();
          print("Patients fetched successfully: $_patientList");
        } else {
          print("No patients found in the response.");
          _patientList = [];
        }
      } else {
        print("Error while fetching data. Status code: ${response.statusCode} - ${response.statusText}");
      }
    } catch (error) {
      print("Error while fetching Patient list: $error");
    }
    _isPatientLoading = false;
    update();
  }

  bool _isBookingLoading = false;
  bool get isBookingLoading => _isBookingLoading;

  Future<void> bookAppointmentApi(AppointmentModel appointment) async {
    // _isBookingLoading = true;
    update();
    Response response = await appointmentRepo.bookAppointmentRepo(appointment);
    if (response.statusCode == 200) {
      Get.toNamed(RouteHelper.getBookingSuccessfulRoute(
          appointment.appointmentTime,
          appointment.appointmentDate
      ));
      showCustomSnackBar('Booking Created Successfully');
    } else {
      _isBookingLoading = false;
      update();
      print('Failed to book appointment');
    }
    _isBookingLoading = false;
    update();
  }


  var selectedPatient = ''.obs; // RxString
  var selectedPatientId = 0.obs;

  void selectPatient(int id, String name) {
    selectedPatient.value = name; // Update the name in RxString
    selectedPatientId.value = id; // Update the ID in RxInt
  }

   List<String> paymentMethods = ['Cash', 'Razorpay'];
  List<String> paymentImages= [Images.icCash, Images.icRazorpay];
  var selectedPaymentMethod = 'Cash'.obs; // RxString for selected payment method
  void selectPaymentMethod(String method) {
    selectedPaymentMethod.value = method; // Update the selected payment method
  }

  List<AppointmentHistoryModel>? _appointmentHistoryList;
  List<AppointmentHistoryModel>? get appointmentHistoryList => _appointmentHistoryList;

  bool _isAppointmentHistoryLoading = false;
  bool get isAppointmentHistoryLoading => _isAppointmentHistoryLoading;

  Future<void> getAppointmentHistory() async {
    _isAppointmentHistoryLoading = true;
    LoadingDialog.showLoading(message: "Please wait...");
    update();

    try {
      Response response = await appointmentRepo.getAppointmentList();

      if (response.statusCode == 200) {
        if (response.body != null && response.body['appointmentData'] != null) {
          List<dynamic> responseData = response.body['appointmentData'];

          _appointmentHistoryList = responseData.map((json) => AppointmentHistoryModel.fromJson(json as Map<String, dynamic>)).toList();

          print("Appointment appointmentData fetched successfully: $_appointmentHistoryList");
        } else {
          print("No appointment appointmentData found in the response.");
          _appointmentHistoryList = [];
        }
      } else {
        print("Error while fetching appointment history. Status code: ${response.statusCode} - ${response.statusText}");
      }
    } catch (error) {
      print("Error while fetching appointment history: $error");
    } finally {

      _isAppointmentHistoryLoading = false;
      LoadingDialog.hideLoading();
      update();
    }
  }
  bool _bookingDiabeticType = false;
  bool get bookingDiabeticType => _bookingDiabeticType;


  void selectBookingType(bool val) {
    _bookingDiabeticType = val;
    update();
  }

  Future<void> addPatientApi(
      AddPatientModel addPatient,
      ) async {
    _isLoading = true;
    update();

    Response response = await appointmentRepo.addPatientDetails(addPatient);
    if(response.statusCode == 200) {
      var responseData = response.body;
      if(responseData["message"]  == "Patient added successfully") {
        _isPlanNewPatientEnabled = false;
        getPatientList();
        _isLoading = false;
        update();
        return showCustomSnackBar('Added Successfully', isError: true);
      } else {
        _isLoading = false;
        update();


      }
      _isLoading = false;
      update();
    } else {
      _isLoading = false;
      update();
    }


    _isLoading = false;
    update();
  }

  bool _isPurchasePlanLoading = false;
  bool get isPurchasePlanLoading => _isPurchasePlanLoading;
  Future<void> purchasePlanApi(String? patientId, String? planId, String? paymentMethod) async {
    _isPurchasePlanLoading = true;
    update();

    Response response = await appointmentRepo.purchasePlanApi(patientId, planId, paymentMethod);
    if (response.statusCode == 200) {
      var responseData = response.body;
      if (responseData["message"] == "Subscription created successfully") {
        // Fetch user data to update the subscription status
        await Get.find<AuthController>().userDataApi();
        // Navigate to the successful payment route
        Get.toNamed(RouteHelper.getPlanPaymentSuccessfulRoute());
      } else {
        showCustomSnackBar(responseData["message"], isError: true);
      }
    } else {
      // showCustomSnackBar('Error occurred: ${response.reasonPhrase}', isError: true);
    }

    _isPurchasePlanLoading = false;
    update();
  }




}
