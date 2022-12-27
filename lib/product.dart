class Product{
  int? id;
  String? name;
  String? price;
  String? quantity;



  static Product fromMap(Map<String,dynamic> query){
    Product product = Product();
    product.id = query['id'];
    product.name = query['name'];
    product.price = query['price'];
    product.quantity = query['quantity'];
    return product;

  }

  static Map<String,dynamic> toMap(Product product){
    return <String,dynamic>{
      'id':product.id,
      'name':product.name,
      'price':product.price,
      'quantity':product.quantity,
    };
  }

   static List<Product> fromMapList(List<Map<String,dynamic>> query){
    List<Product> product = <Product>[];
    for (Map<String,dynamic> mp in query){
      product.add(fromMap(mp));
    }
    return product;
  }

}