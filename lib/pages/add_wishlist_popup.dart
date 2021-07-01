
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wishlist_app/utils/http_wrapper.dart';

class AddWishlistPopup extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _AddWishlistPopupState();
  }
}

class _AddWishlistPopupState extends State<AddWishlistPopup>{
  final _formKey = GlobalKey<FormState>();
  final _inputFielController = TextEditingController();
  var _isLoading = false;

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
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
                onPressed: () async {
                  if(_formKey.currentState!.validate()){
                    setState(() {
                      _isLoading = true;
                    });
                    await HttpWrapper.addWishlist(_inputFielController.text);
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