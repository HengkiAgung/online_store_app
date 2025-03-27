class ProductModel {
  final int id;
  final String sku;
  final String name;
  final String description;
  final int? weight;
  final int? width;
  final int? length;
  final int? height;
  final String image;
  final int price;

  ProductModel({
    required this.id,
    required this.sku,
    required this.name,
    required this.description,
    this.weight,
    this.width,
    this.length,
    this.height,
    required this.image,
    required this.price,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      sku: json['sku'],
      name: json['name'],
      description: json['description'],
      weight: json['weight'],
      width: json['width'],
      length: json['length'],
      height: json['height'],
      image: json['image'],
      price: json['price'],
    );
  }
}
