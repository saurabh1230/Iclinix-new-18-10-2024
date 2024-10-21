class ServicesModel {
  final int id;
  final String name;
  final String image;
  final String description;
  final int sortOrder;
  final int status;
  final DateTime createdAt;
  final DateTime? updatedAt;

  ServicesModel({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.sortOrder,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });


  factory ServicesModel.fromJson(Map<String, dynamic> json) {
    return ServicesModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      description: json['description'],
      sortOrder: json['sort_order'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'description': description,
      'sort_order': sortOrder,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
