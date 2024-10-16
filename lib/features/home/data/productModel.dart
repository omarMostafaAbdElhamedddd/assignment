class ProductModel {
  final dynamic id;
  final String title;
  final dynamic price;
  final String category;
  final String description;
  final String image;

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.category,
    required this.description,
    required this.image,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      price: json['price'] ?? '',
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'category': category,
      'description': description,
      'image': image,
    };
  }

  @override
  String toString() {
    return 'ProductModel(id: $id, title: $title, price: $price, category: $category, description: $description, image: $image)';
  }
}
