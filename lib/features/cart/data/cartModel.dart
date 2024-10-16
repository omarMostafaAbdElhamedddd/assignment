
class CartModel {
  final dynamic id;
  final String title;
  final dynamic price;
  final String category;
  final String description;
  final String image;
  final int quntity;

  CartModel({
    required this.id,
    required this.title,
    required this.price,
    required this.category,
    required this.description,
    required this.image,
    required this.quntity
  });

  factory  CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      price: json['price'] ?? '',
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      quntity: 1
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
      'quntity' : 1
    };
  }

  @override
  String toString() {
    return 'ProductModel(id: $id, title: $title, price: $price, category: $category, description: $description, image: $image, quntity : 1)';
  }
}
