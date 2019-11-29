import random
from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello():
    return 'Hello, World12!'

@app.route('/movie')
def movie():
    movies = ['godfather', 'deadpool', 'toy story', 'top gun', 'forrest gump']
    return random.choice(movies)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
