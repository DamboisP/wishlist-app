import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wishlist_app/model/wishlist.dart';
import 'package:wishlist_app/utils/globals.dart';
import 'package:wishlist_app/utils/http_wrapper.dart';


class WishlistPage extends StatefulWidget {
  final String wishlistName;

  const WishlistPage({ required this.wishlistName});

  @override
  State<StatefulWidget> createState() {
    return _WishlistPageState();
  }

}

class _WishlistPageState extends State<WishlistPage>{
  late Future<Wishlist> futureWishlist;

  @override
  Widget build(BuildContext context) {

    futureWishlist = HttpWrapper.fetchWishlist(widget.wishlistName);
    return Scaffold(
        appBar: AppBar(title: Text(widget.wishlistName)),
        body : Center(
            child: FutureBuilder<Wishlist>(
              future: futureWishlist,
              builder: (context, snapshot) {
                if (snapshot.hasData){
                  if(snapshot.data!.items.isNotEmpty){
                    return _wishlistItemsDisplay(snapshot.data!.items);
                  }else {
                    return _emptyListMessage();
                  }
                }
                else if (snapshot.hasError){
                  return Text(snapshot.error.toString());
                }
                return CircularProgressIndicator();
              },
              )
        )
    );
  }

  Widget _emptyListMessage(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text("That wishlist is empty", style: Globals.bigTextStyle,),
        const Icon(Icons.sentiment_dissatisfied)
      ],
    );
  }

  Widget _wishlistItemsDisplay(List<WishlistItem> items) {
    return GridView.builder(
      padding: EdgeInsets.all(24),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 20, mainAxisSpacing: 20),
      itemBuilder: (BuildContext ctx, int index) {
        return GridTile(
          child: Container(
            child: Center(
              child: Icon(Icons.favorite, size: 48,)
            ),
            decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.circular(5)
            ),
          ),
          footer: GridTileBar(
            title: Text(items[index].name, textAlign: TextAlign.center, ),
          ),
        );
      },
    );
  }
  


}