
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
        child: ListView.separated(
          itemCount: lists.length,
          separatorBuilder: (BuildContext context, int index) => const Divider(),
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              key: Key(lists[index].name),
              direction: DismissDirection.endToStart,
              child: ListTile(
                leading: Icon(Icons.favorite, color: Globals.accentThemeColor),
                title: Text(lists[index].name),
                onTap: () => _openWishlist(context, lists[index].name),
              ),
              onDismissed: (direction) async {
                String wishlistName = lists[index].name;
                setState(() {
                  lists.removeAt(index);
                });
                await HttpWrapper.deleteWishlist(wishlistName);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Wishlist " + wishlistName + " was removed"),
                  )
                );
              },
              background: Container(
                color: Colors.red,
                child: Align(
                 child: const Padding(child : Icon(Icons.delete, color: Colors.white,), padding: EdgeInsets.all(8),),
                 alignment: Alignment.centerRight,
                )
              ),
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