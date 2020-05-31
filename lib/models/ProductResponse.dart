class ProductResponse {
  List<Categories> categories;
  List<Rankings> rankings;

  ProductResponse({this.categories, this.rankings});

  ProductResponse.fromJson(Map<String, dynamic> json) {
    if (json['categories'] != null) {
      categories = new List<Categories>();
      json['categories'].forEach((v) {
        categories.add(new Categories.fromJson(v));
      });
    }
    if (json['rankings'] != null) {
      rankings = new List<Rankings>();
      json['rankings'].forEach((v) {
        rankings.add(new Rankings.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.categories != null) {
      data['categories'] = this.categories.map((v) => v.toJson()).toList();
    }
    if (this.rankings != null) {
      data['rankings'] = this.rankings.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Categories {
  int _id;
  String _name;
  List<Products> _products;
  List<int> _childCategories;

  Categories(
      {int id,
        String name,
        List<Products> products,
        List<int> childCategories}) {
    this._id = id;
    this._name = name;
    this._products = products;
    this._childCategories = childCategories;
  }

  int get id => _id;
  set id(int id) => _id = id;
  String get name => _name;
  set name(String name) => _name = name;
  List<Products> get products => _products;
  set products(List<Products> products) => _products = products;
  List<int> get childCategories => _childCategories;
  set childCategories(List<int> childCategories) =>
      _childCategories = childCategories;

  Categories.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    if (json['products'] != null) {
      _products = new List<Products>();
      json['products'].forEach((v) {
        _products.add(new Products.fromJson(v));
      });
    }
    _childCategories = json['child_categories'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    if (this._products != null) {
      data['products'] = this._products.map((v) => v.toJson()).toList();
    }
    data['child_categories'] = this._childCategories;
    return data;
  }
}

class Products {
  int _id;
  String _name;
  String _dateAdded;
  final String costPrice = "999";
  final String price = "799";
  final double avgRating = 3.0;

  List<Variants> _variants;
  Tax _tax;

  Products(
      {int id,
        String name,
        String dateAdded,
        List<Variants> variants,
        Tax tax}) {
    this._id = id;
    this._name = name;
    this._dateAdded = dateAdded;
    this._variants = variants;
    this._tax = tax;
  }

  int get id => _id;
  set id(int id) => _id = id;
  String get name => _name;
  set name(String name) => _name = name;
  String get dateAdded => _dateAdded;
  set dateAdded(String dateAdded) => _dateAdded = dateAdded;
  List<Variants> get variants => _variants;
  set variants(List<Variants> variants) => _variants = variants;
  Tax get tax => _tax;
  set tax(Tax tax) => _tax = tax;

  Products.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _dateAdded = json['date_added'];
    if (json['variants'] != null) {
      _variants = new List<Variants>();
      json['variants'].forEach((v) {
        _variants.add(new Variants.fromJson(v));
      });
    }
    _tax = json['tax'] != null ? new Tax.fromJson(json['tax']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['date_added'] = this._dateAdded;
    if (this._variants != null) {
      data['variants'] = this._variants.map((v) => v.toJson()).toList();
    }
    if (this._tax != null) {
      data['tax'] = this._tax.toJson();
    }
    return data;
  }
}

class Variants {
  int _id;
  String _color;
  int _size;
  int _price;

  Variants({int id, String color, int size, int price}) {
    this._id = id;
    this._color = color;
    this._size = size;
    this._price = price;
  }

  int get id => _id;
  set id(int id) => _id = id;
  String get color => _color;
  set color(String color) => _color = color;
  int get size => _size;
  set size(int size) => _size = size;
  int get price => _price;
  set price(int price) => _price = price;

  Variants.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _color = json['color'];
    _size = json['size'];
    _price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['color'] = this._color;
    data['size'] = this._size;
    data['price'] = this._price;
    return data;
  }
}

class Tax {
  String _name;
  dynamic _value;

  Tax({String name, dynamic value}) {
    this._name = name;
    this._value = value;
  }

  String get name => _name;
  set name(String name) => _name = name;
  dynamic get value => _value;
  set value(dynamic value) => _value = value;

  Tax.fromJson(Map<String, dynamic> json) {
    _name = json['name'];
    _value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this._name;
    data['value'] = this._value;
    return data;
  }
}

class Rankings {
  String _ranking;
  List<ProductRank> _productRank;

  Rankings({String ranking, List<ProductRank> productRank}) {
    this._ranking = ranking;
    this._productRank = productRank;
  }

  String get ranking => _ranking;
  set ranking(String ranking) => _ranking = ranking;
  List<ProductRank> get productRank => _productRank;
  set productRank(List<ProductRank> productRank) => _productRank = productRank;

  Rankings.fromJson(Map<String, dynamic> json) {
    _ranking = json['ranking'];
    if (json['products'] != null) {
      _productRank = new List<ProductRank>();
      json['products'].forEach((v) {
        _productRank.add(new ProductRank.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ranking'] = this._ranking;
    if (this._productRank != null) {
      data['products'] = this._productRank.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductRank {
  int _id;
  int _viewCount;
  int _orderCount;
  int _shares;

  ProductRank({int id, int viewCount, int orderCount, int shares}) {
    this._id = id;
    this._viewCount = viewCount;
    this._orderCount = orderCount;
    this._shares = shares;
  }

  int get id => _id;
  set id(int id) => _id = id;
  int get viewCount => _viewCount;
  set viewCount(int viewCount) => _viewCount = viewCount;
  int get orderCount => _orderCount;
  set orderCount(int orderCount) => _orderCount = orderCount;
  int get shares => _shares;
  set shares(int shares) => _shares = shares;

  ProductRank.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _viewCount = json['view_count'];
    _orderCount = json['order_count'];
    _shares = json['shares'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['view_count'] = this._viewCount;
    data['order_count'] = this._orderCount;
    data['shares'] = this._shares;
    return data;
  }
}
