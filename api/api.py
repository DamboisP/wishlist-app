import flask
from flask.helpers import make_response
from flask.json import jsonify
from datetime import datetime
import time

app = flask.Flask(__name__)
app.config["debug"] = True

@app.route('/', methods=['GET'])
def home():
    response = _generate_wishlists()

    return make_response(jsonify(response))

@app.route('/<name>', methods=['GET'])
def get_items(name):
    time.sleep(1) # To test loader
    response = {
        "name" : name,
        "items" : _generate_items()
    }

    return make_response(jsonify(response))

def _generate_wishlists():
    wishlists = []

    for i in range(10):
        wishlists.append(
            { "name" : "Wishlist " + str(i + 1) }
        )
    return wishlists

def _generate_items():
    items = []

    for i in range(5):
        items.append(
            { "name" : "Item " + str(i + 1) }
        )
    return items

app.run()