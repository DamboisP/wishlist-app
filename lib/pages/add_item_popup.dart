
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icon_picker/icon_picker.dart';
import 'package:wishlist_app/model/wishlist.dart';
import 'package:wishlist_app/utils/http_wrapper.dart';

class AddItemPopup extends StatefulWidget{
  final String wishlistName;

  AddItemPopup({required this.wishlistName});


  @override
  State<StatefulWidget> createState() {
    return _AddItemPopupState();
  }
}

class _AddItemPopupState extends State<AddItemPopup>{
  final _formKey = GlobalKey<FormState>();
  final _inputFielController = TextEditingController();
  var _isLoading = false;
  var _currentIcon = Icon(Icons.favorite, color: Colors.grey);

  @override
  Widget build(BuildContext context) {
    return _isLoading ? Center(child: CircularProgressIndicator(), heightFactor: 1.5,) : Form(
      key: _formKey,
      child :  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _inputFielController,
            decoration: const InputDecoration(
                icon: Icon(Icons.border_color),
                labelText: "Name"
            ),
            validator: (value) {
              if (value == null || value.isEmpty)
                return "Please enter a name !";

              return null;
            },
          ),
          Row(
            children: [
              _currentIcon,
              Expanded(
                child: Padding(child: IconPicker(
                  enableSearch: false,
                  initialValue: "favorite",
                  labelText: "Icon",
                  onChanged: (value){
                    var iconDataJson = jsonDecode(value);
                    IconData icon = IconData(iconDataJson['codePoint'], fontFamily: iconDataJson['fontFamily']);

                    setState(() {
                      _currentIcon = Icon(icon, color: Colors.grey,);
                    });
                  },
                ),padding: EdgeInsets.only(left: 15),
                )
              )
            ],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
                onPressed: () async {
                  if(_formKey.currentState!.validate()){
                    setState(() {
                      _isLoading = true;
                    });
                    final item = WishlistItem(name: _inputFielController.text, icon: _currentIcon);
                    await HttpWrapper.addItemToWishlist(widget.wishlistName, item);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Submit')
            ),
          )
        ],
      ),
    );
  }

}