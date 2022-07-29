class Category {
  final String name;
  final String icon;

  Category({required this.name, required this.icon});

  static Category fromJson(json) => Category(
        name: json['name'],
        icon: json['icon'],
      );
}

  // static Category fromJson(Map<String, dynamic> json){
  //   return Category(
  //     name: json['name'],
  //     color: Color(json['color']),
  //   );
  // }

