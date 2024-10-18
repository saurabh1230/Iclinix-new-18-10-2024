class PlanModel {
  int planId;
  String planName;
  double price;
  double discount;
  double sellingPrice;
  int discountType;
  int duration;
  String sortDesc;
  String? tagLine; // Nullable because it can be null in the response
  int status;
  List<FeatureModel> features;
  String? createdAt;
  String? updatedAt; // Nullable because it can be null in the response

  PlanModel({
    required this.planId,
    required this.planName,
    required this.price,
    required this.discount,
    required this.sellingPrice,
    required this.discountType,
    required this.duration,
    required this.sortDesc,
    this.tagLine, // Nullable
    required this.status,
    required this.features,
    this.createdAt, // Nullable
    this.updatedAt, // Nullable
  });

  factory PlanModel.fromJson(Map<String, dynamic> json) {
    return PlanModel(
      planId: json['plan_id'],
      planName: json['plan_name'],
      price: json['price'].toDouble(),
      discount: json['discount'].toDouble(),
      sellingPrice: json['selling_price'].toDouble(),
      discountType: json['discount_type'],
      duration: json['duration'],
      sortDesc: json['sort_desc'],
      tagLine: json['tag_line'], // Can be null, so no `!`
      status: json['status'],
      features: (json['features'] as List<dynamic>)
          .map((feature) => FeatureModel.fromJson(feature))
          .toList(),
      createdAt: json['created_at'], // Can be null
      updatedAt: json['update_at'], // Can be null
    );
  }
}

class FeatureModel {
  int id;
  String featureName;
  int sortOrder;
  int status;

  FeatureModel({
    required this.id,
    required this.featureName,
    required this.sortOrder,
    required this.status,
  });

  factory FeatureModel.fromJson(Map<String, dynamic> json) {
    return FeatureModel(
      id: json['id'],
      featureName: json['feature_name'],
      sortOrder: json['sort_order'],
      status: json['status'],
    );
  }
}
