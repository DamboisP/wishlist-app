
import 'package:flutter/material.dart';
import 'package:wishlist_app/pages/add_wishlist_popup.dart';
import 'package:wishlist_app/model/wishlist.dart';
import 'package:wishlist_app/pages/wishlist_page.dart';
import 'package:wishlist_app/utils/globals.dart';
import 'package:wishlist_app/utils/http_wrapper.dart';

/// List of all wishlists
class WishlistList extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _WishlistListState();
  }
}

class _WishlistListState extends State<WishlistList> {
  late Future<List<Wishlist>> _futureWishlists;

  _WishlistListState();

  @override
  void initState(){
    super.initState();
    _futureWishlists = HttpWrapper.fetchWishlists();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(
              title: const Text(Globals.appName),
            ),
            body: Center(
              child: FutureBuilder<List<Wishlist>>(
                future: _futureWishlists,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return _getWishlistView(snapshot.data ?? []);
                  }
                  return CircularProgressIndicator();
                },
              ),
            ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () => _showNewWishlistDialog(),
          ),
        );
  }

  void _showNewWishlistDialog() {
    showDialog(
      context: context,
      builder: (BuildContext ctx){
        return AlertDialog(
          title: const Text("Name your new wishlist"),
          content: AddWishlistPopup()
        );
      }
    ).then((_) =>{
      _refreshWishlists()
    });
  }

  Widget _getWishlistView(List<Wishlist> lists) {
    return
        RefreshIndicator(
        child: ListView.builder(
        itemCount: lists.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              leading: Icon(Icons.favorite, color: Globals.accentThemeColor),
              title: Text(lists[index].name),
              onTap: () => _openWishlist(context, lists[index].name),
            );
          },
        ),
        onRefresh: _refreshWishlists
        );
  }

  void _openWishlist(BuildContext context, String name) {
    Navigator.of(context).push(
        MaterialPageRoute(
            builder: (BuildContext ctx) {
              return WishlistPage(wishlistName: name);
            }
        )
    );
  }


  /// Refreshes the wishlist list
  Future<void> _refreshWishlists() async{
    setState(() {
      _futureWishlists = HttpWrapper.fetchWishlists();
    });
  }

}