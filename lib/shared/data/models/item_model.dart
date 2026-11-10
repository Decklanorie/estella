class Item {
  int id;
  String title;
  String price;
  String description;
  List<String> images;

  Item({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.images
  });

  factory Item.fromJson(Map<String, dynamic> json){
    return Item(
        id: json['id'],
        title: json['title'],
        price: json['price'],
        description: json['description'],
        images: json['images']
    );
    }
  }
