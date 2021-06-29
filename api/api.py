import flask
from flask import request, abort
from flask.helpers import make_response
from flask.json import jsonify
from datetime import datetime
import time
from tinydb import TinyDB, Query

wishlist_db = TinyDB("wishlists.json")

app = flask.Flask(__name__)
app.config["debug"] = True

# returns all wishlists
@app.route('/', methods=['GET'])
def get_wishlists():
    wishlists = wishlist_db.all()
    result = [{'name' : wl['name']} for wl in wishlists] # not returning whole wishlists in 'all' call
    return make_response(jsonify(result))

# creates a new wishlist
@app.route('/', methods=['POST'])
def new_wishlist():
    if not request.json or not 'name' in request.json:
        abort(400)

    wishlist = {
        'name' : request.json['name']
    }

    wishlist_db.insert(wishlist)

    return make_response(jsonify(True))

# get details from a wishlist
@app.route('/<name>', methods=['GET'])
def get_items(name):
    time.sleep(1) # To test loader
    Wishlists = Query()
    result = wishlist_db.search(Wishlists.name == name)

    if (result is None or len(result) == 0):
        abort(404, description= "Could not find wishlist " + name)

    return make_response(jsonify(result))

# updates a wishlist
@app.route('/<name>', methods=['POST'])
def update_wishlist(name):
    if not request.json or not 'name' in request.json or not 'items' in request.json:
        abort(400)

    Wishlists = Query()
    result = wishlist_db.search(Wishlists.name == name)

    if (result is None or len(result) == 0):
        abort(404, description= "Could not find wishlist " + name)

    wishlist_db.update({'items': request.json['items']}, Wishlists.name == name)

    return make_response(jsonify(True))

app.run(debug=True)