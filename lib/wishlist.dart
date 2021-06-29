class Wishlist {
  List<WishlistItem> items;
  final String name;

  Wishlist({
    required this.name,
    this.items = const []
  });

  factory Wishlist.fromJson(Map<String, dynamic> json){
    Wishlist list = Wishlist(name: json["name"]);

    if (json["items"] != null) {
      list.items = (json["items"] as List).map((item) => WishlistItem.fromJson(item)).toList();
    }

    return list;
  }

}

class WishlistItem {
  final String name;

  WishlistItem({
    required this.name
  });
  
  factory WishlistItem.fromJson(Map<String, dynamic> json){
    return WishlistItem(name: json["name"]);
  }
}